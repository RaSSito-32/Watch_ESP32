----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2024 21:54:49
-- Design Name: 
-- Module Name: Pruebas_Memoria - Behavioral
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

entity Pruebas_Memoria is
--  Port ( );
end Pruebas_Memoria;

architecture Behavioral of Pruebas_Memoria is
    Component MemoryController is
        PORT(
        clock: IN std_logic;                            --Flanco de reloj
        resetIn: IN std_logic;                          --Resetea Controlador de Memoria
        write: IN std_logic;                            --Se alar si se quiere escribir o no
        startIn: IN std_logic;                          --Para empezar el proceso de escritura o lectura
        addressIn: IN std_logic_vector(31 downto 0);    --Direccionamiento
        dataIn: IN std_logic_vector(31 downto 0);       --Entrada de datos
        wordType: IN std_logic_vector(1 downto 0);      --Tipo de palabra (Byte [00], media palabra (16 bits) [01], palabra (32 bits)[1X])
        extendSign: IN std_logic;                       --Extensi n
        dataOut: OUT std_logic_vector(31 downto 0);     --Salida de datos
        readyOut: OUT std_logic
    );
    end component;
    signal clock: std_logic := '0';
    signal finalize: std_logic := '0';
    signal resetIn: std_logic := '1';
    signal write: std_logic := '0';
    signal startIn: std_logic := '1';
    signal addressIn :std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(6, 32));
    signal dataIn: std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(0, 32));
    signal dataOut: std_logic_vector(31 downto 0);
    signal wordType: std_logic_vector(1 downto 0) := "00";
    signal extendSign: std_logic := '1';
    signal readyOut: std_logic;
    FOR ALL: MemoryController USE ENTITY work.MemoryController(Behavioral);
begin
    MC: MemoryController PORT MAP (
        clock => clock,
        resetIn => resetIn,
        write => write,
        StartIn => StartIn,
        addressIn => addressIn,
        dataIn => dataIn,
        wordType => wordType,
        extendSign => extendSign,
        dataOut => dataOut,
        readyOut => readyOut
    );
    
    resetIn <= '0' after 60 ns;
    startIn <= '0' after 100 ns;
    finalize <= '1' after 1 ms;
    clock <= not clock after 20 ns when finalize /= '1' else '0';
    
end Behavioral;
