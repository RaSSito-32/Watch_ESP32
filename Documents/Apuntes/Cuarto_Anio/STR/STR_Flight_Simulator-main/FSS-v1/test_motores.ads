with Data_Scenarios; use Data_Scenarios;
with devicesfss_v1; use devicesfss_v1;

package test_motores is

    ---------------------------------------------------------------------
    ------ SCENARIO ----------------------------------------------------- 
    ---------------------------------------------------------------------
    altura_motores: Altitude_Type := 7000;
    
    Joystick_motores: tipo_Secuencia_Joystick :=  -- 1 muestra cada 100ms.
                ((+00,-20),(+00,-20),(+00,-20),(+00,-20),(+00,-20),  
                 (+00,-20),(+00,-20),(+00,-20),(+00,-20),(+00,-20),  --1s.
 
                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  
                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  --2s.

                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  
                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  --3s.

                 (+00,+10),(+00,+10),(+00,+10),(+00,+10),(+00,+10),  
                 (+00,+10),(+00,+10),(+00,+10),(+00,+10),(+00,+10),  --4s.

                 (+00,+20),(+00,+20),(+00,+20),(+00,+20),(+00,+20),  
                 (+00,+20),(+00,+20),(+00,+20),(+00,+20),(+00,+20),  --5s.
                  
                 (+10,+20),(+10,+20),(+10,+20),(+10,+20),(+10,+20),  
                 (+10,+20),(+10,+20),(+10,+20),(+10,+20),(+10,+20),  --6s.
 
                 (+20,+20),(+20,+20),(+20,+20),(+20,+20),(+20,+20),  
                 (+20,+20),(+20,+20),(+20,+20),(+20,+20),(+20,+20),  --7s.

                 (+10,+10),(+10,+10),(+10,+10),(+10,+10),(+10,+10),  
                 (+10,+10),(+10,+10),(+10,+10),(+10,+10),(+10,+10),  --8s.

                 (+00,+10),(+00,+10),(+00,+10),(+00,+10),(+00,+10),  
                 (+00,+10),(+00,+10),(+00,+10),(+00,+10),(+00,+10),  --9s.

                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  
                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  --10s.
                 
                 (-10,+00),(-10,+00),(-10,+00),(-10,+00),(-10,+00),  
                 (-10,+00),(-10,+00),(-10,+00),(-10,+00),(-10,+00),  --11s.
 
                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  
                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  --12s.

                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  
                 (+00,+00),(+00,+00),(+00,+00),(+00,+00),(+00,+00),  --13s.

                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  
                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  --14s. maneuver pitch +

                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  
                 (+00,-10),(+00,-10),(+00,-10),(+00,-10),(+00,-10),  --15s.
                  
                 (+10,+00),(+10,+00),(+10,+00),(+10,+00),(+10,+00),  
                 (+10,+00),(+10,+00),(+10,+00),(+10,+00),(+10,+00),  --16s. maneuver roll
 
                 (+10,+00),(+10,+00),(+10,+00),(+10,+00),(+10,+00),  
                 (+10,+00),(+10,+00),(+10,+00),(+10,+00),(+10,+00),  --17s.

                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10),  
                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10),  --18s. maneuver ambos

                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10),  
                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10),  --19s.

                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10),  
                 (+10,-10),(+10,-10),(+10,-10),(+10,-10),(+10,-10));  --20s.
                                  
    Distancia_motores: tipo_Secuencia_Distancia :=  -- next sample every 100ms.
            ( 5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 1s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 2s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 3s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 4s.  
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 5s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 6s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 7s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 8s.  
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 9s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 10s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 11s. 
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 12s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 13s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 14s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 15s. 
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 16s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 17s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 18s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555,   -- 19s.
              5555,5555,5555,5555,5555, 5555,5555,5555,5555,5555);  -- 20s.
                 
    Light_Intensity_motores: tipo_Secuencia_Light :=  -- 1 muestra cada 100ms.
                 ( 700,700,700,700,700, 700,700,700,700,700,   -- 1s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 2s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 3s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 4s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 5s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 6s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 7s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 8s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 9s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 10s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 11s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 12s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 13s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 14s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 15s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 16s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 17s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 18s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 19s.
                   700,700,700,700,700, 700,700,700,700,700);  -- 20s.
                 
                 
    Power_motores: tipo_Secuencia_Power :=  -- next sample every 100ms.
                 ( 800,800,800,800,800, 800,800,800,800,800,   -- 1s.
                   833,833,833,833,833, 833,833,833,833,833,   -- 2s.
                   900,900,900,900,900, 900,900,900,900,900,   -- 3s.
                   900,900,900,900,900, 900,900,900,900,900,   -- 4s.
                   900,900,900,900,900, 900,900,900,900,900,   -- 5s.
                   800,800,800,800,800, 800,800,800,800,800,   -- 6s.
                   700,700,700,700,700, 700,700,700,700,700,   -- 7s.
                   600,600,600,600,600, 600,600,600,600,600,   -- 8s.
                   500,500,500,500,500, 500,500,500,500,500,   -- 9s.
                   400,400,400,400,400, 400,400,400,400,400,   -- 10s.
                   300,300,300,300,300, 300,300,300,300,300,   -- 11s.
                   300,300,300,300,300, 300,300,300,300,300,   -- 12s.
                   250,250,250,250,250, 250,250,250,250,250,   -- 13s.
                   250,250,250,250,250, 250,250,250,250,250,   -- 14s.
                   250,250,250,250,250, 250,250,250,250,250,    -- 15s.
                   250,250,250,250,250, 250,250,250,250,250,   -- 11s.
                   300,300,300,300,300, 300,300,300,300,300,   -- 12s.
                   300,300,300,300,300, 300,300,300,300,300,   -- 13s.
                   300,300,300,300,300, 300,300,300,300,300,   -- 14s.
                   300,300,300,300,300, 300,300,300,300,300); -- 20s.


    PilotPresence_motores: tipo_Secuencia_PilotPresence :=  -- 1 muestra cada 100ms.
                 ( 1,1,1,1,1, 1,1,1,1,1,   -- 1s. 
                   1,1,1,1,1, 1,1,1,1,1,   -- 2s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 3s.
                   1,1,1,1,1, 1,1,0,1,0,   -- 4s. 
                   1,1,1,1,1, 1,1,1,1,1,   -- 5s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 6s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 7s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 8s. 
                   1,1,0,0,1, 1,1,1,1,1,   -- 9s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 10s.
                   1,1,1,0,1, 1,1,1,1,1,   -- 11s. 
                   1,1,1,1,1, 1,1,1,1,1,   -- 12s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 13s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 14s. 
                   0,0,0,0,0, 0,0,0,0,0,   -- 15s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 16s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 17s.
                   1,1,1,1,1, 1,1,1,1,1,   -- 18s. 
                   1,1,1,1,1, 1,1,1,1,1,   -- 19s.
                   1,1,1,1,1, 1,1,1,1,1);  -- 20s.                   
                   

    PilotButton_motores: tipo_Secuencia_PilotButton :=  -- 1 muestra cada 100ms.
                 ( 0,0,0,0,0, 0,0,0,0,0,   -- 1s. 
                   0,0,0,0,0, 1,1,1,0,0,   -- 2s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 3s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 4s. 
                   1,1,1,1,0, 0,0,0,0,0,   -- 5s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 6s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 7s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 8s. 
                   0,0,0,0,0, 0,0,0,0,0,   -- 9s.
                   0,0,0,0,0, 0,0,0,0,0,  -- 10s.                   
                   0,0,0,0,0, 0,0,0,0,0,   -- 11s. 
                   0,0,0,0,0, 1,1,1,1,1,   -- 12s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 13s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 14s. 
                   0,0,0,0,0, 0,0,0,0,0,   -- 15s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 16s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 17s.
                   0,0,0,0,0, 0,0,0,0,0,   -- 18s. 
                   0,0,0,0,0, 0,0,0,0,0,   -- 19s.
                   0,0,0,0,0, 0,0,0,0,0);  -- 20s.
                   
end test_motores;


