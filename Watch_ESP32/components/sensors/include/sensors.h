#include <stdio.h>
#include <math.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/i2c.h"
#include "esp_log.h"
#include "driver/adc.h"
#include "esp_sleep.h"

#define I2C_MASTER_NUM              I2C_NUM_0
#define I2C_MASTER_FREQ_HZ          100000*4   // Frecuencia del bus I2C
#define ACCEL_SCALE                 16384.0  // Escala para ±2g,en MPU esta a 2g,si fuera 1g,el dato en crudo es el real
#define SLAVE_ADDRESS_TMP           0x48
#define MPU6050_ADDR                0x68     // Dirección I2C del MPU-6050
#define PWR_MGMT_1                  0x6B     // Registro para activar el MPU
#define ACCEL_XOUT_H                0x3B     // Registro del eje X alto
#define RESOLUTION_TMP              0x60
#define STEP_THRESHOLD 1.1  // Umbral de detección de pasos
#define STEP_MIN_INTERVAL 200        // Mínimo intervalo entre pasos (ms)
#define ALPHA 0.2                    // Suavizado
#define DELTA_THRESHOLD 0.01       // Cambio mínimo en magnitud para paso
#define ADC_WIDTH ADC_WIDTH_BIT_12
#define ADC_ATTEN ADC_ATTEN_DB_11
#define CONFIG_RITMO_GPIO ADC1_CHANNEL_6
#define DEFAULT_VREF 3300 // Referencia de voltaje en mV
#define NO_OF_SAMPLES 64 // Número de muestras para promedio
#define THRESHOLD 2000 // Umbral para detectar un latido
#define MIN_TIME_BETWEEN_BEATS 300 // Tiempo mínimo entre latidos en ms
#define MEASUREMENT_INTERVAL 10000 // Intervalo de medición en ms

esp_err_t mpu6050_write_byte(uint8_t reg_addr, uint8_t data);
esp_err_t mpu6050_read_bytes(uint8_t reg_addr, uint8_t *data, size_t len);
void init_i2c_sensors();
void initAccelerator();
float calculate_magnitude(float x, float y, float z);
void initTemp();
void setAccelerator_AXIS();
float getTemp();
int get_Cardiac();
