package fss is
  procedure Background;
  procedure Control_Roll;
  procedure Control_Pitch_and_Altitud;
  procedure Control_Vel_Engines;
  procedure Control_Collisions;
  procedure show_Display;
  procedure Set_Maneuver (Input: in boolean) ;
  function Get_Maneuver return boolean;
end fss;
