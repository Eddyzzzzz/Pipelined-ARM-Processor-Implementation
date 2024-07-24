library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity FADD is
    -- |  A  |  B  | Cin |  Sum  | Cout |
    -- | --- | --- | --- | ---- | ---- |
    -- |  0  |  0  |  0  |   0   |  0   |
    -- |  0  |  0  |  1  |   1   |  0   |
    -- |  0  |  1  |  0  |   1   |  0   |
    -- |  0  |  1  |  1  |   0   |  1   |
    -- |  1  |  0  |  0  |   1   |  0   |
    -- |  1  |  0  |  1  |   0   |  1   |
    -- |  1  |  1  |  0  |   0   |  1   |
    -- |  1  |  1  |  1  |   1   |  1   |
    port(
        in0    : in  std_logic;
        in1    : in  std_logic;
        cin    : in  std_logic;
        sum    : out std_logic;
        cout   : out std_logic
    );
end FADD;

architecture synth of FADD is
    component HADD is
        port(
            in0    : in  std_logic;
            in1    : in  std_logic;
            sum    : out std_logic;
            carry  : out std_logic
        );
    end component;

    signal s1, c1, c2 : std_logic;

    begin
        HA1 : HADD
		port map (
            in0   => in0,
            in1   => in1,
            sum   => s1,
            carry => c1
	    );

        HA2 : HADD
		port map (
            in0   => s1,
            in1   => cin,
            sum   => sum,
            carry => c2
	    );

        cout <= c1 or c2;
    end;