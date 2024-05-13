----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 12:22:21
-- Design Name: 
-- Module Name: Memory - Behavioral
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

entity Memory is
--  Port ( );
    PORT (
        clock: IN std_logic;
        write: IN std_logic;
        addressIn: IN std_logic_vector(12 downto 0);
        dataIn: IN std_logic_vector(7 downto 0);
        dataOut: OUT std_logic_vector(7 downto 0)
        );
end Memory;

architecture Behavioral of Memory is
COMPONENT ROM
    PORT(
        addressIn: In std_logic_vector (11 downto 0);
        dataOut: OUT std_logic_vector(7 downto 0));
end COMPONENT;
COMPONENT RAM
    PORT(clock: IN std_logic; 
    write: IN std_logic;
    addressIn: IN std_logic_vector (11 downto 0); 
    dataIn: IN std_logic_vector(7 downto 0); 
    dataOut: OUT std_logic_vector(7 downto 0));
end COMPONENT;
    signal RamDataOut: std_logic_vector(7 downto 0);
    signal RomDataOut: std_logic_vector(7 downto 0);
    FOR ALL: RAM USE ENTITY work.RAM(behavioral);
    FOR ALL: ROM USE ENTITY work.ROM(behavioral);
begin
    RamMemory: RAM PORT MAP(
        clock => clock, 
        write => write, 
        addressIn => addressIn(11 downto 0), 
        dataIn => dataIn, 
        dataOut => RamDataOut
        );
    RomInstruction: ROM PORT MAP(
        addressIn => addressIn(11 downto 0), 
        dataOut => RomDataOut
        );
    
    DataOut <= RomDataOut when addressIn(12) = '0' else RamDataOut;

end Behavioral;
