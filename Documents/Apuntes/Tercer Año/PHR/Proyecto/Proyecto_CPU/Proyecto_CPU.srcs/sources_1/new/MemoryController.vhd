----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 11:21:14
-- Design Name: 
-- Module Name: MemoryController - Behavioral
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

entity MemoryController is
--  Port ( );
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
        readyOut: OUT std_logic);                       --Inidicaci n de la finalizaci n del proceso de escritura o lectura
end MemoryController;

architecture Behavioral of MemoryController is
COMPONENT Memory
    PORT(
        clock: IN std_logic;
        write: IN std_logic;
        addressIn: IN std_logic_vector(12 downto 0);
        dataIn: IN std_logic_vector(7 downto 0);
        dataOut: OUT std_logic_vector(7 downto 0)
        );
end COMPONENT;
    signal addressInD, addressInQ: std_logic_vector(31 downto 0);
    signal dataFromMemD, dataFromMemQ: std_logic_vector(31 downto 0);
    
    signal writeInMem: std_logic;
    signal addressInMem: std_logic_vector(12 downto 0);
    signal dataInMem: std_logic_vector(7 downto 0);
    signal dataOutMem: std_logic_vector(7 downto 0);
    
    signal muxAddr: std_logic_vector(1 downto 0);       --Incrementar, guardar o cargar Direcci n
    constant MUX_ADDR_KEEP: std_logic_vector(1 downto 0) := "00";
    constant MUX_ADDR_LOAD: std_logic_vector(1 downto 0) := "01";
    constant MUX_ADDR_INC: std_logic_vector(1 downto 0) := "10";
    
    signal extendSignSelect: std_logic;     --Extension de signo
    signal extendSignByte: std_logic_vector(7 downto 0);
    signal extendSignHalfWord: std_logic_vector(15 downto 0);
    signal extendSignWord: std_logic_vector(23 downto 0);
    
    signal muxDataOutMem: std_logic_vector(2 downto 0);    --Multiplexor salida de datos de memoria
    constant MUX_DATA_OUT_MEM_KEEP: std_logic_vector(2 downto 0):= "000";
    constant MUX_DATA_OUT_MEM_B0: std_logic_vector(2 downto 0):= "001";
    constant MUX_DATA_OUT_MEM_B1: std_logic_vector(2 downto 0):= "010";
    constant MUX_DATA_OUT_MEM_B2: std_logic_vector(2 downto 0):= "011";
    constant MUX_DATA_OUT_MEM_B3: std_logic_vector(2 downto 0):= "100";
    
    signal muxDataInMem: std_logic_vector(1 downto 0);     --Multiplexor entrada de datos de memoria
    constant MUX_DATA_IN_MEM_B0: std_logic_vector(1 downto 0):= "00";
    constant MUX_DATA_IN_MEM_B1: std_logic_vector(1 downto 0):= "01";
    constant MUX_DATA_IN_MEM_B2: std_logic_vector(1 downto 0):= "10";
    constant MUX_DATA_IN_MEM_B3: std_logic_vector(1 downto 0):= "11";
    
    signal FSMD: std_logic_vector(4 downto 0);      --Funcionamiento del controlador de memoria
    signal FSMQ : std_logic_vector(4 downto 0);
    type FSMValues is array(0 to 31) of std_logic_vector(4 downto 0);
    constant FSM : FSMValues := (
    	"00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111",
    	"01000", "01001", "01010", "01011", "01100", "01101", "01110", "01111",
    	"10000", "10001", "10010", "10011", "10100", "10101", "10110", "10111",
		"11000", "11001", "11010", "11011", "11100", "11101", "11110", "11111"
    );
    
    FOR ALL: Memory USE ENTITY work.Memory(behavioral);
begin
    Mem: Memory PORT MAP(
        clock => clock, 
        write => writeInMem, 
        addressIn => addressInMem, 
        dataIn => dataInMem, 
        dataOut => dataOutMem);
    
    process(clock)              --Introducir Direcci n en controlador Memoria
    begin
       if rising_edge (clock) then addressInQ <= addressInD;
       end if;
    end process;
    
    --Carga de la direccion segun el modo
    addressInD <= addressIn when (muxAddr = MUX_ADDR_LOAD) 
        else addressInQ when (muxAddr = MUX_ADDR_KEEP)
        else std_logic_vector(unsigned(addressInQ) + 1);
    addressInMem <= addressInQ(12 downto 0);
    
    --Sacar dato de memoria 
    process(clock)
    begin
        if rising_edge(clock) then 
            dataFromMemQ <= dataFromMemD;
        end if;
    end process;
    
    --Extensi n de signo
    extendSignByte <= "11111111" when ((dataOutMem(7) = '1') and (extendSignSelect = '1'))
        else "00000000";
    extendSignHalfWord <= "1111111111111111" when ((dataOutMem(7) = '1') and (extendSignSelect = '1'))
        else "0000000000000000";
    extendSignWord <= "111111111111111111111111" when ((dataOutMem(7) = '1') and (extendSignSelect = '1'))
        else "000000000000000000000000";
    
    --Salida de datos de la memoria
    dataFromMemD <=(extendSignWord & dataOutMem) when (muxDataOutMem = MUX_DATA_OUT_MEM_B0)
        else (extendSignHalfWord & dataOutMem & dataFromMemQ(7 downto 0)) when (muxDataOutMem = MUX_DATA_OUT_MEM_B1)
        else (extendSignByte & dataOutMem & dataFromMemQ(15 downto 0)) when (muxDataOutMem = MUX_DATA_OUT_MEM_B2)
        else (dataOutMem & dataFromMemQ(23 downto 0)) when (muxDataOutMem = MUX_DATA_OUT_MEM_B3)
        else dataFromMemQ;
    dataOut <= dataFromMemQ;
        
    --Entrada de datos a la memoria
    dataInMem <= dataIn(7 downto 0) when (muxDataInMem = MUX_DATA_IN_MEM_B0)
        else dataIn(15 downto 8) when (muxDataInMem = MUX_DATA_IN_MEM_B1)
        else dataIn(23 downto 16) when (muxDataInMem = MUX_DATA_IN_MEM_B2)
        else dataIn(31 downto 24);
        
    --Funcionamiento del controlador de memoria
    process(clock)
    begin
        if rising_edge(clock) then
            FSMQ <= FSMD;
        end if;
    end process;
    
    FSMD <= FSM(0) when ((resetIn = '1') or (FSMQ = FSM(0) and startIn = '0') or (FSMQ = FSM(17)))
        else FSM(1) when (FSMQ = FSM(0) and (startIn = '1'))
        else FSM(18) when (FSMQ = FSM(1) and write = '0')       --Ciclo extra para lectura, empieza proceso lectura
        else FSM(2) when (FSMQ = FSM(18))
        else FSM(3) when (FSMQ = FSM(2) and wordType /= "00")
        else FSM(19) when (FSMQ = FSM(3))       --Ciclo Extra para lectura
        else FSM(4) when (FSMQ = FSM(19))
        else FSM(5) when (FSMQ = FSM(4) and wordType /= "01")
        else FSM(20) when (FSMQ = FSM(5))       --Ciclo Extra para lectura
        else FSM(6) when (FSMQ = FSM(20))
        else FSM(7) when (FSMQ = FSM(6))
        else FSM(21) when (FSMQ = FSM(7))       --Ciclo Extra para lectura
        else FSM(8) when (FSMQ = FSM(21))
        else FSM(9) when (FSMQ = FSM(1) and write = '1')        --Empieza proceso escritura
        else FSM(10) when (FSMQ = FSM(9) and wordType /= "00")
        else FSM(11) when (FSMQ = FSM(10))
        else FSM(12) when (FSMQ = FSM(11) and wordType /= "01")
        else FSM(13) when (FSMQ = FSM(12))
        else FSM(14) when (FSMQ = FSM(13))
        else FSM(15) when (FSMQ = FSM(14))
        else FSM(16) when ((FSMQ = FSM(8)) or (FSMQ = FSM(4) and wordType = "01") or (FSMQ = FSM(2) and wordType = "00") 
            or (FSMQ = FSM(9) and wordType = "00") or (FSMQ = FSM(11) and wordType = "01") or (FSMQ = FSM(15)))
        else FSM(17) when (FSMQ = FSM(16))
        else FSM(0);
        
    --Logica del controlador de memoria
    muxAddr <= MUX_ADDR_LOAD when (FSMQ = FSM(1)) else
        MUX_ADDR_INC when ((FSMQ = FSM(3)) or (FSMQ = FSM(5)) or (FSMQ = FSM(7)) 
            or (FSMQ = FSM(10)) or (FSMQ = FSM(12)) or (FSMQ = FSM(14)))
        else MUX_ADDR_KEEP;
    muxDataOutMem <= MUX_DATA_OUT_MEM_B0 when (FSMQ = FSM(2))
        else MUX_DATA_OUT_MEM_B1 when (FSMQ = FSM(4))
        else MUX_DATA_OUT_MEM_B2 when (FSMQ = FSM(6))
        else MUX_DATA_OUT_MEM_B3 when (FSMQ = FSM(8))
        else MUX_DATA_OUT_MEM_KEEP;
     muxDataInMEM <= MUX_DATA_IN_MEM_B0 when (FSMQ = FSM(9))
        else MUX_DATA_IN_MEM_B1 when (FSMQ = FSM(11))
        else MUX_DATA_IN_MEM_B2 when (FSMQ = FSM(13))
        else MUX_DATA_IN_MEM_B3;
     writeInMem <= '1' when (FSMQ = FSM(9) or FSMQ = FSM(11) or FSMQ = FSM(13) or FSMQ = FSM(15))
        else '0';
     readyOut <= '1' when (FSMQ = FSM(17))
        else '0';
        
end Behavioral;
