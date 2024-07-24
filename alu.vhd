library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity ALU is
-- Implement: ADD, ADDI, AND, ANDI, ORR, ORRI, STUR, SUB, SUBI, LDUR, LSL, LSR, 
-- NOP (an instruction with all 0’s, does nothing)

-- as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
-- front of the textbook (or the Green Card pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC;
     not_zero  : buffer STD_LOGIC
    );
end ALU;

architecture synth of ALU is

    component ADD is
        port(
        in0    : in  STD_LOGIC_VECTOR(63 downto 0);
        in1    : in  STD_LOGIC_VECTOR(63 downto 0);
        output : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    signal sum          : std_logic_vector(63 downto 0);
    signal difference, twos_complement, twos   : std_logic_vector(63 downto 0);

    begin

        addition    : ADD port map (in0, in1, sum);
        twos_complement <= not in1;
        TWO_UNIT : ADD port map (twos_complement, X"0000000000000001", twos);
        SUB_UNIT : ADD port map (in0, twos, difference);

        with operation select
            result <= in0 and in1 when "0000",
                      in0 or  in1 when "0001",
                      difference  when "0110",
		              in1 	      when "0111", -- pass b
		              std_logic_vector(unsigned(in0) srl to_integer(unsigned(in1))) when "1000", -- shift right
                      std_logic_vector(unsigned(in0) sll to_integer(unsigned(in1)))  when "1001", -- shift left
                      sum      when others;

        zero <= '1' when (result = X"0000000000000000" or operation = "0111") else '0';
        
        -- overflow <= (in0(63) and in1(63) and not addd(63)) or (not in0(63) and not in1(63) and addd(63)) when operation = "0010" else
        --             (in0(63) and not twos(63) and not subb(63)) or (not in0(63) and twos(63) and subb(63)) when operation = "0110" else
        --             '0';
        overflow <= '1' when ( operation = "0010" and ( (in0(63) = '1' and 
                              in1(63) = '1' and sum(63) = '0') or (in0(63) = '0' and 
                              in1(63) = '0' and sum(63) = '1') ) )
                        else
                    '1' when ( operation = "0110" and ( (in0(63) = '0' and 
                              in1(63) = '1' and sum(63) = '0') or (in0(63) = '1' and 
                              in1(63) = '0' and sum(63) = '0') ) )
                        else
                    '0';
    end;