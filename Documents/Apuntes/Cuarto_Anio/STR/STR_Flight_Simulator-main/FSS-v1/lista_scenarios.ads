with Ada.Real_Time; use Ada.Real_Time;

with data_Scenarios; use data_Scenarios;
with devicesfss_v1; use devicesfss_v1;

--with test_alabeo_cabeceo; use test_alabeo_cabeceo;
--with test_alabeo; use test_alabeo;
with test_colisiones; use test_colisiones;
--with test_motores; use test_motores;
--with test_modo_piloto; use test_modo_piloto;
--with test_general; use test_general;
--with scenario_v0; use scenario_v0;

package lista_Scenarios is

    ---------------------------------------------------------------------
    ------ SCENARIOS ----------------------------------------------------
    ---------------------------------------------------------------------
    
    ---------------------------------------------------------------------
    ------ Pruebas Cabeceo ----------------------------------------------
    
    -- Cabeceo Elevado.
    --Initial_Altitude: Altitude_Type := altura_cabeceo_elevado;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_cabeceo_elevado;
    
    -- Cabeceo Bajo.
    --Initial_Altitude: Altitude_Type := altura_cabeceo_bajo;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_cabeceo_bajo;
    
    --Datos que no se ponen a prueba pero tienen que estar.
    --Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_alabeo_cabeceo;
    --Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_alabeo_cabeceo;
    --Power_Simulation: tipo_Secuencia_Power := Power_alabeo_cabeceo;
    --PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_alabeo_cabeceo;
    --PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_alabeo_cabeceo;
    
    ---------------------------------------------------------------------
    ------ Pruebas Alabeo -----------------------------------------------
    
    --Initial_Altitude: Altitude_Type := altura_Alabeo;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_Alabeo;
    --Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_Alabeo;
    --Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_Alabeo;
    --Power_Simulation: tipo_Secuencia_Power := Power_Alabeo;
    --PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_Alabeo;
    --PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_Alabeo;
    
    ---------------------------------------------------------------------
    ------ Pruebas Motores ----------------------------------------------
    
    --Initial_Altitude: Altitude_Type := altura_motores;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_motores;
    --Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_motores;
    --Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_motores;
    --Power_Simulation: tipo_Secuencia_Power := Power_motores;
    --PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_motores;
    --PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_motores;
    
    ---------------------------------------------------------------------
    ------ Pruebas Colisiones -------------------------------------------
    
    Initial_Altitude: Altitude_Type := altura_colision;
    Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_colision;
    Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_colision;
    Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_colision;
    Power_Simulation: tipo_Secuencia_Power := Power_colision;
    PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_colision;
    PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_colision;
    
    ---------------------------------------------------------------------
    ------ Pruebas Modo Automatico o Manual -----------------------------
    
    --Initial_Altitude: Altitude_Type := altura_modo;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_modo;
    --Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_modo;
    --Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_modo;
    --Power_Simulation: tipo_Secuencia_Power := Power_modo;
    --PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_modo;
    --PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_modo;
    
    ---------------------------------------------------------------------
    ------ Pruebas Generales --------------------------------------------
    
    --Initial_Altitude: Altitude_Type := ;
    --Joystick_Simulation: tipo_Secuencia_Joystick :=  Joystick_Simulation;
    --Distance_Simulation: tipo_Secuencia_Distancia :=  Distancia_general;
    --Light_Intensity_Simulation: tipo_Secuencia_Light :=  Light_Intensity_Simulation;
    --Power_Simulation: tipo_Secuencia_Power := Power_Simulation;
    --PilotPresence_Simulation: tipo_Secuencia_PilotPresence :=  PilotPresence_Simulation;
    --PilotButton_Simulation: tipo_Secuencia_PilotButton :=  PilotButton_general;
    
    
    
end lista_Scenarios;



