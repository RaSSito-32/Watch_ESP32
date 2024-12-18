#include "sensors.h"
static uint32_t last_beat_time = 0;
static uint32_t beat_count = 0;
static uint32_t last_heart_rate = 0;

//Incluir las direcciones de temperatura
float axis_Accelleration[3];


esp_err_t mpu6050_write_byte(uint8_t reg_addr, uint8_t data) {
    uint8_t write_buf[2] = { reg_addr, data };
    return i2c_master_write_to_device(I2C_MASTER_NUM, MPU6050_ADDR, write_buf, sizeof(write_buf), pdMS_TO_TICKS(1000));
}

esp_err_t mpu6050_read_bytes(uint8_t reg_addr, uint8_t *data, size_t len) {
    return i2c_master_write_read_device(I2C_MASTER_NUM, MPU6050_ADDR, &reg_addr, 1, data, len, pdMS_TO_TICKS(1000));
}

void initAccelerator(){
    ESP_ERROR_CHECK(mpu6050_write_byte(PWR_MGMT_1, 0x00)); // Salir del modo de suspensión
}

void initTemp(){
    unsigned char rgCfg[2] = {0};
    rgCfg[0] = 0x01;
    rgCfg[1] = RESOLUTION_TMP;

    i2c_master_write_to_device(I2C_NUM_0, SLAVE_ADDRESS_TMP, rgCfg, 2, pdMS_TO_TICKS(1000));
}

float getTemp()
{
    float result;
    unsigned short wResult = 0;
	unsigned char rgVals[2] = {0, 0};
    
    i2c_master_write_to_device(I2C_NUM_0, SLAVE_ADDRESS_TMP, rgVals, 1, pdMS_TO_TICKS(1000));
    i2c_master_read_from_device(I2C_NUM_0, SLAVE_ADDRESS_TMP, rgVals, 2, pdMS_TO_TICKS(1000));

    wResult = (rgVals[1] | (rgVals[0] << 8)) >> 4;
    result = wResult / 16.0;

    return result;
}

int get_Cardiac()
{
     uint32_t adc_reading = 0;

    adc1_config_width(ADC_WIDTH);
    adc1_config_channel_atten(CONFIG_RITMO_GPIO, ADC_ATTEN);
    for (int i = 0; i < NO_OF_SAMPLES; i++) {
        adc_reading += adc1_get_raw(CONFIG_RITMO_GPIO);
    }
    adc_reading /= NO_OF_SAMPLES;

    // Detectar latido
    uint32_t current_time = esp_log_timestamp();
    if (adc_reading > THRESHOLD && (current_time - last_beat_time) > MIN_TIME_BETWEEN_BEATS) {
        beat_count++;
        last_beat_time = current_time;
    }

    // Calcular frecuencia cardíaca en bpm
    uint32_t elapsed_time = current_time - last_beat_time;
    if (elapsed_time > 0) {
        last_heart_rate = (beat_count * 60000) /MEASUREMENT_INTERVAL; // 6000 ms en 10 segundos
    }
    int adc1=adc_reading/2;
    adc1= adc1 % 2000;
    adc1= adc1 /2;
    adc1= adc1%380;
	
	return adc1;
}

//podometro
float calculate_magnitude(float x, float y, float z) {
    return sqrt(x * x + y * y + z * z);
}
