library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HazardDetectionUnit is
    port(
        ID_EX_memRead        : in std_logic;
        ID_EX_registerRd     : in std_logic_vector(4 downto 0); -- this is ID_EX_40_out  
        IF_ID_registerRn1    : in std_logic_vector(4 downto 0);
        IF_ID_registerRm2    : in std_logic_vector(4 downto 0);
        -------------------------------------------------------
        PCWrite     : out std_logic;
        IF_ID_write : out std_logic;
        muxControl  : out std_logic
    );
end HazardDetectionUnit;

architecture behavioral of HazardDetectionUnit is

begin
    process (all) 
    begin
        if ( ID_EX_memRead = '1' and ( (ID_EX_registerRd = IF_ID_registerRn1) or 
           (ID_EX_registerRd = IF_ID_registerRm2) ) ) then
            -- stall the pipeline
            -- first dont write to the pc counter
            PCWrite <= '0';
            -- dont write to the IF_ID_reg as well because it gets its input from the pc output
            IF_ID_write  <= '0';
            -- also the mux control would be i.e dont read in from the CPUControl which uses the pc address to create an opcode for some instruction => NOP
            -- see the book for more 
            muxControl <= '0';
        else
            PCWrite <= '1';
            IF_ID_Write <= '1';
            muxControl <= '1';
        end if;
    end process;
end behavioral;