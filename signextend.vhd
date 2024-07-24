library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture dataflow of SignExtend is

begin
    -- extend the 32 bit input x to 64 bits 
    -- eg) 10 bit "11 1111 0001" --> extend to 16 bits , padding the left side
    -- with 1s, 1's because the leftmost bit is the signbit we want to extend
    -- that bit
    -- logic: store x(31) in a temporaray register then copy that value
    -- 32 times to the beginning of y
    -- use concatenation
	

	-- B   B type 000101    

	-- AND R type 10001010000
	-- ADD R type 10001011000
	--ORR R type  10101010000
	-- SUB R type 11001011000
	--LSR R type  11001011000
	--LSL R type  11010011011
	-- =>         1----01-0--

	--ADDI I type 1001000100
	--ANDI I type 1001001000
	--ORRI I type 1011001000
	--SUBI I type 1101000100
	-- => 	      1--100--00
	
	--CBZ CB type 10110100
	--CBNZ CBtype 10110101
	-- =>         1011010-

	-- STUR D type 11111000000
	-- LDUR D type 11111000010
	-- =>          111110000-0


    	-- y <= x"ffffffff" & x when x(31) else x"00000000" & x;
	-- R type
	process (x) 
		variable Btype  : std_logic_vector(5 downto 0);
		variable Rtype  : std_logic_vector(10 downto 0);
		variable Itype  : std_logic_vector(9 downto 0);
		variable CBType : std_logic_vector(7 downto 0);
		variable DType 	: std_logic_vector(10 downto 0);
	begin
		Btype  := "000101";
		Rtype  := "1----01-0--";
		Itype  := "1--100--00";
		CBtype := "1011010-";
		Dtype  := "111110000-0";
		
		if x(31 downto 26) ?= Btype then
			y <= (63 downto 26 => x(25)) & x(25 downto 0);
		elsif x(31 downto 21) ?= Rtype then
			y <= (63 downto 6 => x(15)) & x(15 downto 10);
		elsif x(31 downto 22) ?= Itype then
			y <= (63 downto 12 => x(21)) & x(21 downto 10);
		elsif x(31 downto 24) ?= CBtype then
			y <= (63 downto 19 => x(23)) & x(23 downto 5);
		elsif x(31 downto 21) ?= Dtype then
			y <= (63 downto 9 => x(20)) & x(20 downto 12);
		end if;

	end process;

	

end dataflow;
