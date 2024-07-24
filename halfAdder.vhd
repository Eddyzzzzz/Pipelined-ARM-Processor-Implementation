library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity HADD is
-- Inputs (A, B) | Sum (S) | Carry (C)
-- -----------------------------------
--     0    0     |    0    |    0
--     0    1     |    1    |    0
--     1    0     |    1    |    0
--     1    1     |    0    |    1
    port(
        in0    : in  std_logic;
        in1    : in  std_logic;
        sum    : out std_logic;
        carry  : out std_logic
    );
end HADD;

architecture synth of HADD is
     begin
        sum   <= in0 xor in1;
        carry <= in0 and in1;
     end;