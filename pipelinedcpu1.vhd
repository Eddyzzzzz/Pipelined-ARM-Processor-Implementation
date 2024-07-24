library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity PipelinedCPU1 is
port(
clk :in std_logic;
rst :in std_logic;
--Probe ports used for testing
-- Forwarding control signals
DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
--The current address (AddressOut from the PC)
DEBUG_PC : out std_logic_vector(63 downto 0);
--Value of PC.write_enable
DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
--The current instruction (Instruction output of IMEM)
DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
--DEBUG ports from other components
DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
);
end PipelinedCPU1;

architecture structural of PipelinedCPU1 is
    -- AND2
    signal and2_in0, and2_in1     : std_logic;
    signal and2_output       : std_logic;
    -- mux5
    signal mux5_out : std_logic_vector(4 downto 0);
    -- mux64_1
    signal mux64_out : std_logic_vector(63 downto 0);
    -- mux64_2
    signal mux642_out : std_logic_vector(63 downto 0);
    -- mux64_3
    signal mux643_out : std_logic_vector(63 downto 0);
    -- sign extend
    signal se_y  : std_logic_vector(63 downto 0);
    -- shift left <<2
    signal sl2_y : std_logic_vector(63 downto 0);
    -- pc use the clk and reset of this component
    -- for PCWrite it gets it from the HDU dont overrite!
    signal AddressOut   : std_logic_vector(63 downto 0);
    -- add
    signal add1_out     : std_logic_vector(63 downto 0);
    signal add2_out     : std_logic_vector(63 downto 0);
    -- alu
    signal alu_result : std_logic_vector(63 downto 0);
    signal zero       : std_logic;
    signal overflow   : std_logic;
    signal not_zero   : std_logic;
    -- alu control
    signal aluControl_operation : std_logic_vector(3 downto 0);
    -- the mux after the CPU control
    -- muxControl comes from the HDU dont overwrite !
    signal muxControl_out : std_logic_vector(8 downto 0); -- this is the values from cpu control output or all zeroes for a stall
    -- cpu control
    signal cpuControl_reg2loc     : std_logic;
    signal cpuControl_CBranch     : std_logic;
    signal cpuControl_memRead     : std_logic;
    signal cpuControl_memtoReg    : std_logic;
    signal cpuControl_memWrite    : std_logic;
    signal cpuControl_ALUsrc      : std_logic;
    signal cpuControl_regWrite    : std_logic;
    signal cpuControl_UBranch     : std_logic;
    signal cpuControl_ALUOp       : std_logic_vector(1 downto 0);
    signal cpuControl_outputs     : std_logic_vector(8 downto 0); -- this stores all the outputs of the cpuControl this is for the new mux logic
    -- imem
    signal imem_readData : std_logic_vector(31 downto 0);
    -- dmem
    signal dmem_readData     : std_logic_vector(63 downto 0);
    signal dmem_debug_mem_contents     : std_logic_vector(64*4 - 1 downto 0);
    -- registers
    signal registers_rd1     : std_logic_vector(63 downto 0);
    signal registers_rd2     : std_logic_vector(63 downto 0);
    signal registers_debug_tmp_regs    : std_logic_vector(64 * 4 - 1 downto 0);
    signal registers_debug_saved_regs    : std_logic_vector(64 * 4 - 1 downto 0);
    --IF/ID
    -- dont need if_id_write here that comes from the hdu -- dont overwrite!
    signal IF_ID_read      : std_logic;
    --------------------------------------------------
    signal IF_ID_pc_out    : std_logic_vector(63 downto 0);
    signal IF_ID_addr_out  : std_logic_vector(31 downto 0);
    -- useful to add these signals -- these dont get port mapped just useful to think like the schematic
    signal IF_ID_registerRn: std_logic_vector(4 downto 0);
    signal IF_ID_registerRm: std_logic_vector(4 downto 0);
    signal IF_ID_registerRd: std_logic_vector(4 downto 0); 
    --ID_EX
    signal ID_EX_write         :  std_logic;
    signal ID_EX_read          :  std_logic;
    signal ID_EX_regWrite_out   :  std_logic;
    signal ID_EX_memToReg_out   :  std_logic;
    signal ID_EX_Ubranch_out    :  std_logic;
    signal ID_EX_Branch_out     :  std_logic;
    signal ID_EX_memRead_out    :  std_logic;
    signal ID_EX_memWrite_out   :  std_logic;
    signal ID_EX_ALUOp_out      :  std_logic_vector(1 downto 0);
    signal ID_EX_ALUSrc_out     :  std_logic;
    signal ID_EX_pc_out         :  std_logic_vector(63 downto 0);
    signal ID_EX_rd1_out        :  std_logic_vector(63 downto 0);
    signal ID_EX_rd2_out        :  std_logic_vector(63 downto 0);
    signal ID_EX_se_out         :  std_logic_vector(63 downto 0);
    signal ID_EX_registerRn_out :  std_logic_vector(4 downto 0);
    signal ID_EX_registerRm_out :  std_logic_vector(4 downto 0);
    signal ID_EX_opcode_out     :  std_logic_vector(10 downto 0);
    signal ID_EX_registerRd_out :  std_logic_vector(4 downto 0);
    --EX/MEM
    signal ex_mem_write         :  std_logic;
    signal ex_mem_read          :  std_logic;
    signal ex_mem_regwrite_out  :  std_logic;
    signal ex_mem_memtoreg_out  :  std_logic;     
    signal ex_mem_ubranch_out   :  std_logic;
    signal ex_mem_branch_out    :  std_logic;
    signal ex_mem_memread_out   :  std_logic;
    signal ex_mem_memwrite_out  :  std_logic;
    signal ex_mem_add2_out      :  std_logic_vector(63 downto 0);
    signal ex_mem_zero_out      :  std_logic;
    signal ex_mem_aluresult_out :  std_logic_vector(63 downto 0);
    signal ex_mem_id_ex_rd2_out :  std_logic_vector(63 downto 0);
    signal ex_mem_registerRd_out:  std_logic_vector(4 downto 0);
    --MEM/WB
    signal mem_wb_write                 :  std_logic;
    signal mem_wb_read                  :  std_logic;
    signal mem_wb_regwrite_out          :  std_logic;
    signal mem_wb_memtoreg_out          :  std_logic;
    signal mem_wb_dmem_rd_out           :  std_logic_vector(63 downto 0);
    signal mem_wb_ex_mem_alu_result_out :  std_logic_vector(63 downto 0);
    signal mem_wb_registerRd_out        :  std_logic_vector(4 downto 0);
    -- HDU
    signal PCWrite     : std_logic;
    signal IF_ID_write : std_logic;
    signal muxControl  : std_logic;
    -- forwarding Unit
    signal forwardA            : std_logic_vector(1 downto 0);
    signal forwardB            : std_logic_vector(1 downto 0);
    -- ALUMux1 -- mux2to3
    signal aluMux1_out    : STD_LOGIC_VECTOR(63 downto 0);
    -- ALUMux2 -- mux2to3
    signal aluMux2_out    : STD_LOGIC_VECTOR(63 downto 0);
    
    component AND2 is
        port (
             in0    : in  STD_LOGIC;
             in1    : in  STD_LOGIC;
             output : out STD_LOGIC -- in0 and in1
        );
   end component;

   component MUX5 is
        port(
             in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
             in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
             sel    : in STD_LOGIC; -- selects in0 or in1
             output : out STD_LOGIC_VECTOR(4 downto 0)
        );
   end component;
   
   component MUX64 is
        port(
             in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
             in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
             sel    : in STD_LOGIC; -- selects in0 or in1
             output : out STD_LOGIC_VECTOR(63 downto 0)
        );
   end component;

   component SignExtend is 
        port(
             x : in  STD_LOGIC_VECTOR(31 downto 0);
             y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
        );
   end component;

   component ShiftLeft2 is 
        port(
             x : in  STD_LOGIC_VECTOR(63 downto 0);
             y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
        );
   end component;

   component PC is 
        port(
          clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
          write_enable : in  STD_LOGIC; -- Only write if '1'
          rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
          PCWrite      : in std_logic; -- pc write enable for stalls
          AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
          AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
        );
   end component;

   component ADD is 
        port(
             in0    : in  STD_LOGIC_VECTOR(63 downto 0);
             in1    : in  STD_LOGIC_VECTOR(63 downto 0);
             output : out STD_LOGIC_VECTOR(63 downto 0)
        );
   end component;

   component ALU is 
        port(
             in0       : in     STD_LOGIC_VECTOR(63 downto 0);
             in1       : in     STD_LOGIC_VECTOR(63 downto 0);
             operation : in     STD_LOGIC_VECTOR(3 downto 0);
             result    : buffer STD_LOGIC_VECTOR(63 downto 0);
             zero      : buffer STD_LOGIC;
             overflow  : buffer STD_LOGIC;
             not_zero  : buffer STD_LOGIC
        );
   end component;

   component ALUControl is 
        port(
             ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
             Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
             Operation : out STD_LOGIC_VECTOR(3 downto 0)
        );
   end component;

   component CPUControl is
        port(
             Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
             Reg2Loc   : out STD_LOGIC;
             CBranch  : out STD_LOGIC;  --conditional
             MemRead  : out STD_LOGIC;
             MemtoReg : out STD_LOGIC;
             MemWrite : out STD_LOGIC;
             ALUSrc   : out STD_LOGIC;
             RegWrite : out STD_LOGIC;
             UBranch  : out STD_LOGIC; -- This is unconditional 
             ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
        );
   end component;

   component IMEM is 
        port(
             Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
             ReadData : out STD_LOGIC_VECTOR(31 downto 0)
        );
   end component;

   component DMEM is 
        port(
             WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
             Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
             MemRead            : in  STD_LOGIC; -- Indicates a read operation
             MemWrite           : in  STD_LOGIC; -- Indicates a write operation
             Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
             ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
             --Probe ports used for testing
             -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
             DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
        );
   end component;

   component registers is 
        port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); -- read 1
             RR2      : in  STD_LOGIC_VECTOR (4 downto 0); -- read 2
             WR       : in  STD_LOGIC_VECTOR (4 downto 0); -- write
             WD       : in  STD_LOGIC_VECTOR (63 downto 0);-- write data
             RegWrite : in  STD_LOGIC;                     -- write enable
             Clock    : in  STD_LOGIC;                     -- clock; check if write on each clock cycle
             RD1      : out STD_LOGIC_VECTOR (63 downto 0);-- read 1 data
             RD2      : out STD_LOGIC_VECTOR (63 downto 0);-- read 2 data
             --Probe ports used for testing.
             -- Notice the width of the port means that you are
             --      reading only part of the register file.
             -- This is only for debugging
             -- You are debugging a sebset of registers here
             -- Temp registers: $X9 & $X10 & X11 & X12
             -- 4 refers to number of registers you are debugging
             DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
             -- Saved Registers X19 & $X20 & X21 & X22
             DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
        );
   end component;

   component EX_MEM is
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
   end component;

   component MEM_WB is
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
   end component;

   component IF_ID is
        port(
          clk             : in std_logic;
          IF_ID_pc_in     : in std_logic_vector(63 downto 0);
          IF_ID_addr_in   : in std_logic_vector(31 downto 0);
          IF_ID_write     : in std_logic;
          --------------------------------------------------
          IF_ID_pc_out    : out std_logic_vector(63 downto 0);
          IF_ID_addr_out  : out std_logic_vector(31 downto 0)  
        );
   end component;

   component ID_EX is
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
   end component;

   component mux3way is 
    port(
        in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 00
        in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 01
        in2    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 10
        sel    : in STD_LOGIC_VECTOR(1 downto 0); -- selects in0 or in1 or in 2
        output : out STD_LOGIC_VECTOR(63 downto 0)
    );
    end component;

    component ForwardingUnit is
        port(
          EX_MEM_regWrite     : in std_logic;
          EX_MEM_RegisterRd   : in std_logic_vector(4 downto 0);
          ID_EX_RegisterRn1   : in std_logic_vector(4 downto 0);
          ID_EX_RegisterRm2   : in std_logic_vector(4 downto 0);
          MEM_WB_regWrite     : in std_logic;
          MEM_WB_RegisterRd   : in std_logic_vector(4 downto 0);
          EX_MEM_memWrite     : in std_logic;
          ------------------------------------------------------
          forwardA            : out std_logic_vector(1 downto 0);
          forwardB            : out std_logic_vector(1 downto 0)
        );
    end component;

    component HazardDetectionUnit is
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
    end component;
   
        begin
        -- stuff from lab1
        -- the mux before the register file = CHECK
        MUX5_pipe        : MUX5 port map(IF_ID_registerRm, IF_ID_registerRd, IF_ID_addr_out(28), mux5_out);
        -- mux64 (the first one from the output of dmem) = CHECK
        MUX64_1     : MUX64 port map(mem_wb_ex_mem_alu_result_out, mem_wb_dmem_rd_out, mem_wb_memtoreg_out, mux64_out);
        -- mux64_2 this is the mux before the alu
        MUX64_2     : MUX64 port map(aluMux2_out, id_ex_se_out, id_ex_alusrc_out, mux642_out);
        MUX64_3     : MUX64 port map(add1_out, ex_mem_add2_out, ex_mem_branch_out and ex_mem_zero_out, mux643_out);
        signExtend_pipe  : SignExtend port map(if_id_addr_out, se_y);
        shiftLeft   : ShiftLeft2 port map(id_ex_se_out, sl2_y);
        pc_pipe          : PC port map (clk, '1', rst, PCWrite, mux643_out, AddressOut);
        -- stuff from lab2
        add1        : ADD port map(AddressOut, x"0000000000000004", add1_out);
        add2        : ADD port map(id_ex_pc_out, sl2_y, add2_out);
        alu_pipe         : ALU port map(aluMux1_out, mux642_out, aluControl_operation, alu_result, zero, overflow, not_zero);
        aluControl_pipe  : ALUControl port map(id_ex_aluop_out, id_ex_opcode_out, aluControl_operation);
        cpuControl_pipe  : CPUControl port map(IF_ID_addr_out(31 downto 21), cpuControl_reg2loc, cpuControl_CBranch, 
                                                cpuControl_memRead, cpuControl_memtoReg, cpuControl_memWrite,
                                                cpuControl_ALUsrc, cpuControl_regWrite, cpuControl_UBranch, cpuControl_ALUOp);
        imem_pipe        : IMEM port map(addressOut, imem_readData);                         
        dmem_pipe        : DMEM port map(ex_mem_id_ex_rd2_out, ex_mem_aluresult_out, ex_mem_memread_out, ex_mem_memwrite_out,
                                               clk, dmem_readData, dmem_debug_mem_contents);       
        registers_pipe   : registers port map(if_id_registerRn, mux5_out, mem_wb_registerRd_out, mux64_out,
                                                mem_wb_regwrite_out, clk, registers_rd1, registers_rd2,
                                                registers_debug_tmp_regs, registers_debug_saved_regs);
        --IF/ID
        IF_ID_pipe       : IF_ID port map(clk, addressOut, imem_readData, if_id_write, if_id_pc_out, if_id_addr_out);
        --ID/EX
        ID_EX_pipe       : ID_EX port map(clk, muxControl_out(8), muxControl_out(7), muxControl_out(6),
                                            muxControl_out(5), muxControl_out(4), muxControl_out(3), muxControl_out(2 downto 1),
                                            muxControl_out(0), if_id_pc_out, registers_rd1, registers_rd2, se_y,
                                            if_id_addr_out(31 downto 21), if_id_registerRn, mux5_out, if_id_registerRd, 
                                            id_ex_regwrite_out, id_ex_memtoreg_out, id_ex_ubranch_out, id_ex_branch_out, id_ex_memread_out, id_ex_memwrite_out,
                                            id_ex_aluop_out, id_ex_alusrc_out, id_ex_pc_out, id_ex_rd1_out, id_ex_rd2_out,
                                            id_ex_se_out, id_ex_opcode_out, id_ex_registerRn_out, id_ex_registerRm_out, id_ex_registerRd_out);
        --EX/MEM
        EX_MEM_pipe      : EX_MEM port map(clk, id_ex_regwrite_out, id_ex_memtoreg_out, id_ex_ubranch_out,
                                                id_ex_branch_out, id_ex_memread_out, id_ex_memwrite_out, add2_out,
                                                zero, alu_result, aluMux2_out, id_ex_registerRd_out,
                                                ex_mem_regwrite_out, ex_mem_memtoreg_out, ex_mem_ubranch_out, ex_mem_branch_out,
                                                ex_mem_memread_out, ex_mem_memwrite_out, ex_mem_add2_out, ex_mem_zero_out,
                                                ex_mem_aluresult_out, ex_mem_id_ex_rd2_out, ex_mem_registerRd_out);
        -- MEM/WB        
        MEM_WB_pipe      : MEM_WB port map(clk, ex_mem_regwrite_out, ex_mem_memtoreg_out, dmem_readData,
                                                ex_mem_aluresult_out, ex_mem_registerRd_out, mem_wb_regwrite_out,
                                                mem_wb_memtoreg_out, mem_wb_dmem_rd_out, mem_wb_ex_mem_alu_result_out, 
                                                mem_wb_registerRd_out);

        HazardDetectionUnit_pipe         : HazardDetectionUnit port map (id_ex_memread_out, id_ex_registerRd_out, if_id_registerRn, if_id_registerRm, PCWrite, IF_ID_write, muxControl);

        ForwardingUnit_pipe  : ForwardingUnit port map(ex_mem_regwrite_out, ex_mem_registerRd_out, id_ex_registerRn_out, id_ex_registerRm_out,
                                                          mem_wb_regwrite_out, mem_wb_registerRd_out, ex_mem_memwrite_out, ForwardA, ForwardB);
     
        -- new : two more muxes before the alu now
        mux3way_1   : mux3way port map(id_ex_rd1_out, mux64_out, ex_mem_aluresult_out, ForwardA, aluMux1_out);
        mux3way_2   : mux3way port map(id_ex_rd2_out, mux64_out, ex_mem_aluresult_out, ForwardB, aluMux2_out);
      






        -- logic for the new mux after cpu control
        -- first concat all the cpuControl outputs that go into id/ex register
        cpuControl_outputs <= cpuControl_regWrite & cpuControl_memtoReg & cpuControl_UBranch &
                              cpuControl_CBranch & cpuControl_memRead & cpuControl_memWrite & cpuControl_ALUOp & 
                              cpuControl_ALUsrc;
     --    imem_address <= AddressOut;
        
     --    -- the mux before the register file = CHECK
     --    mux5_in0 <= IF_ID_addr_out(20 downto 16);
     --    mux5_in1 <= IF_ID_addr_out(4 downto 0);
     --    mux5_sel <= IF_ID_addr_out(28); --reg2loc

     --    -- register file = CHECK
     --    registers_rr1 <= if_id_addr_out(9 downto 5);
     --    registers_rr2 <= mux5_out;
     --    registers_wr <= mem_wb_ex_mem_40_out;
     --    registers_wd <= mux64_out;
     --    registers_regWrite <= mem_wb_regwrite_out; -- regWrite
             
     --    -- sign extend = CHECK
     --    se_x <= if_id_addr_out;

     --    -- new cpu control stuff: CHECK

     --    -- alu control = CHECK
     --    aluControl_aluOp <= id_ex_aluop_out;
     --    aluControl_opcode <= id_ex_opcode_out;

     --    -- alu (this uses mux642 or the mux before the alu) = CHECK 
     --    alu_in0 <= id_ex_rd1_out; 
     --    alu_in1 <= mux642_out;
     --    alu_op  <= aluControl_operation;

     --    -- mux642 (the one before the alu) == CHECK 
     --    mux642_in0 <= id_ex_rd2_out;
     --    mux642_in1 <= id_ex_se_out;
     --    mux642_sel <= id_ex_alusrc_out;
             
     --    -- dmem = CHECK
     --    dmem_writeData <= ex_mem_id_ex_rd2_out;
     --    dmem_address <= ex_mem_aluresult_out;
     --    dmem_memRead <= ex_mem_memread_out;
     --    dmem_memWrite <= ex_mem_memwrite_out;

     --    -- mux64 (the first one from the output of dmem) = CHECK
     --    mux64_in0 <= mem_wb_ex_mem_alu_result_out;
     --    mux64_in1 <= mem_wb_dmem_rd_out;
     --    mux64_sel <= mem_wb_memtoreg_out;

     --    -- add1 (the add for pc + 4) = CHECK
     --    add1_in0 <= AddressOut;
     --    add1_in1 <= x"0000000000000004";
        
     --    -- add2 (the add for pc + 4 if there is branching) = CHECK
     --    add2_in0 <= id_ex_pc_out;
     --    add2_in1 <= sl2_y;

     --    -- CHECK
     --    sl2_x <= id_ex_se_out;

     --    --pc + 4 stuff = CHECK
     --    pc_en <= '1';
     --    AddressIn <= mux643_out;

     --    -- mux643 (the mux that feeds back to the pc) = CHECK
     --    mux643_in0 <= add1_out;
     --    mux643_in1 <= ex_mem_add2_out;
     --    mux643_sel <= ex_mem_branch_out and ex_mem_zero_out; -- see diagram

     --    -- the IF_ID register = CHECK
     --    if_id_pc_in     <= addressOut;
     --    if_id_addr_in   <= imem_readData; 
             
     --    -- the ID_EX register = CHECK
     --    id_ex_regwrite_in   <= cpuControl_regwrite;
     --    id_ex_memtoreg_in   <= cpuControl_memtoreg;
     --    id_ex_ubranch_in    <= cpuControl_ubranch;
     --    id_ex_branch_in     <= cpuControl_cbranch;
     --    id_ex_memread_in    <= cpuControl_memread;
     --    id_ex_memwrite_in   <= cpuControl_memwrite;
     --    id_ex_aluop_in      <= cpuControl_aluop;
     --    id_ex_alusrc_in     <= cpuControl_alusrc;
     --    id_ex_pc_in         <= if_id_pc_out;
     --    id_ex_rd1_in        <= registers_rd1;
     --    id_ex_rd2_in        <= registers_rd2;
     --    id_ex_se_in         <= se_y;
     --    id_ex_opcode_in     <= if_id_addr_out(31 downto 21); -- called opcode after this
     --    id_ex_40_in         <= if_id_addr_out(4 downto 0); -- called 40 after this

     --    -- the EX/MEM register = CHECK
     --    ex_mem_regwrite_in      <= id_ex_regwrite_out;
     --    ex_mem_memtoreg_in      <= id_ex_memtoreg_out;
     --    ex_mem_ubranch_in       <= id_ex_ubranch_out;
     --    ex_mem_branch_in        <= id_ex_branch_out;
     --    ex_mem_memread_in       <= id_ex_memread_out;
     --    ex_mem_memwrite_in      <= id_ex_memwrite_out;
     --    ex_mem_add2_in          <= add2_out;
     --    ex_mem_zero_in          <= zero;
     --    ex_mem_aluresult_in     <= alu_result;
     --    ex_mem_id_ex_rd2_in     <= id_ex_rd2_out;
     --    ex_mem_id_ex_40_in      <= id_ex_40_out;

     --    -- the MEM_WB register = CHECK
     --    mem_wb_regwrite_in          <= ex_mem_regwrite_out;
     --    mem_wb_memtoreg_in          <= ex_mem_memtoreg_out;
     --    mem_wb_dmem_rd_in           <= dmem_readData;
     --    mem_wb_ex_mem_alu_result_in <= ex_mem_aluresult_out;
     --    mem_wb_ex_mem_40_in         <= ex_mem_id_ex_40_out;

     -- muxControl_out is the input to the ID/EX top bits mux before ID_EX
     muxControl_out <= cpuControl_outputs when muxControl = '1' else "000000000"; 

     -- not portmapped 
     IF_ID_registerRn  <= if_id_addr_out(9 downto 5);
     IF_ID_registerRm  <= if_id_addr_out(20 downto 16);
     IF_ID_registerRd  <= if_id_addr_out(4 downto 0);

     -- DEBUGGING--
     DEBUG_FORWARDA <= ForwardA;
     DEBUG_FORWARDB <= ForwardB;
     DEBUG_PC_WRITE_ENABLE <= PCWrite;
     DEBUG_PC <= addressOut;
     DEBUG_INSTRUCTION <= imem_readData;
     DEBUG_TMP_REGS <= registers_debug_tmp_regs;
     DEBUG_SAVED_REGS <= registers_debug_saved_regs;
     DEBUG_MEM_CONTENTS <= dmem_debug_mem_contents;
    
    
    end structural;
