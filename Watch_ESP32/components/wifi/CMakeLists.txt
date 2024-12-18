set(component_srcs "wifi.c")

set(idf_version "${IDF_VERSION_MAJOR}.${IDF_VERSION_MINOR}")

idf_component_register(SRCS "${component_srcs}" PRIV_REQUIRES driver INCLUDE_DIRS "include" "."
                        PRIV_REQUIRES esp_wifi esp_event nvs_flash esp_http_server spiffs driver)

spiffs_create_partition_image(storage ../../spiffs FLASH_IN_PROJECT)