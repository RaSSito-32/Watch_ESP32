with Ada.Real_Time; use Ada.Real_Time;
with devicesfss_v1; use devicesfss_v1;

package data_Scenarios is

    ---------------------------------------------------------------------
    ------ Access time for devices
    ---------------------------------------------------------------------
    WCET_Distance: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);
    WCET_Light: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);
    
    WCET_Joystick: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);
    WCET_PilotPresence: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);
    WCET_PilotButton: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);
    
    WCET_Power: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(4);
    
    WCET_Speed: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(7);
    WCET_Altitude: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(18);

    WCET_Pitch: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(20);
    WCET_Roll: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(18);

    WCET_Display: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(15);
    WCET_Alarm: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(5);

    ---------------------------------------------------------------------
    ------ SCENARIO ----------------------------------------------------- 
    ---------------------------------------------------------------------
    
    ---------------------------------------------------------------------
    ------ DISTANCE OK---------------------------------------------------
    cantidad_datos_Distancia: constant := 200;
    type Indice_Secuencia_Distancia is mod cantidad_datos_Distancia;
    type tipo_Secuencia_Distancia is array (Indice_Secuencia_Distancia) of Distance_Type;
                   
    ---------------------------------------------------------------------
    ------ LIGHT OK------------------------------------------------------

    cantidad_datos_Light: constant := 200;
    type Indice_Secuencia_Light is mod cantidad_datos_Light;
    type tipo_Secuencia_Light is array (Indice_Secuencia_Light) of Light_Type;

    ---------------------------------------------------------------------
    ------ JOYSTICK OK---------------------------------------------------

    cantidad_datos_Joystick: constant := 200;
    type Indice_Secuencia_Joystick is mod cantidad_datos_Joystick;
    type tipo_Secuencia_Joystick is array (Indice_Secuencia_Joystick) 
                                             of Joystick_Type;
                 
    ---------------------------------------------------------------------
    ------ POWER OK------------------------------------------------------
    cantidad_datos_Power: constant := 200;
    type Indice_Secuencia_Power is mod cantidad_datos_Power;
    type tipo_Secuencia_Power is array (Indice_Secuencia_Power) of Power_Type;

    ---------------------------------------------------------------------
    ------ PILOT'S PRESENCE ---------------------------------------------

    cantidad_datos_PilotPresence: constant := 200;
    type Indice_Secuencia_PilotPresence is mod cantidad_datos_PilotPresence;
    type tipo_Secuencia_PilotPresence is array (Indice_Secuencia_PilotPresence) of PilotPresence_Type;     
                
    ---------------------------------------------------------------------
    ------ PILOT'S BUTTON -----------------------------------------------

    cantidad_datos_PilotButton: constant := 200;
    type Indice_Secuencia_PilotButton is mod cantidad_datos_PilotButton;
    type tipo_Secuencia_PilotButton is array (Indice_Secuencia_PilotButton) of PilotButton_Type;
    
end data_Scenarios;



