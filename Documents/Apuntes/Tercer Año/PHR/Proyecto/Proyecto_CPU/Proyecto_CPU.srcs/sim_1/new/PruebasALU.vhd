----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 12:07:30
-- Design Name: 
-- Module Name: PruebasALU - testALU
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PruebasALU is
--  Port ( );
end PruebasALU;

architecture testALU of PruebasALU is
    component ALU
        Port (
            A: IN std_logic_vector(31 downto 0);
            B: IN std_logic_vector(31 downto 0);
            SEL: IN std_logic_vector(4 downto 0);
            RES: OUT std_logic_vector(31 downto 0)
            );
    end component;
    
    signal Selector    : std_logic_vector(4 downto 0);
    signal A    : std_logic_vector(31 downto 0);
    signal B    : std_logic_vector(31 downto 0);
    signal Result    : std_logic_vector(31 downto 0);

begin

    TEST_ALU: ALU port map (
        A  => A,
        B  => B,
        SEL  => Selector,
        RES  => Result
    );
    
    process
    begin
       
        Selector <= "00000";
        A <= "00000000000000000000000000000010";
        B <= "00000000000000000000000000000011";
        wait for 10 ns;
            

       
        Selector <= "00001";
        A <= "00000000000000000000000000000100";
        B <= "00000000000000000000000000000010";
        wait for 10 ns;

       
        Selector <= "00010";
        A <= "00000000000000000000000000000011";
        B <= "00000000000000000000000000001011";
        wait for 10 ns;

        
        Selector <= "00011";
        A <= "00000000000000000000000000000101"; --5
        B <= "00000000000000000000000000001010"; --A
        wait for 10 ns;

        Selector <= "00100";
        A <= "00000000000000000000000000011100";  --28  --1C
        B <= "00000000000000000000000000010010";  --18  --12   --SOLUCION = C
        wait for 10 ns;
        
        Selector <= "00101";  --ShiftLeft  --5
        A <= "00000000000000000000000000000010";  --2 --SOL = 4
        B <= "00000000000000000000000000000001";
        wait for 10 ns;
        
        Selector <= "00110";  --ShiftRight
        A <= "00000000000000000000000000000010";  --2 --SOL = 1
        B <= "00000000000000000000000000000000";
        wait for 10 ns;
        
        Selector <= "00111";  --ShiftRightArithmetic                     --No esta programado 
        A <= "00000000000000000000000000001100"; --C
        B <= "00000000000000000000000000000000"; --0  --SOL = 6
        wait for 10 ns;
        
        Selector <= "01000";
        A <= "00000000000000000000000000001111";
        B <= "00000000000000000000000000010001";
        wait for 10 ns;
        
        wait;
    end process;
end testALU;
