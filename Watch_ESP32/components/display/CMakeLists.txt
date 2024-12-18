set(component_srcs "display.c")

set(idf_version "${IDF_VERSION_MAJOR}.${IDF_VERSION_MINOR}")

idf_component_register(SRCS "${component_srcs}" PRIV_REQUIRES driver INCLUDE_DIRS "include" "."
                        PRIV_REQUIRES esp_wifi nvs_flash ssd1306 esp_timer mqtt_data_send)