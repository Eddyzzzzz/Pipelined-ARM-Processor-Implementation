library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of ISA.pdf on canvas. Pay attention to opcode of operations and type of operations. 
-- If an operation doesn't use ALU, you don't need to check for its case in the ALU control implemenetation.	
--  To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
    ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
    Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
    Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALUControl;

architecture dataflow of ALUControl is

    signal concat : std_logic_vector(12 downto 0);
	signal concat2 : std_logic_vector(11 downto 0);	         

    begin
    
        concat <=  ALUOp & Opcode;
		concat2 <= ALUOp & Opcode(10 downto 1);

		Operation <= "0010" when concat = "00-----------" else
        "0111" when concat = "0110110100---" else --cbz
        "0111" when concat = "0110110101000" else --cbnz
        "0010" when (concat = "1010001011000" or concat2 = "101001000100") else -- for immediates
        "0110" when (ALUOp = "10" and (Opcode =  "11001011000" or Opcode(10 downto 1) = "1101000100")) else 
        "0000" when (concat = "1010001010000" or concat2 = "101001001000") else
        "0001" when (ALUOp = "10" and (Opcode =  "10101010000" or Opcode(10 downto 1) = "1011001000")) else
        "1000" when concat = "1011010011010" else -- lsr 
        "1001" when concat = "1011010011011" else -- lsl
        "----";

    end dataflow;