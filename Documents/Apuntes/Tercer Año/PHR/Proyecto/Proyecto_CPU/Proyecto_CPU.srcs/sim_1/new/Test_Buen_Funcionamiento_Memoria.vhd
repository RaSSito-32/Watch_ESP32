----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2024 15:33:04
-- Design Name: 
-- Module Name: Test_Buen_Funcionamiento_Memoria - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Buen_Funcionamiento_Memoria is
--  Port ( );
end Test_Buen_Funcionamiento_Memoria;

architecture Behavioral of Test_Buen_Funcionamiento_Memoria is
    COMPONENT Memory is
        PORT(
            clock: IN std_logic;
            write: IN std_logic;
            addressIn: IN std_logic_vector(12 downto 0);
            dataIn: IN std_logic_vector(7 downto 0);
            dataOut: OUT std_logic_vector(7 downto 0)
        );
    end component;
    signal clock : std_logic := '0';
    signal write: std_logic := '0';
    signal dataIn: std_logic_vector(7 downto 0);
    signal dataOut: std_logic_vector(7 downto 0);
    signal addressD: std_logic_vector(12 downto 0);
    signal addressQ : std_logic_vector(12 downto 0) := "0000000000000";
    signal finalize: std_logic := '0';
    signal reset: std_logic := '1';
begin
    Mem: Memory PORT MAP(
        clock => clock,
        write => write,
        addressIn => addressQ,
        dataIn => dataIn,
        dataOut => dataOut
        );
    write <= '0';
    reset <= '0' after 3 ns;
    finalize <= '1' after 20 ms;
    clock <= not clock after 10 ns when finalize /= '1' 
        else '0';
    addressD <= std_logic_vector(unsigned(AddressQ) + 1) when (finalize = '0') else
	            addressQ;
    process (clock)
    begin
        if rising_edge(clock) then
            addressQ <= addressD;
        end if;
    end process;
end Behavioral;
