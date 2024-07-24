library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM is
    port(
        clk                 : in std_logic;
        ex_mem_regwrite_in  : in std_logic;
        ex_mem_memtoreg_in  : in std_logic;     
        ex_mem_ubranch_in   : in std_logic;
        ex_mem_branch_in    : in std_logic;
        ex_mem_memread_in   : in std_logic;
        ex_mem_memwrite_in  : in std_logic;
        ex_mem_add2_in      : in std_logic_vector(63 downto 0);
        ex_mem_zero_in      : in std_logic;
        ex_mem_aluresult_in : in std_logic_vector(63 downto 0);
        ex_mem_id_ex_rd2_in : in std_logic_vector(63 downto 0);
        ex_mem_registerRd_in: in std_logic_vector(4 downto 0);
        ----------------------------------------------------
        ex_mem_regwrite_out  : out std_logic;
        ex_mem_memtoreg_out  : out std_logic;     
        ex_mem_ubranch_out   : out std_logic;
        ex_mem_branch_out    : out std_logic;
        ex_mem_memread_out   : out std_logic;
        ex_mem_memwrite_out  : out std_logic;
        ex_mem_add2_out      : out std_logic_vector(63 downto 0);
        ex_mem_zero_out      : out std_logic;
        ex_mem_aluresult_out : out std_logic_vector(63 downto 0);
        ex_mem_id_ex_rd2_out : out std_logic_vector(63 downto 0);
        ex_mem_registerRd_out: out std_logic_vector(4 downto 0)
    );
end EX_MEM;

architecture data_flow of EX_MEM is
    signal ex_mem_reg   : std_logic_vector(203 downto 0);
    begin
        process (all) begin
            if rising_edge(clk) then 
                ex_mem_regwrite_out  <= ex_mem_reg(203); 
                ex_mem_memtoreg_out  <= ex_mem_reg(202); 
                ex_mem_ubranch_out   <= ex_mem_reg(201);
                ex_mem_branch_out    <= ex_mem_reg(200);
                ex_mem_memread_out   <= ex_mem_reg(199);
                ex_mem_memwrite_out  <= ex_mem_reg(198);
                ex_mem_add2_out      <= ex_mem_reg(197 downto 134);
                ex_mem_zero_out      <= ex_mem_reg(133); 
                ex_mem_aluresult_out <= ex_mem_reg(132 downto 69);
                ex_mem_id_ex_rd2_out <= ex_mem_reg(68 downto 5);
                ex_mem_registerRd_out  <= ex_mem_reg(4 downto 0);
            end if;
        end process;
        ex_mem_reg(203 downto 202)      <= ex_mem_regwrite_in & ex_mem_memtoreg_in;
        ex_mem_reg(201 downto 198)      <= ex_mem_ubranch_in & ex_mem_branch_in &
                                           ex_mem_memread_in & ex_mem_memwrite_in;
        ex_mem_reg(197 downto 134)      <= ex_mem_add2_in;
        ex_mem_reg(133)                 <= ex_mem_zero_in;
        ex_mem_reg(132 downto 69)       <= ex_mem_aluresult_in;
        ex_mem_reg(68 downto 5)         <= ex_mem_id_ex_rd2_in;
        ex_mem_reg(4 downto 0)          <= ex_mem_registerRd_in;
        

end data_flow;