library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity MUX5 is -- Two by one mux with 5 bit inputs/outputs
    port(
        in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
        in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
        sel    : in std_logic; -- selects in0 or in1
        output : out STD_LOGIC_VECTOR(4 downto 0)
    );
end MUX5;

architecture synth of MUX5 is 
begin
    output <= in1 when (sel = '1') else in0;
end;
