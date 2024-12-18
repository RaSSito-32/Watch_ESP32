
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with devicesFSS_V1; use devicesFSS_V1;

-- NO ACTIVAR ESTE PAQUETE MIENTRAS NO SE TENGA PROGRAMADA LA INTERRUPCION
-- Packages needed to generate button interrupts       
with Ada.Interrupts.Names;
with Button_Interrupt; use Button_Interrupt;

package body fss is

    ----------------------------------------------------------------------
    ------------- procedure exported 
    ----------------------------------------------------------------------
    procedure Background is
    begin
      loop
        null;
      end loop;
    end Background;
    ----------------------------------------------------------------------
    
    -----------------------------------------------------------------------
    ------------- declaration of objects 
    -----------------------------------------------------------------------
    Roll_Priority : integer := 15;
    Pitch_Altitude_Priority : integer := 13;
    Vel_Engines_Priority : integer := 11;
    Collisions_Priority : integer := 17;
    Display_Priority : integer := 9;
    
    Roll_Period : Duration := 0.28;
    Pitch_Altitude_Period : Duration := 0.28;
    Vel_Engines_Period : Duration := 0.38;
    Collisions_Period : Duration := 0.27;
    Display_Period : Duration := 1.2;
    
    type Cont_Maneuver is new integer range 1..12;
    Cont_Maneuver_Pitch : Cont_Maneuver := 1;
    Cont_Maneuver_Roll : Cont_Maneuver := 1;
    Maneuver: boolean := false;
    -----------------------------------------------------------------------
    
    -----------------------------------------------------------------------
    ------------- declaration of protected objects 
    -----------------------------------------------------------------------
    
    -- Aqui se declaran los objetos protegidos para los datos compartidos  
    protected Roll_Pitch_Velocity_Data is
      pragma priority(Roll_Priority);
      procedure Put_Roll (data_roll: in Joystick_Values);
      procedure Put_Pitch (data_pitch: in Joystick_Values);
      function Take_Data return Joystick_Type;
    
      private
        Joystick_Private: Joystick_Type := (0,0);
    end Roll_Pitch_Velocity_Data;
    
   protected Control_Button is
      pragma priority(Priority_Of_External_Interrupts_2);
      procedure Interrupt_Button;
      pragma Attach_Handler(Interrupt_Button, Ada.Interrupts.Names.External_Interrupt_2);
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
        Execution_Time(Milliseconds(5));
        Joystick_Private(x) := data_roll;
      end Put_Roll;
      
      procedure Put_Pitch (data_pitch: in Joystick_Values) is
      begin
        Execution_Time(Milliseconds(5));
        Joystick_Private(y) := data_pitch;
      end Put_Pitch;
      
      function Take_Data return Joystick_Type is
      begin
        Execution_Time(Milliseconds(2));
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
        Execution_Time(Milliseconds(2));
        return Mode;
      end Get_Mode;
      
      procedure Set_Mode is
      begin
        Execution_Time(Milliseconds(5));
        Mode := not Mode;
      end Set_Mode;
      
    end Control_Button; 
    
    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------
    -- Aqui se declaran las tareas que forman el STRz
    
    task Roll is
      --Establize the correct priority
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
      pragma priority(Priority_Of_External_Interrupts_2);
    end Press_Button; 
    	
    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------
    -- Aqui se escriben los cuerpos de las tareas   

    Task body Roll is
    Siguiente_Instante : Time;
    Intervalo :Duration := 2.0;
    c : Time;
    p: Time_Span;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        --Start_Activity ("Begin Control_Roll");
        c:= Clock;
        Control_Roll;
        --Current_Time(c);
        --Finish_Activity("Final Control_Roll");
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo);
      end loop;
    end Roll;
   
    Task body Pitch_and_Altitud is
    Siguiente_Instante : Time;
    Intervalo :Duration := 2.0;
    c : Time;
    p: Time_Span;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        --Start_Activity ("Begin Control_Pitch_and_Altitud");
        c:= Clock;
        Control_Pitch_and_Altitud;
        --Current_Time(c);
        --Finish_Activity("Final Control_Pitch_and_Altitud");
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Pitch_and_Altitud; 
   
    Task body VelEngines is
    Siguiente_Instante : Time;
    Intervalo :Duration := 2.0;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        --Start_Activity ("Begin Control_Velocity_Engines ");
        C := Clock;
        Control_Vel_Engines;
        --Current_Time(C);
        --Finish_Activity("Final Control_Velocity_Engines");
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end VelEngines;
    
    Task body Collisions is
    Siguiente_Instante : Time;
    Intervalo :Duration := 2.0;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        --Start_Activity ("Begin Control_Collisions ");
        C := Clock;
        Control_Collisions;
        --Current_Time(C);
        --Finish_Activity("Final Control_Collisions");
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Collisions;
    
    Task body Show_Info is
    Siguiente_Instante : Time;
    Intervalo :Duration := 1.0;
    C : Time;
    begin
      Siguiente_Instante := Clock + To_Time_Span(Intervalo);
      loop
        --Start_Activity ("Begin Display ");
        C:= Clock;
        Show_Display;
        --Finish_Activity("Final Display");
        Current_Time(C);
        delay until Siguiente_Instante;
        Siguiente_Instante :=  Siguiente_Instante + To_Time_Span(Intervalo); 
      end loop;
    end Show_Info;
    
    task body Press_Button is
    C: Time;
    begin
      loop
        Control_Button.Wait_Event;
        --Start_Activity ("Begin Interrupt ");
        C:= Clock;
        Control_Button.Set_Mode;
        --Current_Time(C);
        --Finish_Activity("Final Interrupt");
      end loop;
    end Press_Button; 
    ----------------------------------------------------------------------
    
    Procedure Control_Roll is
    Grade_Rotation: Joystick_Values := 0;
    Current_Joystick: Joystick_Type := (0,0);
    
    begin
      Read_Joystick(Current_Joystick);
      if (Control_Button.Get_Mode) then
    
        if (Current_Joystick(x) > 45) then
          Grade_Rotation := 45;
        elsif (Current_Joystick(x) < -45) then
          Grade_Rotation := -45;
        else
          Grade_Rotation := Current_Joystick(x);
        end if;
      
        if (not Get_Maneuver) then
          Set_Aircraft_Roll(Roll_Type (Grade_Rotation));
          Roll_Pitch_Velocity_Data.Put_Roll(Current_Joystick(x));
        end if;
        
      else
        Set_Aircraft_Roll(Roll_Type (Current_Joystick(x)));
        Roll_Pitch_Velocity_Data.Put_Pitch(Current_Joystick(x));
      end if;
      
    end Control_Roll;
    
    --Procedimiento para controlar el cabeceo y la altitud
    Procedure Control_Pitch_and_Altitud is
    Altitude: Altitude_Type := 0;
    Grade_Pitch: Pitch_Type := 0;
    Current_Joystick: Joystick_Type := (0,0);
    
    begin
      --Leemos los datos que le entran del Joystick, Cabeceo y Altura.
      Altitude:= Read_Altitude;
      Read_Joystick(Current_Joystick);
      
      if (Current_Joystick(y) < -30) then
        Grade_Pitch := 30;
      elsif (Current_Joystick(y) > 30) then
        Grade_Pitch := -30;
      else
        Grade_Pitch := Pitch_Type (Current_Joystick(y) * (-1)); 
      end if;
      
      --Se enciende el led 1 si se pasa por debajo o se sobrepasa de las diferentes alturas respectivas.
      if (Altitude < 2500 or Altitude > 9500) then
        Light_1(On);
      else
        Light_1(Off);
      end if;
      
      if (Control_Button.Get_Mode) then
        if (not Get_Maneuver) then
          if ((Altitude <= 2000 and Grade_Pitch < 0) or (Altitude >= 10000 and Grade_Pitch > 0)) then
            set_Aircraft_Pitch(0);
          else
            set_Aircraft_Pitch(Grade_Pitch);
          end if;
        --Actualizar dato roll privado
        Roll_Pitch_Velocity_Data.Put_Pitch(Current_Joystick(y));
        end if;
      else
        set_Aircraft_Pitch(Pitch_Type (Current_Joystick(y) * (-1)));
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
    
    begin
      Read_Power(Current_Pw);
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
          Light_2(On);
          Set_Speed(1000);
        elsif (Velocity <= 300) then
          Light_2(On);
          Set_Speed(300);
        else
          Set_Speed(Velocity);
          Light_2(Off);
        end if;
      else
        if (Velocity >= 1000 or Velocity <= 300) then
          Light_2(On);
        else
          Light_2(Off);
        end if;
        Set_Speed (Velocity);
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
    
    begin
      if (Control_Button.Get_Mode) then
      
        Read_Distance(Current_Obstacle_Distance);
        Read_Power(Current_Pw);
        Current_S := Speed_Type (float (Current_Pw) * 1.2);
      
        Time_To_Collision := integer(Current_Obstacle_Distance) * 3600;
        Time_To_Collision := Time_To_Collision / 1000;
        Time_To_Collision := Time_To_Collision / (integer(Current_S));

        Pilot_P := Read_PilotPresence;
        Read_Light_Intensity(Current_Light);
        if (Control_Button.Get_Mode) then
          if (Pilot_P = 1) then
            if (Time_To_Collision < 10) then
              Alarm(4);
            end if;
            if (Time_To_Collision < 5) then
              Set_Maneuver(true);
            end if;
        
          elsif (Current_Light < 500 or Pilot_P = 0) then
            if (Time_To_Collision < 15) then
              Alarm(4);
            end if;
      	    if (Time_To_Collision < 10) then
      	      Set_Maneuver(true);
            end if;
          end if;
       
        --Control Maneuver
          if (Get_Maneuver) then
            Current_A := Read_Altitude;
            if (Cont_Maneuver_Pitch > 1 or Current_A <= 8500) then
              Cont_Maneuver_Pitch := Cont_Maneuver_Pitch + 1;
              Set_Aircraft_Pitch(20);
            end if;
            if (Cont_Maneuver_Roll > 1 or Current_A > 8500) then
              Cont_Maneuver_Roll := Cont_Maneuver_Roll + 1;
              Set_Aircraft_Roll(45);
            end if;
        
            if (Cont_Maneuver_Pitch = 12) then
              if (Cont_Maneuver_Roll = 1) then
                Set_Maneuver(False);
              end if;
              Set_Aircraft_Pitch(0);
              Cont_Maneuver_Pitch := 1;
            end if;
        
            if (Cont_Maneuver_Roll = 12) then
              if (Cont_Maneuver_Pitch = 1) then
                Set_Maneuver(False);
              end if;
              Set_Aircraft_Roll(0);
              Cont_Maneuver_Roll := 1;
            end if;
          end if;
        end if;
        
        else
          if (Time_To_Collision < 10) then
            Alarm(4);
          end if;  
        end if;
        
    end Control_Collisions;
    
    Procedure Show_Display is
    Current_Roll: Roll_Type := 0;
    Grade_Rotation: Joystick_Values := 0;
    Current_Pitch: Pitch_Type := 0;
    Grade_Pitch: Joystick_Values := 0;
    Current_Joystick: Joystick_Type := (0,0);
    Altitude: Altitude_Type := 0;
    Current_Pw: Power_Type := 0;
    Velocity: Speed_type := 0; 
    Current_Obstacle_Distance: Distance_Type := 0;
    
    begin
      Altitude:= Read_Altitude;
      Velocity:= Read_Speed;
      Current_Roll := Read_Roll;
      Current_Pitch := Read_Pitch;
      Read_Joystick(Current_Joystick);
      Read_Power(Current_Pw);
      Read_Distance(Current_Obstacle_Distance);
      
      --Show the information
      Display_Altitude(Altitude);
      Display_Pilot_Power(Current_Pw);
      Display_Speed(Velocity);
      Display_Joystick(Current_Joystick);
      Display_Pitch(Current_Pitch);
      Display_Roll(Current_Roll);
      
      if (Current_Roll >= 35) then
        Display_Message("The Roll is over than 35 grades!!");
      elsif (Current_Roll <= -35) then
        Display_Message("The Roll is under than -35 grades!!");
      end if;
      
      if (Velocity >= 1000) then
        Display_Message("The Velocity es more than 1000 km/h!!");
      elsif (Velocity <= 300) then
        Display_Message("The Velocity es less than 300 km/h");
      end if;
      
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
   Finish_Activity ("Programa Principal");
end fss;

