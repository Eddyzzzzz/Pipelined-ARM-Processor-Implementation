library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID is
    port(
        clk             : in std_logic;
        IF_ID_pc_in     : in std_logic_vector(63 downto 0);
        IF_ID_addr_in   : in std_logic_vector(31 downto 0);
        IF_ID_write     : in std_logic;
        --------------------------------------------------
        IF_ID_pc_out    : out std_logic_vector(63 downto 0);
        IF_ID_addr_out  : out std_logic_vector(31 downto 0)
    );
end IF_ID;

architecture data_flow of IF_ID is
    signal if_id_reg    : std_logic_vector(95 downto 0);
    begin
        process (all)
        begin
            if rising_edge(clk) and if_id_write = '1' then 
                IF_ID_pc_out   <= if_id_reg(95 downto 32);
                IF_ID_addr_out <= if_id_reg(31 downto 0);
            end if;
        end process;       
        if_id_reg(95 downto 32) <= IF_ID_pc_in;
        if_id_reg(31 downto 0)  <= IF_ID_addr_in;    

end data_flow;