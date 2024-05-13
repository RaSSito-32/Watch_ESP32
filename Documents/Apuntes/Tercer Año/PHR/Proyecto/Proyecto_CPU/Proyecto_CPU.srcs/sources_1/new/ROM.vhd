----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 09:39:46
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
--  Port ( );
    PORT(
        addressIn: IN std_logic_vector(11 downto 0);
        dataOut: OUT std_logic_vector(7 downto 0)
        );
end ROM;

architecture Behavioral of ROM is
type ROMtype is array (0 to 127) of std_logic_vector (7 downto 0);
constant Data : ROMType := (
    x"37",
    x"21",
    x"00",
    x"00",
    x"13",
    x"01",
    x"aa",
    x"ff",
    x"ef",
    x"00",
    x"80",
    x"00",
    x"6f",
    x"00",
    x"00",
    x"00",
    x"13",
    x"01",
    x"01",
    x"fe",
    x"23",
    x"2e",
    x"81",
    x"00",
    x"13",
    x"04",
    x"01",
    x"02",
    x"b7",
    x"17",
    x"00",
    x"00",
    x"23",
    x"80",
    x"07",
    x"00",
    x"23",
    x"26",
    x"04",
    x"fe",
    x"6f",
    x"00",
    x"00",
    x"01",
    x"83",
    x"27",
    x"c4",
    x"fe",
    x"93",
    x"87",
    x"17",
    x"00",
    x"23",
    x"26",
    x"f4",
    x"fe",
    x"03",
    x"27",
    x"c4",
    x"fe",
    x"93",
    x"07",
    x"40",
    x"00",
    x"e3",
    x"d6",
    x"e7",
    x"fe",
    x"b7",
    x"17",
    x"00",
    x"00",
    x"03",
    x"c7",
    x"07",
    x"00",
    x"b7",
    x"17",
    x"00",
    x"00",
    x"13",
    x"47",
    x"17",
    x"00",
    x"13",
    x"77",
    x"f7",
    x"0f",
    x"23",
    x"80",
    x"e7",
    x"00",
    x"6f",
    x"f0",
    x"9f",
    x"fc",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00"
);
begin
    DataOut <= Data(to_integer(unsigned(addressIn(6 downto 0))));
end Behavioral;
