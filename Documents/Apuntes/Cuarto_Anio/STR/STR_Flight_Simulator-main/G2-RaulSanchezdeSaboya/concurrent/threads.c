#include <stdio.h>    // Used for printf() statements
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdint.h>
#include <wiringPi.h> // Include WiringPi library!

#include <pthread.h>

#include <math.h>
#include <time.h>

#include "devices.h"

#include <semaphore.h>

// semaphore for critical region 
sem_t sem_A;

#define NUM_THREADS 3

void *t1 (){
  int adc3channel, led;

  printf ("Activity 1 \n");
  
  /*while(1)
  {
    adc3channel = read_single_ADC_sensor(3);
    if (adc3channel > 600)
      led = set_led_1(1);
    else
      led = set_led_1(0);
    printf("Channel 3: %d \n", adc3channel);
    delay (500); // wait 500 milliseconds until next reading
  }
  */
  pthread_exit (NULL);
}


void *t2 (){  
  int dist, n;
  printf ("Activity 2 \n");
  while(1)
  {
	dist = getDistance();
	printf("Distance: %.2f cm\n", dist);
			
	if (dist < 6.0)
	  n = set_led_2 (1);
	else 
	  n = set_led_2 (0);
		
	delay(500);
  }

  pthread_exit (NULL);
}

void *t3 (){

  printf ("Activity 3 \n");

  pthread_exit (NULL);
}


int main(void)
{
    int n;
    n = init_devices ();
    
    sem_init(&sem_A, 0, 1); // init semaphore

    pthread_t thread [NUM_THREADS]; 

    pthread_create(&thread[0], NULL, t1, NULL);
    pthread_create(&thread[1], NULL, t2, NULL);
    pthread_create(&thread[2], NULL, t3, NULL);

    pthread_join(thread[0], NULL);
    pthread_join(thread[1], NULL);
    pthread_join(thread[2], NULL);

    close_devices ();

    return (0);
}
