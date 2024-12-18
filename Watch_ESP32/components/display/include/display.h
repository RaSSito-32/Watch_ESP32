#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "esp_wifi.h"
#include "esp_system.h"
#include "nvs_flash.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "lwip/sockets.h"
#include "lwip/dns.h"
#include "lwip/netdb.h"
#include "esp_log.h"
#include "driver/gpio.h"
#include "ssd1306.h"
#include "time.h"
#include "sys/time.h"
#include "esp_sntp.h"
#include "esp_timer.h"
#include "font8x8_basic.h"
#include "esp_sleep.h"
#include "mqtt_data_send.h"

static const char *TAG = "proyecto_SBC";
#define BUTTON_GPIO_1 26 // el que este libre
#define BUTTON_GPIO_2 25 // el que este libre
#define DEBOUNCE_TIME_MS 200   // Tiempo de debounce


// Configuración del servidor NTP y zona horaria
#define NTP_SERVER "pool.ntp.org"
#define TIMEZONE "CET-1CEST,M3.5.0,M10.5.0/3"

static volatile int current_display = 0;
static volatile float cont_emergencia = 0;

void init_button();
void button_task(void *arg);
void SSD1306_init(SSD1306_t *dev);
void initialize_sntp(void);
void update_display(SSD1306_t *dev, int steps, float temp, int cad1,float m);
void display_connect_wifi(SSD1306_t *dev);
void ssd1306_display_text_centered(SSD1306_t * dev, int page, char * text, int text_len, bool invert, int x_offset);
void display_trying_connect(SSD1306_t *dev);
void display_success_connect(SSD1306_t *dev);
void configure_gpio_wakeup();
void check_sleep_mode();