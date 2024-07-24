library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity AND4 is
    port(
        in0    : in  STD_LOGIC;
        in1    : in  STD_LOGIC;
        in2    : in  STD_LOGIC;
        in3    : in  STD_LOGIC;
        output : out STD_LOGIC -- in0 + in1 + in2 + in3
    );
end;

architecture synth of AND4 is

    component AND2 is
        port(
            in0    : in  STD_LOGIC;
            in1    : in  STD_LOGIC;
            output : out STD_LOGIC -- in0 and in1
        );
    end component;

    signal first_add : STD_LOGIC;
    signal second_add : STD_LOGIC;

begin
    first : AND2
		port map (
            in0 => in0,
            in1 => in1,
            output => first_add
	    );

    second : AND2
		port map (
            in0 => in2,
            in1 => in3,
            output => second_add
	    );

    third : AND2
		port map (
            in0 => first_add,
            in1 => second_add,
            output => output
	    );
    
end;