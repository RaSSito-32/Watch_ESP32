 
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Devices_A; use Devices_A;
procedure control2 is

  ----------------------------------------------------------------------
  ------------- procedure exported 
  ----------------------------------------------------------------------
  procedure Background is
  begin
    loop
      null;
    end loop;
  end Background;
  
  procedure Lanza_Tareas;  
  
  procedure Lanza_Tareas is
  
   
    ------ ALTITUDE
    -- It reads the aircraft altitud: from 0 to 15000 meters.  
    type Altitude_Type is new natural range 0..15000;
    type Altitude_Increment_Type is new integer range -100..+100;    
    --Initial_Altitude: Altitude_Type := 8000;

    ------ SPEED
    -- It reads the aircraft speed: from 0 to 1100 Km/h.  
    type Speed_Type is new natural range 0..10230; 
    type Speed_Increment_Type is new integer range -50..+50;
    Speed_Global: Speed_Type := 0;
    -- procedure Increment_Speed (D: in Speed_Increment_Type); -- No se usa

    ------ AIRCRAFT_INCLINATION 
    -- Pitch   
    type Pitch_Type is new integer range -90..+90; 
    type Pitch_Increment_Type is new integer range -5..+5;

    type Roll_Type is new integer range -90..+90; 
    type Roll_Increment_Type is new integer range -5..+5; 
  
    ---------------------------------------------------------------------
    ------ PILOT INPUT devices interface -------------------------------- 
    ---------------------------------------------------------------------
  
    ------ ENGINE_POWER
    type Power_Type is new natural range 0..1023;
  
    ------ LIGHT
    type Light_Type is new natural range 0..1023;
  
    ------ DISTANCE
    type Distance_Type is new natural range 0..9000;
  
    ------ JOYSTICK
    type Joystick_Index is (x,y);
    type Joystick_Values is new integer range -90..+90;
    type Joystick_Type is array (Joystick_Index) 
                                      of Joystick_Values;
                                   
    ------ PILOT PRESENCE
    type PilotPresence_Type is new natural range 0..1; 
    ---------------------------------------------------------------------
    ------ AIRCRAFT CONTROL interface ----------------------------------- 
    ---------------------------------------------------------------------

    Global_Degree_Servo: integer := 90;

  -----------------------------------------------------------------------
  ------------- declaration of objects 
  -----------------------------------------------------------------------

    Roll_Priority : integer := 15;
    Pitch_Altitude_Priority : integer := 13;
    Vel_Engines_Priority : integer := 11;
    Collisions_Priority : integer := 17;
    Display_Priority : integer := 9;
  
    Roll_Period : Duration := 0.2;
    Pitch_Altitude_Period : Duration := 0.2;
    Vel_Engines_Period : Duration := 0.3;
    Collisions_Period : Duration := 0.2;
    Display_Period : Duration := 1.0;
  
    type Cont_Maneuver is new integer range 1..12;
    Cont_Maneuver_Pitch : Cont_Maneuver := 1;
    Cont_Maneuver_Roll : Cont_Maneuver := 1;
    Maneuver: boolean := false;
  
  -----------------------------------------------------------------------
    
  -----------------------------------------------------------------------
  ------------- declaration of protected objects 
  -----------------------------------------------------------------------
  
  protected Roll_Pitch_Velocity_Data is
    pragma priority(Roll_Priority);
    procedure Put_Roll (data_roll: in Joystick_Values);
    procedure Put_Pitch (data_pitch: in Joystick_Values);
    function Take_Data return Joystick_Type;
    
    private
      Joystick_Private: Joystick_Type := (0,0);
  end Roll_Pitch_Velocity_Data;
    
  protected Control_Button is
      pragma priority(25);
      procedure Interrupt_Button;
      --pragma Attach_Handler(Interrupt_Button, Ada.Interrupts.Names.External_Interrupt_2);
      entry Wait_Event;
      function Get_Mode return boolean;
      procedure Set_Mode;
      private
        Sem: boolean := False;
        Mode: boolean := true;
  end Control_Button;
  
  -----------------------------------------------------------------------
  ------------- body of protected
  -----------------------------------------------------------------------
  
  protected body Roll_Pitch_Velocity_Data is
      procedure Put_Roll (data_roll: in Joystick_Values) is
      begin
        --Execution_Time(Milliseconds(5));
        Joystick_Private(x) := data_roll;
      end Put_Roll;
      
      procedure Put_Pitch (data_pitch: in Joystick_Values) is
      begin
        --Execution_Time(Milliseconds(5));
        Joystick_Private(y) := data_pitch;
      end Put_Pitch;
      
      function Take_Data return Joystick_Type is
      begin
        --Execution_Time(Milliseconds(2));
        return Joystick_Private;
      end Take_Data;
      
    end Roll_Pitch_Velocity_Data;
    
   protected body Control_Button is
      procedure Interrupt_Button is
      begin
        Sem := true;
      end Interrupt_Button;
      
      entry Wait_Event when Sem is
      begin
        Sem := false;
      end Wait_Event;
      
      function Get_Mode return boolean is
      begin
        --Execution_Time(Milliseconds(2));
        return Mode;
      end Get_Mode;
      
      procedure Set_Mode is
      begin
        --Execution_Time(Milliseconds(5));
        Mode := not Mode;
      end Set_Mode;
      
    end Control_Button; 
    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------
    -- Aqui se declaran las tareas que forman el STRz
    
    procedure Control_Roll;
    procedure Control_Pitch_and_Altitud;
    procedure Control_Vel_Engines;
    procedure Control_Collisions;
    procedure Show_Display;
    function Get_Maneuver return boolean;
    procedure Set_Maneuver (Input: in boolean);
    
    task Roll is
      pragma priority(Roll_Priority);
    end Roll;
    
    task Pitch_and_Altitud is
      pragma priority(Pitch_Altitude_Priority);
    end Pitch_and_Altitud;
    
    task VelEngines is
      pragma priority(Vel_Engines_Priority);
    end VelEngines;
    
    task Collisions is
      pragma priority(Collisions_Priority);
    end Collisions;
    
    task Show_Info is
      pragma priority(Display_Priority);
    end Show_Info;
    
    task Press_Button is
      pragma priority(25);
    end Press_Button; 
    
    Task body Roll is
    Siguiente_Instante : Time;
    Intervalo : Duration := Roll_Period;
    
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        Control_Roll;
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo);
      end loop;
    end Roll;
   
    Task body Pitch_and_Altitud is
    Siguiente_Instante : Time;
    Intervalo :Duration := Pitch_Altitude_Period;
    c : Time;
    p: Time_Span;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        Control_Pitch_and_Altitud;
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Pitch_and_Altitud; 
   
    Task body VelEngines is
    Siguiente_Instante : Time;
    Intervalo :Duration := Vel_Engines_Period;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        Control_Vel_Engines;
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end VelEngines;
    
    Task body Collisions is
    Siguiente_Instante : Time;
    Intervalo :Duration := Collisions_Period;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        Control_Collisions;
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Collisions;
    
    Task body Show_Info is
    Siguiente_Instante : Time;
    Intervalo :Duration := 2.0;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        Show_Display;
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Show_Info;
    
    task body Press_Button is
    C: Time;
    begin
      loop
        Control_Button.Wait_Event;
        Control_Button.Set_Mode;
      end loop;
    end Press_Button; 
    
    -----------------------------------------------------------------------------------------------------------------------------
    Procedure Control_Roll is
    Grade_Rotation: Joystick_Values := 0;
    Current_Joystick: Joystick_Type := (0,0);
    Ok: integer := 0;
    
    begin
	  Current_Joystick(x) := Joystick_Values (Read_Gyroscope_X_A);

      if (Control_Button.Get_Mode) then
    
        if (Current_Joystick(x) > 45) then
          Grade_Rotation := 45;
        elsif (Current_Joystick(x) < -45) then
          Grade_Rotation := -45;
        else
          Grade_Rotation := Current_Joystick(x);
        end if;
      
        if (not Get_Maneuver) then
          Ok:= moveServo_A(Global_Degree_Servo + integer(Grade_Rotation));
          Roll_Pitch_Velocity_Data.Put_Roll(Current_Joystick(x));
        end if;
        
      else
        Ok := moveServo_A(Global_Degree_Servo + integer(Grade_Rotation));
        Roll_Pitch_Velocity_Data.Put_Pitch(Current_Joystick(x));
      end if;
      
    end Control_Roll;
    
    --Procedimiento para controlar el cabeceo y la altitud
    Procedure Control_Pitch_and_Altitud is
    Altitude: Altitude_Type := 0;
    Grade_Pitch: Pitch_Type := 0;
    Current_Joystick: Joystick_Type := (0,0);
    Ok : integer := 0;
    
    begin
      --Leemos los datos que le entran del Joystick, Cabeceo y Altura.
      Altitude := Altitude_Type (read_single_ADC_sensor_A(3));		--Leer la altitud por el adc CH1
      Altitude := Altitude * 10;
      Current_Joystick(y) := Joystick_VAlues (Read_Gyroscope_Y_A);
      
      if (Current_Joystick(y) < -30) then
        Grade_Pitch := 30;
      elsif (Current_Joystick(y) > 30) then
        Grade_Pitch := -30;
      else
        Grade_Pitch := Pitch_Type (Current_Joystick(y) * (-1)); 
      end if;
      
      --Se enciende el led 1 si se pasa por debajo o se sobrepasa de las diferentes alturas respectivas.
      if (Altitude < 2500 or Altitude > 9500) then
        Ok := set_led_1_A(1);
      else
        Ok := set_led_1_A(0);
      end if;
      
      if (Control_Button.Get_Mode) then
        if (not Get_Maneuver) then
          if ((Altitude <= 2000 and Grade_Pitch < 0) or (Altitude >= 10000 and Grade_Pitch > 0)) then
            current_Joystick(y) := 0;
            --set_Aircraft_Pitch(0);
            --Cambiar el valor de pitch
          else
            current_Joystick(y) := 0;
            --set_Aircraft_Pitch(Grade_Pitch);
            --Cambiar valor Pitch
          end if;
        --Actualizar dato roll privado
        Roll_Pitch_Velocity_Data.Put_Pitch(Current_Joystick(y));
        end if;
      else
        --set_Aircraft_Pitch(Pitch_Type (Current_Joystick(y) * (-1)));
        Roll_Pitch_Velocity_Data.Put_Pitch(Current_Joystick(y));
      end if;
      
    end Control_Pitch_and_Altitud;
    
    procedure Control_Vel_Engines is
      Current_Pw: Power_Type := 0;
      Velocity: Speed_type := 0; 
      Current_Roll: Roll_Type := 0;
      Last_Pitch: Pitch_Type := 0;
      Current_Pitch: Pitch_Type := 0;
      Current_Joystick: Joystick_Type := (0,0);
      Ok: integer := 0;
    
    begin
      Current_PW := Power_Type (read_single_ADC_sensor_A(2));
      Velocity := Speed_Type (float (Current_Pw) * 1.2);
      Current_Joystick := Roll_Pitch_Velocity_Data.Take_Data;
      
      if (Control_Button.Get_Mode) then
        if (Current_Joystick(y) /= 0 and Current_Joystick(x) = 0  and Velocity < 1000) then		--Maneuver Pitch
          Velocity := Velocity + 150;
        elsif (Current_Joystick(y) = 0 and Current_Joystick(x) /= 0 and Current_Pw < 1000) then		--Maneuver Roll
          Velocity := Velocity + 120;
        elsif (Current_Joystick(y) /= 0 and Current_Joystick(x) /= 0 and Current_Pw < 1000) then  	--Maneuver Pitch and Roll
        Velocity := Velocity + 300;
      end if;
      
        if (Velocity >= 1000) then
          Ok := Set_led_2_A(1);
          Speed_Global := 1000;
        elsif (Velocity <= 300) then
          Ok := Set_led_2_A(1);
          Speed_Global := 1000;
        else
          Speed_Global := Velocity;
          Ok := Set_led_2_A(0);			
        end if;
      else
        if (Velocity >= 1000 or Velocity <= 300) then
          Ok := Set_led_2_A(1);
        else
          Ok := Set_led_2_A(0);
        end if;
        Speed_Global := Velocity;		--Cambiar valor de velocidad
      end if;  
      
    end Control_Vel_Engines;
    
    procedure Control_Collisions is 
    Current_Obstacle_Distance: Distance_Type := 0;   
    Current_Pw : Power_Type := 0;
    Current_S :Speed_Type :=0;
    Velocity_Seconds : integer := 0;
    Time_To_Collision : integer := 0;
    Pilot_P: PilotPresence_Type;
    Current_A: Altitude_Type :=0;
    Current_Light: Light_Type := 0;
    Ok : integer := 0;
    
    begin
      if (Control_Button.Get_Mode) then
		Current_Obstacle_Distance := Distance_Type (read_infrared_A);
		Current_Pw := Power_Type (read_single_ADC_sensor_A(2));
 
        Current_S := Speed_Type (float (Current_Pw) * 1.2);
      
        Time_To_Collision := integer(Current_Obstacle_Distance) * 3600;
        Time_To_Collision := Time_To_Collision / 1000;
        Time_To_Collision := Time_To_Collision / (integer(Current_S));

        Pilot_P := 0;							--Ir cambiando el valor o boton
        Current_Light := Light_Type (read_single_ADC_sensor_A(0));
        if (Control_Button.Get_Mode) then
          if (Pilot_P = 1) then
            if (Time_To_Collision < 10) then
              Ok := 0; --Set_Led_1_A(1);
            else
			  Ok := 0; --Set_Led_1_A(1);
            end if;
            if (Time_To_Collision < 5) then
              Ok := 0; --Set_Led_1_A(1);
            else
			  Ok := 0; --Set_Led_1_A(1);
            end if;
        
          elsif (Current_Light < 500 or Pilot_P = 0) then
            if (Time_To_Collision < 15) then
              Ok := 0; --Set_Led_1_A(1);
            else
              Ok := 0; --Set_Led_1_A(1);
            end if;
      	    if (Time_To_Collision < 10) then
      	      Set_Maneuver(true);
            end if;
          end if;
       
        --Control Maneuver
          if (Get_Maneuver) then
            Current_A := Altitude_Type (read_single_ADC_sensor_A(3));
            if (Cont_Maneuver_Pitch > 1 or Current_A <= 8500) then
              Cont_Maneuver_Pitch := Cont_Maneuver_Pitch + 1;
              --Set_Aircraft_Pitch(20);			--Cambiar valor pitch
            end if;
            if (Cont_Maneuver_Roll > 1 or Current_A > 8500) then
              Cont_Maneuver_Roll := Cont_Maneuver_Roll + 1;
              Ok := moveServo_A(45);
            end if;
        
            if (Cont_Maneuver_Pitch = 12) then
              if (Cont_Maneuver_Roll = 1) then
                Set_Maneuver(False);
              end if;
              --Set_Aircraft_Pitch(0);			--Cambiar valor pitch
              Cont_Maneuver_Pitch := 1;
            end if;
        
            if (Cont_Maneuver_Roll = 12) then
              if (Cont_Maneuver_Pitch = 1) then
                Set_Maneuver(False);
              end if;
              Ok := moveServo_A(0);
              Cont_Maneuver_Roll := 1;
            end if;
          end if;
        end if;
        
        else
          if (Time_To_Collision < 10) then
            Ok := set_Led_1_A(1);
          else
            Ok := set_Led_1_A(0);
          end if;  
          
        end if;
        
    end Control_Collisions;
    
    Procedure Show_Display is
    Current_Roll: Roll_Type := 0;
    Current_Pitch: Pitch_Type := 0;
    Altitude: Altitude_Type := 0;
    Current_Power: Power_Type := 0;
    Velocity: Speed_type := 0; 
    Current_Obstacle_Distance: float := 0.0;
    Current_Light : Light_Type := 0;
    
    begin 
      Altitude:= Altitude_Type (read_single_ADC_sensor_A(3));
      Current_Power:= Power_Type (read_single_ADC_sensor_A(2));
      Velocity:= Speed_Type (float (Current_Power) * 1.2);
      Current_Roll := Roll_Type(read_Gyroscope_X_A);
      Current_Pitch := Pitch_Type(read_Gyroscope_Y_A);
      Current_Obstacle_Distance := getDistance_A;
      Current_Light := Light_Type(read_single_ADC_sensor_A(0));
      
      
      Put ("Altitud: ");
      Put (Altitude_Type'Image(Altitude));
      New_Line;
      
      Put("Roll: ");
      Put(Roll_Type'Image(Current_Roll));
      New_Line;
      
      --Put_Line("Pitch: ");
      --Put_Line(Pitch_Type'Image(Current_Pitch));
      --New_Line;
      
      --Put_Line("Velocity: ");
      --Put_Line(Speed_Type'Image(Velocity));
      --New_Line;
    end Show_Display;
    
    procedure Set_Maneuver (Input: in boolean) is
    begin
        Maneuver := Input;
    end Set_Maneuver;
      
    function Get_Maneuver return boolean is
    begin
      return Maneuver;
    end Get_Maneuver;
    
    begin 
      Put_Line ("Cuerpo del procedimiento Lanza_Tareas ");
      
  end Lanza_Tareas;
  

    -----------------------------------------------------------------------------------------------------------------------------
n : integer := 0;
  
     
begin
    put_line ("Arranca programa principal");
    n := Init_Devices_A;
    put ("Inicializados los dispositivos: "); put (n, 3); New_line;
    Lanza_Tareas;
end control2;
