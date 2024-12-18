#include <stdio.h>
#include "display.h"
#include "ssd1306.h"
static QueueHandle_t gpio_evt_queue = NULL;

//sleep mode
uint32_t last_time_buttons = 0;

static void IRAM_ATTR button_isr_handler(void *arg) {
    int gpio_num = (int)arg;
    xQueueSendFromISR(gpio_evt_queue, &gpio_num, NULL);
}

static void mqtt_app_start_emg()
{
    //mosquitto_pub -d -q 1 -h demo.thingsboard.io -p 1883 -t v1/devices/me/telemetry -u "7htxumdcjy9s2qwyjgi6" -m "{temperature:25}"
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = "mqtt://demo.thingsboard.io",
        .broker.address.port = 1883,
        .credentials.username = "08mcKYiLTf9EdKe766XE", //token
    };
    // Establecer la conexión
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    /* The last argument may be used to pass data to the event handler, in this example mqtt_event_handler */
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, client);
    esp_mqtt_client_start(client);

    // Crear json que se quiere enviar al ThingsBoard
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "emg", 1); // En la telemetría de Thingsboard aparecerá 
    char *post_data = cJSON_PrintUnformatted(root);
    // Enviar los datos
    esp_mqtt_client_publish(client, "v1/devices/me/telemetry", post_data, 0, 1, 0); // v1/devices/me/telemetry sale de la MQTT Device API Reference de ThingsBoard
    cJSON_Delete(root);
    // Free is intentional, it's client responsibility to free the result of cJSON_Print
    free(post_data);
}

void init_button() {
    gpio_config_t io_conf = {
        .intr_type = GPIO_INTR_NEGEDGE,
        .mode = GPIO_MODE_INPUT,
        .pull_down_en = GPIO_PULLDOWN_ENABLE,
        .pull_up_en = GPIO_PULLUP_DISABLE
    };

    io_conf.pin_bit_mask = (1ULL << BUTTON_GPIO_1);
    gpio_config(&io_conf);

    io_conf.pin_bit_mask = (1ULL << BUTTON_GPIO_2);
    gpio_config(&io_conf);

    gpio_evt_queue = xQueueCreate(10, sizeof(int));

    gpio_install_isr_service(0);
    gpio_isr_handler_add(BUTTON_GPIO_1, button_isr_handler, (void *)BUTTON_GPIO_1);
    gpio_isr_handler_add(BUTTON_GPIO_2, button_isr_handler, (void *)BUTTON_GPIO_2);
}
void configure_gpio_wakeup() {
    // Configura ambos pines como fuentes de *wake-up*
    esp_sleep_enable_ext1_wakeup(
        (1ULL << BUTTON_GPIO_1) | (1ULL << BUTTON_GPIO_2),  // Pines para el wake-up
        ESP_EXT1_WAKEUP_ANY_HIGH                          // Despierta si cualquier pin está en alto
    );
}
static void log_error_if_nonzero(const char *message, int error_code)
{
    if (error_code != 0) {
        ESP_LOGE("MQTT", "Last error %s: 0x%x", message, error_code);
    }
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data)
{
    esp_mqtt_event_handle_t event = event_data;
    esp_mqtt_client_handle_t client = event->client;
    int msg_id;
    switch ((esp_mqtt_event_id_t)event_id) {
    case MQTT_EVENT_CONNECTED:
        ESP_LOGI("MQTT", "MQTT_EVENT_CONNECTED");
        msg_id = esp_mqtt_client_publish(client, "/topic/qos1", "data_3", 0, 1, 0);
        msg_id = esp_mqtt_client_subscribe(client, "/topic/qos0", 0);
        msg_id = esp_mqtt_client_subscribe(client, "/topic/qos1", 1);
        msg_id = esp_mqtt_client_unsubscribe(client, "/topic/qos1");
        break;
    case MQTT_EVENT_DISCONNECTED:
        break;
    case MQTT_EVENT_SUBSCRIBED:
        msg_id = esp_mqtt_client_publish(client, "/topic/qos0", "data", 0, 0, 0);
        break;
    case MQTT_EVENT_UNSUBSCRIBED:
        break;
    case MQTT_EVENT_PUBLISHED:
        break;
    case MQTT_EVENT_DATA:
        printf("TOPIC=%.*s\r\n", event->topic_len, event->topic);
        printf("DATA=%.*s\r\n", event->data_len, event->data);
        break;
    case MQTT_EVENT_ERROR:
        if (event->error_handle->error_type == MQTT_ERROR_TYPE_TCP_TRANSPORT) {
            ESP_LOGI("MQTT", "Last errno string (%s)", strerror(event->error_handle->esp_transport_sock_errno));
        }
        break;
    default:
        ESP_LOGI("MQTT", "Other event id:%d", event->event_id);
        break;
    }
}

void check_sleep_mode(SSD1306_t *dev) {
    uint32_t current_time = esp_timer_get_time() / 1000;  
    int button1 = gpio_get_level(BUTTON_GPIO_1);
    int button2= gpio_get_level(BUTTON_GPIO_2);
    if (current_display == 0){
        if (button1 == 0 && button2 == 0 && (current_time - last_time_buttons)  >= 20000) {  // SI el boton no ha sido pulsado por mas de x segundos
            ESP_LOGI(TAG, "Entrando en modo light sleep...");
            ssd1306_clear_screen(dev, false);
            configure_gpio_wakeup();
            esp_light_sleep_start();       
            ESP_LOGI(TAG, "Despertando de light sleep");
        }
    }
    if(button1 == 1 || button2 == 1)
        last_time_buttons= current_time;
}

void button_task(void *arg) {
    int io_num;
    static int64_t last_press_time_1 = 0;
    static int64_t last_press_time_2 = 0;
    int cont_emergencia=0;
    while (1) {
        if (xQueueReceive(gpio_evt_queue, &io_num, portMAX_DELAY)) {
            int64_t now = esp_timer_get_time() / 1000; // Tiempo en milisegundos
            ESP_LOGI("BUTTON_TASK", "Interrupción en GPIO: %d", io_num);
            if (io_num == BUTTON_GPIO_1) { // Primer botón
                if (now - last_press_time_1 > DEBOUNCE_TIME_MS) {
                    current_display = (current_display + 1) % 5; // Rotar entre 5 estados
                    last_press_time_1 = now;
                    cont_emergencia = 0;
                }
            } else if (io_num == BUTTON_GPIO_2) { // Segundo botón
                if (now - last_press_time_2 > DEBOUNCE_TIME_MS) {
                    //rulechain
                    if(current_display == 3 || cont_emergencia == 8){
                        //logica de thingsboard
                        mqtt_app_start_emg();
                        last_press_time_2 = now;
                        if(cont_emergencia == 8)
                            cont_emergencia = 0;
                    }else if(cont_emergencia < 8){
                        cont_emergencia++;
                    }
                } else {
                    ESP_LOGW("BUTTON_TASK", "Rebote detectado en Botón 2");
                }
            }
            
        }
    }
}

// Función para inicializar la pantalla OLED
void SSD1306_init(SSD1306_t *dev) {
    #if CONFIG_I2C_INTERFACE
    ESP_LOGI("DISPLAY", "Inicializando I2C para SSD1306...");
    i2c_master_init(dev, CONFIG_SDA_GPIO, CONFIG_SCL_GPIO, CONFIG_RESET_GPIO);
    #endif

    #if CONFIG_SSD1306_128x64
    ESP_LOGI("DISPLAY", "Configurando pantalla OLED 128x64...");
    ssd1306_init(dev, 128, 64);
    #endif

    ssd1306_clear_screen(dev, false);
    ssd1306_contrast(dev, 0xff); // Configurar brillo máximo
}

// Función para inicializar el cliente NTP
void initialize_sntp(void) {
    // Configura el servidor NTP utilizando la nueva función
    esp_sntp_setservername(0, NTP_SERVER);
    
    // Inicializa el cliente NTP utilizando la nueva función
    esp_sntp_init();

    // Configura la zona horaria
    setenv("TZ", TIMEZONE, 1);
    tzset();
}

void display_connect_wifi(SSD1306_t *dev){
    ssd1306_clear_screen(dev, false);
    ssd1306_display_text(dev, 0, "connect wifi", 16, false);
    ssd1306_show_buffer(dev);
}

void display_trying_connect(SSD1306_t *dev){
    ssd1306_clear_screen(dev, false);
    ssd1306_display_text(dev, 0, "Trying wifi", 12, false);
    ssd1306_show_buffer(dev);
}

void display_success_connect(SSD1306_t *dev){
    ssd1306_clear_screen(dev, false);
    ssd1306_display_text(dev, 0, "Wifi connected!", 15, false);
    ssd1306_show_buffer(dev);
}

// Función para obtener y mostrar la hora en la pantalla OLED centrada
void display_time(SSD1306_t *dev) {
    time_t now;
    struct tm timeinfo;
    char strftime_buf[6]; // Buffer para "HH:MM"

    // Obtiene la hora actual
    time(&now);
    localtime_r(&now, &timeinfo);

    // Verifica si la hora está sincronizada
    if (timeinfo.tm_year < (2024 - 1900)) {
        ssd1306_clear_screen(dev, false);
        ssd1306_display_text(dev, 0, "Syncing NTP...", 14, false);
        ssd1306_show_buffer(dev);
    } else {
        // Construye el formato "HH:MM"
        strftime(strftime_buf, sizeof(strftime_buf), "%H:%M", &timeinfo);
        ESP_LOGI("DISPLAY", "Hora actual: %s", strftime_buf);

        // Limpia la pantalla y muestra la hora centrada
        ssd1306_clear_screen(dev, false);
        ssd1306_display_text_box1(dev, 4.7, 40, strftime_buf,5 ,strlen(strftime_buf), false, 0);
        ssd1306_show_buffer(dev);
    }
}

void display_workout(SSD1306_t *dev, int steps, float temp) {
    char steps_str[16];
    char temp_str[16];
    char calidad_TMP[9];
    if (temp > 20 && temp < 22)
    {
        snprintf(calidad_TMP, sizeof(calidad_TMP), "Ideal");
    }
    else if((temp > 15 && temp < 20) || (temp > 22 && temp < 26))
    {
        snprintf(calidad_TMP, sizeof(calidad_TMP), "buena");
    }
    else if((temp > 6 && temp < 15) || (temp > 25 && temp < 30))
    {
        snprintf(calidad_TMP, sizeof(calidad_TMP), "Regular");
    }
    else
        snprintf(calidad_TMP, sizeof(calidad_TMP), "Mala");
    
    snprintf(temp_str, sizeof(temp_str), "Temp: %0.2f", temp);
    snprintf(steps_str, sizeof(steps_str), "Steps: %d", steps);

    ssd1306_clear_screen(dev, false);
    ssd1306_display_text(dev, 0, "MODO EJERCICIO", 12, false);
    ssd1306_display_text(dev, 2, steps_str, strlen(steps_str), false); // Velocidad en la línea 3
    ssd1306_display_text(dev, 4, temp_str, 11, false);
    ssd1306_display_text(dev, 6, calidad_TMP, 11, false);
    ssd1306_show_buffer(dev);
}

void display_emergency(SSD1306_t *dev, int real) {
    ssd1306_clear_screen(dev, false);
    ssd1306_display_text_centered(dev, 1, "Modo Emergencia", strlen("Modo Emergencia"), false, 5);
    ssd1306_display_text_centered(dev, 3, "Para pedir", strlen("Para pedir"), false, 25);
    ssd1306_display_text_centered(dev, 4, "ayuda", strlen("ayuda"), false, 40);
    ssd1306_display_text_centered(dev, 6, "pulsa el", strlen("Pulsa el"), false, 30);
    ssd1306_display_text_centered(dev, 7, "boton 2", strlen("boton 2"), false, 35);
    ssd1306_show_buffer(dev);
}

void display_m(SSD1306_t *dev,float m){
    char m_str[16];
    ssd1306_clear_screen(dev, false);
    snprintf(m_str, sizeof(m_str), "%.2f m", m);
    ssd1306_display_text_centered(dev, 4, m_str, strlen(m_str), false, 40);
    ssd1306_show_buffer(dev);
}

void ssd1306_display_text_centered(SSD1306_t * dev, int page, char * text, int text_len, bool invert, int x_offset)
{
    if (page >= dev->_pages) return;
    int _text_len = text_len;
    if (_text_len > 16) _text_len = 16;

    int seg = x_offset;  
    uint8_t image[8];
    for (int i = 0; i < _text_len; i++) {
        memcpy(image, font8x8_basic_tr[(uint8_t)text[i]], 8);
        if (invert) ssd1306_invert(image, 8);
        if (dev->_flip) ssd1306_flip(image, 8);
        ssd1306_display_image(dev, page, seg, image, 8);
        seg = seg + 8;
    }
}

void display_cardiac(SSD1306_t *dev, int x0, int y0, bool invert, int adc1) {
    char heart_rate_text[32]; 
    ssd1306_clear_screen(dev, false);
    snprintf(heart_rate_text, sizeof(heart_rate_text), "%d LPM", adc1);
    
    uint8_t heart_pattern[12][17] = {
        {0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
        {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
        {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
    };

    for (int row = 0; row < 12; row++) {
        for (int col = 0; col < 17; col++) {
            if (heart_pattern[row][col]) {
                _ssd1306_pixel(dev, x0 + col - 7, y0 + row - 6, invert);
            }
        }
    }
    // Dibujar texto debajo del corazón
    ssd1306_display_text_centered(dev, 4, heart_rate_text, strlen(heart_rate_text), invert, 40);
}

void update_display(SSD1306_t *dev, int speed, float temp, int cad1,float m) {
    switch (current_display) {
        case 0:
            display_time(dev);
            break;
        case 1:
            display_workout(dev, speed, temp); 
            break;
        case 2:
            display_m(dev,m);
            break;
        case 3:
            display_emergency(dev, 0); // Ejemplo de emergencia no real
            break;
        case 4:
            display_cardiac(dev, 64, 20, false, cad1);
            break;
        default:
            ssd1306_clear_screen(dev, false);
            ssd1306_display_text(dev, 0, "Error inesperado", 15, false);
            ssd1306_show_buffer(dev);
            break;
    }
}

