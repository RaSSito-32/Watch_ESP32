#include <stdio.h>    // Used for printf() statements
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdint.h>
#include <wiringPi.h> // Include WiringPi library
#include <math.h>
#include <time.h>

#include "devices.h"

// Functions to test devices

void test_GPIOs();
void test_all_ADC();
void test_ADC_3();
void test_Gyroscope();
void test_ultrasound();
void test_leds();
void test_servo();


void test_GPIOs() { 
    int k;
    int dig_value;

    printf ("Testing digital inputs ...\n"); 
     // Reading digital inputs: infrared and button  
      for (k=0; k<20; k++)
      {
        dig_value = read_infrared ();
        printf ("value of Infrared = %d \n", dig_value);
        
        if (dig_value == 1)
          moveServo(90);
        else
          moveServo(0);

        dig_value = read_button ();    
        printf ("value of Button = %d \n \n", dig_value); 
        
        delay (500); // wait 500 milliseconds
      }
} // end test_GPIOs


void test_all_ADC() { 
    int k, i, n;
    int analog_sensors [8] = {0,0,0,0,0,0,0,0};
      
    printf ("Testing analog channels ...\n");
    delay (500);

    // Reading 8 channels of ADC 3008
    for (k=0; k<20; k++)
     {
      read_all_ADC_sensors (analog_sensors);
      for(i=0;i<8;i++){
	    printf("Chan%d:%d  ",i,analog_sensors[i]);
      };
      if (analog_sensors [3] > 600)
        n = set_led_1 (1);
      else
        n = set_led_1 (0);
     
     printf (" \n");
     delay (500); // wait 500 milliseconds until next reading
    } 
} // end test_all_ADC


void test_ADC_3() { 
    int k, ADC3_Value;    
    // Reading a single channel of ADC 3008
    for (k=0; k<10; k++)
     {
      ADC3_Value = read_single_ADC_sensor (3); // it reads only channel 3
      printf("Channel 3: %d \n", ADC3_Value);
      delay (500); // wait 500 milliseconds until next reading
      } 
} // end test_ADC_3


void test_Gyroscope() {  
    int k;
    int Rx = 0;
    int Ry = 0;

      // Reading Gyroscope 
            
      for (k=0; k<20; k++)
      {
        Rx = Read_Giroscope_X ();
        Ry = Read_Giroscope_Y ();

	    printf("Rotation: X= %d Y= %d \n", Rx, Ry);

        delay (500); // wait 500 milliseconds until next reading
      }     
     printf (" \n");
} // end test_Gyroscope


void test_ultrasound() { 
     int k, n;
     float dist = 0;   
     // Reading distance     
      for (k=0; k<20; k++)
      {
	    dist = getDistance();
	    printf("Distance: %.2f cm\n", dist);
        
        if (dist < 6.0)
          n = set_led_2 (1);
        else 
          n = set_led_2 (0);
        
        delay (500); // wait 500 milliseconds
      }
} // end test_ultrasound


void test_leds () {
     int k, n;

     printf ("Testing leds ...\n");
      for (k=0; k<10; k++)
      {
        n = set_led_1 (1); // Led_1 on
        n = set_led_2 (0); // Led 2 off
        delay (500);
        n = set_led_1 (0); // Led_1 off
        n = set_led_2 (1); // Led 2 on
        delay (500); // wait 500 milliseconds
      }
} // end test_leds


void test_servo () {      

      moveServo(0); // 0 degrees
      delay (1000);

      moveServo(40); // 40 degrees
      delay (1000);

      moveServo(80); // 80 degrees
      delay (1000);
 
      moveServo(120); // 120 degrees
      delay (1000);
 
      moveServo(160); // 160 degrees
      delay (1000);
 
      moveServo(0); // 0 degrees
      delay (1000);

} // end test_servo



int main(void)
{
    int n;

    printf ("Testing devices ... \n");
    
    n = init_devices ();
    printf ("Devices initialized: %d \n", n); 

    test_GPIOs();
    //test_all_ADC();
    //test_ADC_3();
    //test_Gyroscope();
    //test_ultrasound();
    //test_servo();
     
    close_devices ();

    return (0);
}
