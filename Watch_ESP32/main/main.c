#include <stdio.h>
#include <stdio.h>
#include <math.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensors.h"
#include "ssd1306.h"
#include "display.h"
#include "wifi.h"
#include "esp_sleep.h"
#include "mqtt_client.h"
#include "cJSON.h"

#define RESOLUTION_TMP 0x60
#define TAG "SMART_WATCH"


int connected = false;
int trying = false;
SSD1306_t dev;

void url_decode(char *dst, const char *src, int len) {
    char a, b;
    while (*src && len--) {
        if ((*src == '%') && ((a = src[1]) && (b = src[2])) && (isxdigit(a) && isxdigit(b))) {
            if (a >= 'a') a -= 'a' - 'A';
            if (a >= 'A') a -= ('A' - 10);
            else a -= '0';
            if (b >= 'a') b -= 'a' - 'A';
            if (b >= 'A') b -= ('A' - 10);
            else b -= '0';
            *dst++ = 16 * a + b;
            src += 3;
        } else if (*src == '+') {
            *dst++ = ' ';
            src++;
        } else {
            *dst++ = *src++;
        }
    }
    *dst = '\0';
}

void wifi_init_softap() {
    ESP_LOGI("WIFI", "INICIO MODO SERVIDOR!!");
    display_connect_wifi(&dev);
    wifi_config_t wifi_ap_config = {
        .ap = {
            .ssid = CONFIG_SSID,
            .ssid_len = strlen(CONFIG_SSID),
            .channel = CONFIG_CHANNEL,
            .password = CONFIG_PSWD,
            .max_connection = CONFIG_MAX_CONECTION,
            .authmode = WIFI_AUTH_WPA_WPA2_PSK
        },
    };
    if (strlen("12345678") == 0) {
        wifi_ap_config.ap.authmode = WIFI_AUTH_OPEN;
    }

    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_AP));  // Modo AP
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_AP, &wifi_ap_config));
    ESP_ERROR_CHECK(esp_wifi_start());

    ESP_LOGI("WIFI", "Punto de acceso configurado. SSID: %s", wifi_ap_config.ap.ssid);
}

static void event_handler(void* arg, esp_event_base_t event_base,
                                int32_t event_id, void* event_data)
{
    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_START) {
        esp_wifi_connect();
    } else if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED) {
        if (s_retry_num < MAXIMUM_RETRY) {
            esp_wifi_connect();
            s_retry_num++;
            trying = true;
            //display_trying_connect(&dev);
            ESP_LOGW("WIFI", "retry to connect to the AP");
            display_trying_connect(&dev);
        } else {
            xEventGroupSetBits(s_wifi_event_group, WIFI_FAIL_BIT);
            trying = false;
            wifi_init_softap();
        }
        ESP_LOGW("WIFI","connect to the AP fail");
    } else if (event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP) {
        ip_event_got_ip_t* event = (ip_event_got_ip_t*) event_data;
        ESP_LOGI("WIFI", "got ip:" IPSTR, IP2STR(&event->ip_info.ip));
        s_retry_num = 0;
        xEventGroupSetBits(s_wifi_event_group, WIFI_CONNECTED_BIT);
    }
}

void wifi_init_sta(){
    s_wifi_event_group = xEventGroupCreate();
    const char* filepath = "/spiffs/wifiText.txt";

    FILE *archivo;
    char ssidReg[64], passwordReg[64];
    archivo = fopen(filepath, "r");
    
    if (archivo == NULL){
        printf("ERROR AL ABRIR EL ARCHIVO %s", filepath);
        wifi_init_softap();
    }
    else {
        fgets(ssidReg,100,archivo);
        fgets(passwordReg,100,archivo);
        ssidReg[strcspn(ssidReg, "\n")] = 0;
    }
    esp_netif_init();

    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    esp_wifi_init(&cfg);

    esp_event_handler_instance_t instance_any_id;
    esp_event_handler_instance_t instance_got_ip;
    esp_event_handler_instance_register(WIFI_EVENT,
                                        ESP_EVENT_ANY_ID,
                                        &event_handler,
                                        NULL,
                                        &instance_any_id);
    esp_event_handler_instance_register(IP_EVENT,
                                        IP_EVENT_STA_GOT_IP,
                                        &event_handler,
                                        NULL,
                                        &instance_got_ip);
    wifi_config_t wifi_sta_config = {
        .sta = {
            .ssid = "",
            .password = "",
            .threshold.authmode = WIFI_AUTH_WPA2_PSK,
            .sae_pwe_h2e = WPA3_SAE_PWE_HUNT_AND_PECK,
            .sae_h2e_identifier = "",
        },
    };

    strcpy((char*) wifi_sta_config.sta.ssid, ssidReg);
    strcpy((char*) wifi_sta_config.sta.password, passwordReg);

    esp_wifi_set_mode(WIFI_MODE_STA);
    esp_wifi_set_config(WIFI_IF_STA, &wifi_sta_config);
    esp_wifi_start();

     EventBits_t bits = xEventGroupWaitBits(s_wifi_event_group,
            WIFI_CONNECTED_BIT | WIFI_FAIL_BIT,
            pdFALSE,
            pdFALSE,
            portMAX_DELAY);

    /* xEventGroupWaitBits() returns the bits before the call returned, hence we can test which event actually
     * happened. */
    if (bits & WIFI_CONNECTED_BIT) {
        ESP_LOGI("WIFI", "connected to ap SSID:%s password:%s",
                 wifi_sta_config.sta.ssid, wifi_sta_config.sta.password);
        connected = true;
    } else if (bits & WIFI_FAIL_BIT) {
        ESP_LOGI("WIFI", "Failed to connect to SSID:%s, password:%s",
                 wifi_sta_config.sta.ssid, wifi_sta_config.sta.password);
    } else {
        ESP_LOGE("WIFI", "UNEXPECTED EVENT");
    }
    fclose(archivo);
}

//SPIFFS
esp_err_t file_get_handler(httpd_req_t *req) {
    // archivo /spiffs/index.html
    const char* filepath = "/spiffs/index.html";

    // Abrir el archivo
    FILE* file = fopen(filepath, "r");
    if (!file) {
        ESP_LOGE("WIFI", "No se pudo abrir el archivo: %s", filepath);
        httpd_resp_send_404(req);
        return ESP_FAIL;
    }

    // Leer y enviar el contenido por partes
    char line[256];
    while (fgets(line, sizeof(line), file)) {
        httpd_resp_sendstr_chunk(req, line);
    }

    // Cerrar el archivo y enviar fin de la respuesta
    fclose(file);
    httpd_resp_sendstr_chunk(req, NULL);
    return ESP_OK;
}

esp_err_t guardar_wifi_handler(httpd_req_t *req) {
    const char* filepath = "/spiffs/wifiText.txt";
    char buffer[100];
    int ret = httpd_req_recv(req, buffer, sizeof(buffer));
    if (ret <= 0) {
        return ESP_FAIL;
    }
    buffer[ret] = '\0'; 

    // Parsear el SSID y contraseña del cuerpo de la solicitud
    char ssid[500], password[500];
    char ssid_encoded[100], password_encoded[100];
    sscanf(buffer, "ssid=%49[^&]&password=%49s", ssid_encoded, password_encoded);
    
    url_decode(ssid, ssid_encoded, strlen(ssid_encoded));
    url_decode(password, password_encoded, strlen(password_encoded));

    
    FILE *fp;

    fp = fopen(filepath, "w+");

    fputs(ssid,fp);
    fputs("\n",fp);
    fputs(password,fp);

    fclose(fp);
    esp_restart();
    // Guardar en el archivo
    
    return ESP_OK;
}

httpd_uri_t guardar_wifi = {
    .uri      = "/guardar_wifi",      
    .method   = HTTP_POST,     
    .handler  = guardar_wifi_handler,  
    .user_ctx = NULL
};

// para direccion /
httpd_uri_t index_uri = {
    .uri      = "/",           
    .method   = HTTP_GET,      
    .handler  = file_get_handler,  
    .user_ctx = NULL
};

httpd_handle_t start_webserver(void) {
    httpd_handle_t server = NULL;
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();

    ESP_LOGI("WIFI", "Iniciando servidor en el puerto: '%d'", config.server_port);

    if (httpd_start(&server, &config) == ESP_OK) {
        // Registrar /hello y /
        httpd_register_uri_handler(server, &index_uri);
        httpd_register_uri_handler(server, &guardar_wifi);
    }

    return server;
}

void init_spiffs(void) {
    esp_vfs_spiffs_conf_t conf = {
        .base_path = "/spiffs",  // Directorio base
        .partition_label = NULL,
        .max_files = 5,
        .format_if_mount_failed = true
    };

    esp_err_t ret = esp_vfs_spiffs_register(&conf);

    if (ret != ESP_OK) {
        ESP_LOGI("SPIFFS", "Error al inicializar SPIFFS (%s)", esp_err_to_name(ret));
        return;
    }

    size_t total = 0, used = 0;
    ret = esp_spiffs_info(NULL, &total, &used);
    if (ret == ESP_OK) {
        ESP_LOGI("SPIFFS", "SPIFFS total: %d, used: %d", total, used);
    } else {
        ESP_LOGE("SPIFFS", "No se pudo obtener la información de la partición SPIFFS");
    }
}

//mqtt

static esp_err_t mqtt_event_handler_cb(esp_mqtt_event_handle_t event)
{
    esp_mqtt_client_handle_t client = event->client;
    int msg_id;
    // your_context_t *context = event->context;
    switch (event->event_id) {
    case MQTT_EVENT_CONNECTED:
    ESP_LOGI(TAG, "MQTT_EVENT_CONNECTED");
    break;
    case MQTT_EVENT_DISCONNECTED:
    ESP_LOGI(TAG, "MQTT_EVENT_DISCONNECTED");
    break;
    case MQTT_EVENT_SUBSCRIBED:
    ESP_LOGI(TAG, "MQTT_EVENT_SUBSCRIBED");
    break;
    case MQTT_EVENT_UNSUBSCRIBED:
    ESP_LOGI(TAG, "MQTT_EVENT_UNSUBSCRIBED");
    break;
    case MQTT_EVENT_PUBLISHED:
    ESP_LOGI(TAG, "MQTT_EVENT_PUBLISHED");
    break;
    case MQTT_EVENT_DATA:
    ESP_LOGI(TAG, "MQTT_EVENT_DATA");
    printf("TOPIC=%.*s\r\n", event->topic_len, event->topic);
    printf("DATA=%.*s\r\n", event->data_len, event->data);
    break;
    case MQTT_EVENT_ERROR:
    ESP_LOGI(TAG, "MQTT_EVENT_ERROR");
    break;
    default:
    ESP_LOGI(TAG, "Other event id:%d", event->event_id);
    break;
    }
    return ESP_OK;
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data) {
    ESP_LOGD(TAG, "Event dispatched from event loop base=%s, event_id=%ld", base, event_id);
    mqtt_event_handler_cb(event_data);
}

static void mqtt_app_start_pasos(int pasos) {
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = CONFIG_BROKER_URL,
        .broker.address.port = 1883,
        .credentials.username = CONFIG_TOKEN, //poner token del device general
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, client);
    esp_mqtt_client_start(client);
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "step",pasos);
    char *post_data = cJSON_PrintUnformatted(root);
    esp_mqtt_client_publish(client, "v1/devices/me/telemetry", post_data, 0, 1, 0);
    
    cJSON_Delete(root);
    free(post_data);
}


static void mqtt_app_start_temp(float temp) {
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = CONFIG_BROKER_URL,
        .broker.address.port = 1883,
        .credentials.username = CONFIG_TOKEN, //poner token del device general
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, client);
    esp_mqtt_client_start(client);
    

        cJSON *root = cJSON_CreateObject();
        cJSON_AddNumberToObject(root, "tmp",temp);
        char *post_data = cJSON_PrintUnformatted(root);
        esp_mqtt_client_publish(client, "v1/devices/me/telemetry", post_data, 0, 1, 0);
        
        cJSON_Delete(root);
        free(post_data);
}


static void mqtt_app_start_ritmo(int ritmo) {
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = CONFIG_BROKER_URL,
        .broker.address.port = 1883,
        .credentials.username = CONFIG_TOKEN, //poner token del device general
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, client);
    esp_mqtt_client_start(client);
    
        cJSON *root = cJSON_CreateObject();
        cJSON_AddNumberToObject(root, "cardiac",ritmo);
        char *post_data = cJSON_PrintUnformatted(root);
        esp_mqtt_client_publish(client, "v1/devices/me/telemetry", post_data, 0, 1, 0);
        
        cJSON_Delete(root);
        free(post_data); 
}

static void mqtt_app_start_distancia(float distancia) {
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = CONFIG_BROKER_URL,
        .broker.address.port = 1883,
        .credentials.username = CONFIG_TOKEN, //poner token del device general
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, client);
    esp_mqtt_client_start(client);
    
        cJSON *root = cJSON_CreateObject();
        cJSON_AddNumberToObject(root, "mtr",distancia);
        char *post_data = cJSON_PrintUnformatted(root);
        esp_mqtt_client_publish(client, "v1/devices/me/telemetry", post_data, 0, 1, 0);
        
        cJSON_Delete(root);
        free(post_data);
        vTaskDelay(pdMS_TO_TICKS(1000)); 
    
}

float axis_x, axis_y, axis_z;

//calcular el aceleramiento
void setAccelerator_AXIS(){
    uint8_t accel_data[6];
    ESP_ERROR_CHECK(mpu6050_read_bytes(ACCEL_XOUT_H, accel_data, 6));

    int16_t accel_x_raw = (int16_t)(accel_data[0] << 8 | accel_data[1]);
    int16_t accel_y_raw = (int16_t)(accel_data[2] << 8 | accel_data[3]);
    int16_t accel_z_raw = (int16_t)(accel_data[4] << 8 | accel_data[5]);

    axis_x = accel_x_raw / ACCEL_SCALE;
    axis_y = accel_y_raw / ACCEL_SCALE;
    axis_z = accel_z_raw / ACCEL_SCALE;
}

int step_count = 0; 
float last_magnitude = 0;
float smoothed_magnitude = 0.0;
uint32_t last_step_time = 0;
float last_pitch = 0.0;  // Pitch anterior
float last_roll = 0.0;   // Roll anterior

void detect_steps(float pitch, float roll) {
    // Calcular la magnitud de la aceleración (usando axis_x, axis_y, axis_z)
    float magnitude = calculate_magnitude(axis_x, axis_y, axis_z);

    // Aplicar suavizado
    smoothed_magnitude = ALPHA * magnitude + (1 - ALPHA) * smoothed_magnitude;

    // Calcular diferencias entre el pitch y roll actuales y los anteriores
    float delta_pitch = fabs(pitch - last_pitch);
    float delta_roll = fabs(roll - last_roll);

    // Obtener el tiempo actual en milisegundos
    uint32_t current_time = esp_timer_get_time() / 1000;  // Tiempo en ms

    // Verificar condiciones para detectar pasos
    if (((current_time - last_step_time > STEP_MIN_INTERVAL) &&
         (smoothed_magnitude > STEP_THRESHOLD && last_magnitude < STEP_THRESHOLD)) ||
        delta_pitch > 10.0 || delta_roll > 10.0) {
        step_count++;
        last_step_time = current_time;
        printf("Total pasos: %d\n", step_count);
    }
    last_magnitude = smoothed_magnitude;
    last_pitch = pitch;
    last_roll = roll;
}

void app_main(void)
{

    httpd_handle_t server = NULL;

    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    // Inicializar la pila de eventos
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());

    // Crear interfaz de red por defecto
    esp_netif_create_default_wifi_ap();
    esp_netif_create_default_wifi_sta();
    init_spiffs();

    // Inicializar Wi-Fi con la configuración predeterminada
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));

    //inicilizar pantalla
    
    SSD1306_init(&dev);

    wifi_init_sta(&dev);
    
    // Iniciar el servidor web
    server = start_webserver();  // Guardar el manejador del servidor

    if(connected){
        display_success_connect(&dev);
        vTaskDelay(pdMS_TO_TICKS(2000));
        initAccelerator();
        initTemp();

        initialize_sntp();

        init_button();

        xTaskCreate(button_task, "button_task", 2048, NULL, 5, NULL);

        float tmp = 0.0;
        float pitch, roll;
        int cad1;
        float m = 0.0 ;
        int cont = 0;

        while(1){
            tmp = getTemp();
            setAccelerator_AXIS();
            pitch = atan2(axis_y, sqrt(axis_x * axis_x + axis_z * axis_z)) * 180 / M_PI;
            roll = atan2(-axis_x, sqrt(axis_y * axis_y + axis_z * axis_z)) * 180 / M_PI;
            cad1 = get_Cardiac();

            detect_steps(pitch,roll);
            m = step_count * 0.762 ;
            
            if(cont == 7){
                mqtt_app_start_pasos(step_count);
                mqtt_app_start_distancia(m);
                vTaskDelay(pdMS_TO_TICKS(500));
                mqtt_app_start_temp(tmp);
                mqtt_app_start_ritmo(cad1);

                cont = 0;
            }
            cont++;
            
            update_display(&dev, step_count, tmp, cad1,m);
            check_sleep_mode(&dev);
            vTaskDelay(pdMS_TO_TICKS(1000));
        }
    }
}