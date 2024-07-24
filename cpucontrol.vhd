library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(
     Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc  : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional 
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

architecture dataflow of CPUControl is
     begin
          process (opcode) 
          begin
               if opcode ?= "1--0101-000" then -- R
                    Reg2Loc <= '0';
                    ALUSrc <= '0';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '0';
                    ALUOp <= "10";
                    UBranch <= '0';
               elsif opcode ?= "11111000010" then -- LDUR
                    Reg2Loc <= '-';
                    ALUSrc <= '1';
                    MemtoReg <= '1';
                    RegWrite <= '1';
                    MemRead <= '1';
                    MemWrite <= '0';
                    CBranch <= '0';
                    ALUOp <= "00";
                    UBranch <= '0';
               elsif opcode ?= "11111000000" then -- STUR
                    Reg2Loc <= '1';
                    ALUSrc <= '1';
                    MemtoReg <= '-';
                    RegWrite <= '0';
                    MemRead <= '0';
                    MemWrite <= '1';
                    CBranch <= '0';
                    ALUOp <= "00";
                    UBranch <= '0';   
               elsif opcode ?= "10110100---" then -- CBZ
                    Reg2Loc <= '1';
                    ALUSrc <= '0';
                    MemtoReg <= '-';
                    RegWrite <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '1';
                    ALUOp <= "01";
                    UBranch <= '0'; 
               elsif opcode ?= "10110101---" then -- CBNZ
                    Reg2Loc <= '1';
                    ALUSrc <= '0';
                    MemtoReg <= '-';
                    RegWrite <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '1';
                    ALUOp <= "01";
                    UBranch <= '0';
               elsif opcode ?= "000101-----" then -- B
                    Reg2Loc <= '-'; -- this is for immediates
                    ALUSrc <= '-';
                    MemtoReg <= '0';
                    RegWrite <= '0';
                    MemRead <= '-';
                    MemWrite <= '0';
                    CBranch <= '1';
                    ALUOp <= "--";
                    UBranch <= '1'; 
	          elsif opcode ?= "1--100--00-" then
		          Reg2Loc <= '0';
                    ALUSrc <= '1';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '0';
                    ALUOp <= "10";
                    UBranch <= '0'; 
               elsif opcode ?= "11010011010" then -- LSR
		          Reg2Loc <= '0';
                    ALUSrc <= '1';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '0';
                    ALUOp <= "10";
                    UBranch <= '0'; 
               elsif opcode ?= "11010011011" then -- LSL
		          Reg2Loc <= '0';
                    ALUSrc <= '1';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    MemRead <= '0';
                    MemWrite <= '0';
                    CBranch <= '0';
                    ALUOp <= "10";
                    UBranch <= '0'; 
               end if;
          end process;
 end dataflow;
