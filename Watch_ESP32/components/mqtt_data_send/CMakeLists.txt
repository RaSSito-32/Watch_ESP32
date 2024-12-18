set(component_srcs "mqtt_data_send.c")

set(idf_version "${IDF_VERSION_MAJOR}.${IDF_VERSION_MINOR}")

idf_component_register(SRCS "${component_srcs}" PRIV_REQUIRES driver INCLUDE_DIRS "include" "."
                        PRIV_REQUIRES esp_wifi esp_event nvs_flash esp_http_server spiffs driver
                        REQUIRES mqtt json mqtt_data_send)
