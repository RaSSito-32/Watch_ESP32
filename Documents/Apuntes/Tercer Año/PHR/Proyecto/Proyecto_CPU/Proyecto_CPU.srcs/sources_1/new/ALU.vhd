----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 11:34:16
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (
        A: IN std_logic_vector(31 downto 0);
        B: IN std_logic_vector(31 downto 0);
        SEL: IN std_logic_vector(4 downto 0);
        RES: OUT std_logic_vector(31 downto 0)
        --CARRY: 
        );
    
end ALU;

architecture Funciones_ALU of ALU is
 component suma
    port(
        A, B: IN std_logic_vector(31 downto 0);
        SUMA: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component sumaImm
    port(
        A: IN std_logic_vector(31 downto 0);
        IMM: IN integer range 0 to 31;
        SUMA: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component resta
    port(
        A, B: IN std_logic_vector(31 downto 0);
        RESTA: OUT std_logic_vector(31 downto 0)
        );
 end component;
 --component restaImm
 --   port(
 --       A: IN std_logic_vector(31 downto 0);
 --       IMM: IN integer range 0 to 31;
 --       RESTA: OUT std_logic_vector(31 downto 0)
 --       );
 --end component;
 component compuertaAND
    port(
        A, B: IN std_logic_vector(31 downto 0);
        S_AND: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component compuertaANDImm
    port(
        A: in std_logic_vector(31 downto 0);
        IMM: in std_logic_vector(4 downto 0);
        S_AND_IMM: out std_logic_vector(31 downto 0)
    );
 end component;
 component compuertaOR
    port(
        A, B: IN std_logic_vector(31 downto 0);
        S_OR: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component compuertaORImm
    port(
        A: in std_logic_vector(31 downto 0);
        IMM: in std_logic_vector(4 downto 0);
        S_OR_IMM: out std_logic_vector(31 downto 0)
    );
 end component;
 component compuertaXOR
    port(
        A, B: IN std_logic_vector(31 downto 0);
        S_XOR: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component compuertaXORImm
    port(
        A: in std_logic_vector(31 downto 0);
        IMM: in std_logic_vector(4 downto 0);
        S_XOR_IMM: out std_logic_vector(31 downto 0)
    );
 end component;
 component shiftLeft
    port(
        A: IN std_logic_vector(31 downto 0);
        SHIFT: IN integer range 0 to 31;
        S_LEFT: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component shiftRight
    port(
        A: IN std_logic_vector(31 downto 0);
        SHIFT: IN integer range 0 to 31;
        S_RIGHT: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component shiftRightArithmetic
    port(
        A: IN std_logic_vector(31 downto 0);
        IMM: IN integer range 0 to 31;
        S_RIGHT_ARITH: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component shiftLeftImm
    port(
        A: IN std_logic_vector(31 downto 0);
        IMM: IN integer range 0 to 31;
        S_LEFT_IMM: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component shiftRightImm
    port(
        A: IN std_logic_vector(31 downto 0);
        IMM: IN integer range 0 to 31;
        S_RIGHT_IMM: OUT std_logic_vector(31 downto 0)
        );
 end component;
 component shiftRightArithmeticImm
    port(
        A: IN std_logic_vector(31 downto 0);
        SHIFT: IN integer range 0 to 31;
        S_RIGHT_ARITH_IMM: OUT std_logic_vector(31 downto 0)
        );
 end component;

 
 signal TEMPresult: std_logic_vector(31 downto 0);
 signal InA, InB: std_logic_vector(31 downto 0);
 signal selector: std_logic_vector(3 downto 0);
 signal ALUresult: std_logic_vector(31 downto 0);
 
begin
    --FUN_SUMA : suma port map (A => A, B => B, SUMA => TempResult);
    --FUN_SUMAImm: sumaImm port map (A => A, IMM => to_integer(unsigned(B)), SUMA => TempResult);
    --FUN_RESTA : resta port map (A => A, B => B, RESTA => TempResult);
    --FUN_RESTAImm : restaImm port map (A => A, IMM => to_integer(unsigned(B)), RESTA => TempResult);
    --FUN_AND : compuertaAND port map (A => A, B => B, S_AND => TempResult);
    --FUN_AND_Imm : compuertaANDImm port map (A => A, IMM => SEL, S_AND_IMM => TEMPresult);
    --FUN_OR : compuertaOR port map (A => A, B => B, S_OR => TempResult);
    --FUN_OR_Imm : compuertaORImm port map (A => A, IMM => SEL, S_OR_IMM => TEMPresult);
    --FUN_XOR : compuertaXOR port map (A => A, B => B, S_XOR => TempResult);
    --FUN_XOR_Imm : compuertaXORImm port map (A => A, IMM => SEL, S_XOR_IMM => TEMPresult);
    --FUN_ShiftLeft : shiftLeft port map (A => A, SHIFT => to_integer(unsigned(B)), S_LEFT => TempResult);
    --FUN_shiftRight : shiftRight port map (A => A, SHIFT => to_integer(unsigned(B)), S_RIGHT => TempResult);
    --FUN_shiftRightArithmetic : shiftRightArithmetic port map (A => A, IMM => to_integer(unsigned(B)), S_RIGHT_ARITH => TempResult);
    --FUN_shiftLeftImm : shiftLeftImm port map (A => A, IMM => to_integer(unsigned(B)), S_LEFT_IMM => TempResult);
    --FUN_shiftRightImm : shiftRightImm port map (A => A, IMM => to_integer(unsigned(B)), S_RIGHT_IMM => TempResult);
    --FUN_shiftRightArithmeticImm : shiftRightArithmeticImm port map (A => A, SHIFT => to_integer(unsigned(B)), S_RIGHT_ARITH_IMM => TempResult);
  
        
    ALUresult <= TEMPresult;
    process(A,B, SEL)
    begin
    case SEL is
        when "00000" =>
                RES <= std_logic_vector(signed(A) + signed(B)); -- Suma
        when "00001" =>
                RES <= std_logic_vector(signed(A) - signed(B)); -- Resta
        when "00010" =>
                RES <= A and B; -- AND
        when "00011" =>
                RES <= A or B; -- OR
        when "00100" =>
                RES <= A xor B; -- XOR
        when "00101" =>
                RES <= (A(30 downto 0) & '0'); --ShiftLeft
        when "00110" =>
                RES <= ('0' & A(31 downto 1)); --ShiftRight
        when "00111" =>
                RES <= (A(31) & A(31 downto 1)); --ShiftRightArith
        when "01000" =>
                if signed (A) < signed(B) then 
                    RES <= std_logic_vector(to_signed(1,32));
                else RES <= std_logic_vector(to_signed(0,32));  --SLT
                end if;
        when "01001" =>               
                if unsigned (A) < unsigned(B) then 
                    RES <= std_logic_vector(to_signed(1,32));  --SLTU
                else 
                    RES <= std_logic_vector(to_signed(0,32));
                end if;
        when "01010" =>
                if A = B then 
                    RES <= std_logic_vector(to_signed(1,32));  --BEQ
                else 
                    RES <= std_logic_vector(to_signed(0,32));
                end if;
        when "01011" =>
                if signed (A) >= signed(B) then 
                    RES <= std_logic_vector(to_signed(1,32));  --BGE
                else 
                    RES <= std_logic_vector(to_signed(0,32));
                end if;
        when "01100" =>
                if unsigned (A) >= unsigned(B) then 
                    RES <= std_logic_vector(to_signed(1,32));  --BGEU
                else 
                    RES <= std_logic_vector(to_signed(0,32));
                end if;
        when "01101" =>
                if A /= B then  
                    RES <= std_logic_vector(to_signed(1,32));  --BNE
                else 
                    RES <= std_logic_vector(to_signed(0,32));
                end if;
        when others =>
                RES <= A;  --default
     end case;
     end process;
end Funciones_ALU;
