library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX is
    port(
        clk                 : in std_logic;
        ID_EX_regWrite_in   : in std_logic;
        ID_EX_memToReg_in   : in std_logic;
        ID_EX_Ubranch_in    : in std_logic;
        ID_EX_Branch_in     : in std_logic;
        ID_EX_memRead_in    : in std_logic;
        ID_EX_memWrite_in   : in std_logic;
        ID_EX_ALUOp_in      : in std_logic_vector(1 downto 0);
        ID_EX_ALUSrc_in     : in std_logic;
        ID_EX_pc_in         : in std_logic_vector(63 downto 0);
        ID_EX_rd1_in        : in std_logic_vector(63 downto 0);
        ID_EX_rd2_in        : in std_logic_vector(63 downto 0);
        ID_EX_se_in         : in std_logic_vector(63 downto 0);
        ID_EX_opcode_in     : in std_logic_vector(10 downto 0);
        ID_EX_registerRn_in : in std_logic_vector(4 downto 0);
        ID_EX_registerRm_in : in std_logic_vector(4 downto 0);
        ID_EX_registerRd_in : in std_logic_vector(4 downto 0);
        --------------------------------
        ID_EX_regWrite_out   : out std_logic;
        ID_EX_memToReg_out   : out std_logic;
        ID_EX_Ubranch_out    : out std_logic;
        ID_EX_Branch_out     : out std_logic;
        ID_EX_memRead_out    : out std_logic;
        ID_EX_memWrite_out   : out std_logic;
        ID_EX_ALUOp_out      : out std_logic_vector(1 downto 0);
        ID_EX_ALUSrc_out     : out std_logic;
        ID_EX_pc_out         : out std_logic_vector(63 downto 0);
        ID_EX_rd1_out        : out std_logic_vector(63 downto 0);
        ID_EX_rd2_out        : out std_logic_vector(63 downto 0);
        ID_EX_se_out         : out std_logic_vector(63 downto 0);
        ID_EX_opcode_out     : out std_logic_vector(10 downto 0);
        ID_EX_registerRn_out : out std_logic_vector(4 downto 0);
        ID_EX_registerRm_out : out std_logic_vector(4 downto 0);
        ID_EX_registerRd_out : out std_logic_vector(4 downto 0)
    );
end ID_EX;

architecture data_flow of ID_EX is

    signal id_ex_reg    : std_logic_vector(290 downto 0);
    begin

        process (all) begin
            if rising_edge(clk) then 
                ID_EX_regWrite_out        <= id_ex_reg(290);
                ID_EX_memtoreg_out        <= id_ex_reg(289);
                ID_EX_ubranch_out         <= id_ex_reg(289);
                ID_EX_branch_out          <= id_ex_reg(287);
                ID_EX_memread_out         <= id_ex_reg(286);
                ID_EX_memwrite_out        <= id_ex_reg(285);
                ID_EX_aluop_out           <= id_ex_reg(284 downto 283); -- => ALUOp1, ALUOp2
                ID_EX_alusrc_out          <= id_ex_reg(282); -- => ALusrc
                ID_EX_pc_out              <= id_ex_reg(281 downto 218);
                ID_EX_rd1_out             <= id_ex_reg(217 downto 154);
                ID_EX_rd2_out             <= id_ex_reg(153 downto 90);
                ID_EX_se_out              <= id_ex_reg(89 downto 26);
                ID_EX_opcode_out          <= id_ex_reg(25 downto 15);
                ID_EX_registerRn_out      <= id_ex_reg(14 downto 10);
                ID_EX_registerRm_out      <= id_ex_reg(9 downto 5);
                ID_EX_registerRd_out      <= id_ex_reg(4 downto 0);
            end if;
        end process;
        id_ex_reg(290 downto 289) <= id_ex_regWrite_in & id_ex_memtoreg_in;
        id_ex_reg(288 downto 285) <= id_ex_ubranch_in & id_ex_branch_in & 
                                     id_ex_memread_in & id_ex_memwrite_in;
        id_ex_reg(284 downto 282) <= id_ex_aluop_in & id_ex_alusrc_in;
        id_ex_reg(281 downto 218) <= id_ex_pc_in;
        id_ex_reg(217 downto 154) <= id_ex_rd1_in;
        id_ex_reg(153 downto 90)  <= id_ex_rd2_in;
        id_ex_reg(89 downto 26)   <= id_ex_se_in;
        id_ex_reg(25 downto 15)   <= id_ex_opcode_in;
        id_ex_reg(14 downto 10)    <= id_ex_registerRn_in;
        id_ex_reg(9 downto 5)     <= id_ex_registerRm_in;
        id_ex_reg(4 downto 0)     <= id_ex_registerRd_in;            

end data_flow;