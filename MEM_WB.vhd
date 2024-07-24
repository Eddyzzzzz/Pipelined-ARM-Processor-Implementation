library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_WB is
    port(
        clk                         : in std_logic;
        mem_wb_regwrite_in          : in std_logic;
        mem_wb_memtoreg_in          : in std_logic;
        mem_wb_dmem_rd_in           : in std_logic_vector(63 downto 0);
        mem_wb_ex_mem_alu_result_in : in std_logic_vector(63 downto 0);
        mem_wb_registerRd_in        : in std_logic_vector(4 downto 0);
        -----------------------------------------------------------
        mem_wb_regwrite_out          : out std_logic;
        mem_wb_memtoreg_out          : out std_logic;
        mem_wb_dmem_rd_out           : out std_logic_vector(63 downto 0);
        mem_wb_ex_mem_alu_result_out : out std_logic_vector(63 downto 0);
        mem_wb_registerRd_out        : out std_logic_vector(4 downto 0)
    );
end MEM_WB;

architecture data_flow of MEM_WB is

    signal mem_wb_reg   : std_logic_vector(134 downto 0);
    begin

        process(all) begin
            if rising_edge(clk) then 
                mem_wb_regwrite_out          <= mem_wb_reg(134); -- W control lines
                mem_wb_memtoreg_out          <= mem_wb_reg(133);
                mem_wb_dmem_rd_out           <= mem_wb_reg(132 downto 69);
                mem_wb_ex_mem_alu_result_out <= mem_wb_reg(68 downto 5);
                mem_wb_registerRd_out        <= mem_wb_reg(4 downto 0);
            end if;
        end process;
        mem_wb_reg(134 downto 133) <= mem_wb_regwrite_in & mem_wb_memtoreg_in;
        mem_wb_reg(132 downto 69)  <= mem_wb_dmem_rd_in;
        mem_wb_reg(68 downto 5)    <= mem_wb_ex_mem_alu_result_in;
        mem_wb_reg(4 downto 0)     <= mem_wb_registerRd_in;

end data_flow;