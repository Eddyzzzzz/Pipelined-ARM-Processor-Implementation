library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3way is 
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 00
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 01
    in2    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 10
    sel    : in STD_LOGIC_VECTOR(1 downto 0); -- selects in0 or in1 or in 2
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end mux3way;

architecture dataflow of mux3way is

begin
    with sel select 
        output <= in0 when "00",
                  in1 when "01",
                  in2 when "10",
                  x"----------------"      when others;
end dataflow;
