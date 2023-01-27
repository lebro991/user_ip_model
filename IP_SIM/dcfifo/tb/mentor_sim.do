
if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "D:/soft_files/intel_FPGA21_2/quartus"
  
}
if ![info exists DUT_DIR] { 
  set DUT_DIR "E:/zhlw/IP/IP_SIM/dcfifo/"
  
}

if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

# vlib verilog_libs/altera_ver
# vmap altera_ver ./verilog_libs/altera_ver
# vlog -vlog01compat -work altera_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"

# vlib verilog_libs/lpm_ver
# vmap lpm_ver ./verilog_libs/lpm_ver
# vlog -vlog01compat -work lpm_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"

# vlib verilog_libs/sgate_ver
# vmap sgate_ver ./verilog_libs/sgate_ver
# vlog -vlog01compat -work sgate_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"

# vlib verilog_libs/altera_mf_ver
# vmap altera_mf_ver ./verilog_libs/altera_mf_ver
# vlog -vlog01compat -work altera_mf_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"

# vlib verilog_libs/altera_lnsim_ver
# vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
# vlog -sv -work altera_lnsim_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"

# vlib verilog_libs/tennm_atoms_ver
# vmap tennm_atoms_ver ./verilog_libs/tennm_atoms_ver
# vlog -vlog01compat -work tennm_atoms_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/tennm_atoms.sv"
# vlog -vlog01compat -work tennm_atoms_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/tennm_atoms_ncrypt.sv"

# vlib verilog_libs/tennm_hssi_ver
# vmap tennm_hssi_ver ./verilog_libs/tennm_hssi_ver
# vlog -vlog01compat -work tennm_hssi_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/tennm_hssi_atoms_ncrypt.sv"
# vlog -vlog01compat -work tennm_hssi_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/tennm_hssi_atoms.sv"

# vlib verilog_libs/twentynm_hip_ver
# vmap twentynm_hip_ver ./verilog_libs/twentynm_hip_ver
# vlog -vlog01compat -work twentynm_hip_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.sv"
# vlog -vlog01compat -work twentynm_hip_ver "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hip_atoms.sv "

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

#cd E:/study_pcie/EMIF4/20_1/test_fifo_modelsim/mentor                                                                                                                                                                           
# source E:/study_pcie/EMIF4/20_1/test_fifo_modelsim/mentor/msim_setup.tcl
vlog -work work "$DUT_DIR/src/u_dcfifo.sv"
vlog -work work "$DUT_DIR/tb/dcfifo_tb.sv" 

# Some packages file has changed. Refresh the work libraries (Vsim-13)
vlog -work work -refresh -force_refresh

# Elaborate top level design
 vsim -t ns -L altera_mf_ver -L lpm_ver -L altera_ver -L sgate_ver -L altera_lnsim_ver  -novopt +notimingchecks  work.dcfifo_tb 
radix hex
do wave.do
run 800000ns

