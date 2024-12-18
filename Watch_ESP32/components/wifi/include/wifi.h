#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include "esp_event.h"
#include "nvs_flash.h"
#include "esp_log.h"
#include "esp_mac.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "esp_http_server.h"
#include "lwip/ip_addr.h"
#include "esp_spiffs.h"
#include "driver/gpio.h"
#include "sdkconfig.h"

#include "lwip/err.h"
#include "lwip/sys.h"

#define LED_PIN 2

#define SSID "espc4c0"
#define PSWD "12345678"
#define CHANNEL 1
#define NUM_CONNECTIONS 4

//STA CONFIG
#define MAXIMUM_RETRY  5
static int s_retry_num = 0;
static EventGroupHandle_t s_wifi_event_group;
#define WIFI_CONNECTED_BIT BIT0
#define WIFI_FAIL_BIT      BIT1

//Nj97V7gqfm3Yv6HqkVzr
//nKJETHW3CJ9T9EUU9FWC
