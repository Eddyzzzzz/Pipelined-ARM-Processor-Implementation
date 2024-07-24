library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end ADD;

architecture structural of ADD is

     signal car : std_logic_vector(63 downto 0);
     signal sum : std_logic_vector(63 downto 0);

     component FADD is
          port(
               in0    : in  std_logic;
               in1    : in  std_logic;
               cin    : in  std_logic;
               sum    : out std_logic;
               cout   : out std_logic
          );
     end component;

     begin

          FA0 : FADD port map(in0(0), in1(0), '0', sum(0), car(0));
          FA1 : FADD port map(in0(1), in1(1), car(0), sum(1), car(1));
          FA2 : FADD port map(in0(2), in1(2), car(1), sum(2), car(2));
          FA3 : FADD port map(in0(3), in1(3), car(2), sum(3), car(3));
          FA4 : FADD port map(in0(4), in1(4), car(3), sum(4), car(4));
          FA5 : FADD port map(in0(5), in1(5), car(4), sum(5), car(5));
          FA6 : FADD port map(in0(6), in1(6), car(5), sum(6), car(6));
          FA7 : FADD port map(in0(7), in1(7), car(6), sum(7), car(7));
          FA8 : FADD port map(in0(8), in1(8), car(7), sum(8), car(8));
          FA9 : FADD port map(in0(9), in1(9), car(8), sum(9), car(9));
          FA10 : FADD port map(in0(10), in1(10), car(9), sum(10), car(10));
          FA11 : FADD port map(in0(11), in1(11), car(10), sum(11), car(11));
          FA12 : FADD port map(in0(12), in1(12), car(11), sum(12), car(12));
          FA13 : FADD port map(in0(13), in1(13), car(12), sum(13), car(13));
          FA14 : FADD port map(in0(14), in1(14), car(13), sum(14), car(14));
          FA15 : FADD port map(in0(15), in1(15), car(14), sum(15), car(15));
          FA16 : FADD port map(in0(16), in1(16), car(15), sum(16), car(16));
          FA17 : FADD port map(in0(17), in1(17), car(16), sum(17), car(17));
          FA18 : FADD port map(in0(18), in1(18), car(17), sum(18), car(18));
          FA19 : FADD port map(in0(19), in1(19), car(18), sum(19), car(19));
          FA20 : FADD port map(in0(20), in1(20), car(19), sum(20), car(20));
          FA21 : FADD port map(in0(21), in1(21), car(20), sum(21), car(21));
          FA22 : FADD port map(in0(22), in1(22), car(21), sum(22), car(22));
          FA23 : FADD port map(in0(23), in1(23), car(22), sum(23), car(23));
          FA24 : FADD port map(in0(24), in1(24), car(23), sum(24), car(24));
          FA25 : FADD port map(in0(25), in1(25), car(24), sum(25), car(25));
          FA26 : FADD port map(in0(26), in1(26), car(25), sum(26), car(26));
          FA27 : FADD port map(in0(27), in1(27), car(26), sum(27), car(27));
          FA28 : FADD port map(in0(28), in1(28), car(27), sum(28), car(28));
          FA29 : FADD port map(in0(29), in1(29), car(28), sum(29), car(29));
          FA30 : FADD port map(in0(30), in1(30), car(29), sum(30), car(30));
          FA31 : FADD port map(in0(31), in1(31), car(30), sum(31), car(31));
          FA32 : FADD port map(in0(32), in1(32), car(31), sum(32), car(32));
          FA33 : FADD port map(in0(33), in1(33), car(32), sum(33), car(33));
          FA34 : FADD port map(in0(34), in1(34), car(33), sum(34), car(34));
          FA35 : FADD port map(in0(35), in1(35), car(34), sum(35), car(35));
          FA36 : FADD port map(in0(36), in1(36), car(35), sum(36), car(36));
          FA37 : FADD port map(in0(37), in1(37), car(36), sum(37), car(37));
          FA38 : FADD port map(in0(38), in1(38), car(37), sum(38), car(38));
          FA39 : FADD port map(in0(39), in1(39), car(38), sum(39), car(39));
          FA40 : FADD port map(in0(40), in1(40), car(39), sum(40), car(40));
          FA41 : FADD port map(in0(41), in1(41), car(40), sum(41), car(41));
          FA42 : FADD port map(in0(42), in1(42), car(41), sum(42), car(42));
          FA43 : FADD port map(in0(43), in1(43), car(42), sum(43), car(43));
          FA44 : FADD port map(in0(44), in1(44), car(43), sum(44), car(44));
          FA45 : FADD port map(in0(45), in1(45), car(44), sum(45), car(45));
          FA46 : FADD port map(in0(46), in1(46), car(45), sum(46), car(46));
          FA47 : FADD port map(in0(47), in1(47), car(46), sum(47), car(47));
          FA48 : FADD port map(in0(48), in1(48), car(47), sum(48), car(48));
          FA49 : FADD port map(in0(49), in1(49), car(48), sum(49), car(49));
          FA50 : FADD port map(in0(50), in1(50), car(49), sum(50), car(50));
          FA51 : FADD port map(in0(51), in1(51), car(50), sum(51), car(51));
          FA52 : FADD port map(in0(52), in1(52), car(51), sum(52), car(52));
          FA53 : FADD port map(in0(53), in1(53), car(52), sum(53), car(53));
          FA54 : FADD port map(in0(54), in1(54), car(53), sum(54), car(54));
          FA55 : FADD port map(in0(55), in1(55), car(54), sum(55), car(55));
          FA56 : FADD port map(in0(56), in1(56), car(55), sum(56), car(56));
          FA57 : FADD port map(in0(57), in1(57), car(56), sum(57), car(57));
          FA58 : FADD port map(in0(58), in1(58), car(57), sum(58), car(58));
          FA59 : FADD port map(in0(59), in1(59), car(58), sum(59), car(59));
          FA60 : FADD port map(in0(60), in1(60), car(59), sum(60), car(60));
          FA61 : FADD port map(in0(61), in1(61), car(60), sum(61), car(61));
          FA62 : FADD port map(in0(62), in1(62), car(61), sum(62), car(62));
          FA63 : FADD port map(in0(63), in1(63), car(62), sum(63), car(63));

          output <= sum;
     end structural;