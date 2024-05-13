----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 11:41:40
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
--  Port ( );
    Port(
        clock: in std_logic;
        write: IN std_logic;
        addressIn: in std_logic_vector(11 downto 0);
        dataIn: in std_logic_vector(7 downto 0);
        dataOut: out std_logic_vector(7 downto 0)
    );
end RAM;

architecture Behavioral of RAM is
    type ram_type is array (0 to 4095) of std_logic_vector(7 downto 0); --Definición del tipo de ram a usar
    signal ram: ram_type;
    signal read_address: std_logic_vector(11 downto 0); --variable que guarda dirección a leer
begin
    RamProc: process(clock) is
    
    begin
        if rising_edge (clock) then
            if write = '1' then
                ram(to_integer(unsigned(addressIn))) <= dataIn;
            end if;
            read_address <= addressIn;
         end if;
    end process RamProc;
    dataOut <= ram(to_integer(unsigned(read_address)));

end Behavioral;
