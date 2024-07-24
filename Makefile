GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

.common: 
# Basic Stuff
	@$(GHDL) -a $(VERS) mux5.vhd mux64.vhd pc.vhd shiftleft2.vhd signextend.vhd 
	@$(GHDL) -a $(VERS) add.vhd halfAdder.vhd fullAdder.vhd
	@$(GHDL) -a $(VERS) alu.vhd alucontrol.vhd cpucontrol.vhd dmem.vhd registers.vhd 
# Pipeline Registers
	@$(GHDL) -a $(VERS) MEM_WB.vhd ID_EX.vhd IF_ID.vhd EX_MEM.vhd 
# Hazard Detection and Forwarding
	@$(GHDL) -a $(VERS) ForwardingUnit.vhd HazardDetectionUnit.vhd mux3way.vhd

p1: 
	make .common
	@$(GHDL) -a $(VERS) imem_p1.vhd
	@$(GHDL) -a $(VERS) pipelinedcpu1.vhd pipecpu1_tb.vhd
	@$(GHDL) -e $(VERS) PipeCPU_testbench
	@$(GHDL) -r $(VERS) PipeCPU_testbench --wave=p1_wave.ghw

p2: 
	make .common
	@$(GHDL) -a $(VERS) imem_p2.vhd
	@$(GHDL) -a $(VERS) pipelinedcpu1.vhd pipecpu1_tb.vhd
	@$(GHDL) -e $(VERS) PipeCPU_testbench
	@$(GHDL) -r $(VERS) PipeCPU_testbench --wave=p2_wave.ghw

clean:
	rm *_sim.out *.cf *.ghw