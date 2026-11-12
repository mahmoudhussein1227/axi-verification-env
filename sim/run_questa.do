#=============================================================================
# run_questa.do - Run the AXI UVM test with coverage
#=============================================================================
# Usage:  do sim/run_questa.do (from the project root)
#=============================================================================

# ---------- Quit any previous simulation ----------
quit -sim

# ---------- Directory Variables ----------
set PROJECT_DIR [file normalize [pwd]]
if {![file isdirectory [file join $PROJECT_DIR RTL]] &&
    [file isdirectory [file join $PROJECT_DIR .. RTL]]} {
    set PROJECT_DIR [file normalize [file join $PROJECT_DIR ..]]
}
if {![file isdirectory [file join $PROJECT_DIR RTL]] ||
    ![file isdirectory [file join $PROJECT_DIR testbench]]} {
    error "Run this script from the project root or sim directory"
}
set RTL_DIR [file join $PROJECT_DIR RTL]
set TB_DIR  [file join $PROJECT_DIR testbench]
set SIM_DIR [file join $PROJECT_DIR sim]
cd $PROJECT_DIR

# ---------- Testbench and DUT configuration ----------
if {![info exists ADDR_WIDTH]} {
    set ADDR_WIDTH 32
}
if {![info exists DATA_WIDTH]} {
    set DATA_WIDTH 32
}
if {![info exists ID_WIDTH]} {
    set ID_WIDTH 4
}
if {![info exists MEM_DEPTH]} {
    set MEM_DEPTH 1024
}

# ---------- Clean previous work library ----------
if {[file exists work]} {
    vdel -lib work -all
}

# ---------- Create work library ----------
vlib work
vmap work work

# ---------- Resolve Questa and UVM paths ----------
if {[info exists ::env(UVM_HOME)]} {
    set UVM_HOME $::env(UVM_HOME)
} else {
    set UVM_HOME "C:/questasim64_2021.1/verilog_src/uvm-1.2"
    puts "INFO: UVM_HOME not set, using default: $UVM_HOME"
}

if {[info exists ::env(QUESTA_HOME)]} {
    set QUESTA_HOME $::env(QUESTA_HOME)
} else {
    set QUESTA_HOME "C:/questasim64_2021.1"
}

# ---------- Map pre-compiled UVM library ----------
vmap mtiUvm [file join $QUESTA_HOME uvm-1.2]

# ---------- Compile RTL and interfaces ----------
vlog -work work -sv +cover \
    "+define+MH_AXI_ADDR_WIDTH=$ADDR_WIDTH" \
    "+define+MH_AXI_ID_WIDTH=$ID_WIDTH" \
    "+define+MH_AXI_MEM_DEPTH=$MEM_DEPTH" \
    "+define+MH_AXI_DATA_WIDTH=$DATA_WIDTH" \
    [file join $RTL_DIR axi_mem_slave.sv] \
    [file join $TB_DIR mh_axi_aw_intf.sv] \
    [file join $TB_DIR mh_axi_w_intf.sv] \
    [file join $TB_DIR mh_axi_b_intf.sv] \
    [file join $TB_DIR mh_axi_ar_intf.sv] \
    [file join $TB_DIR mh_axi_r_intf.sv]

# ---------- Compile Testbench (SystemVerilog + UVM) ----------
vlog -work work -sv +cover \
    -L mtiUvm \
    "+incdir+$TB_DIR" \
    "+incdir+[file join $UVM_HOME src]" \
    [file join $TB_DIR testbench.sv]

# ---------- Simulate AXI UVM test ----------
vsim -coverage -voptargs="+acc" work.testbench \
    -sv_seed random \
    +UVM_TESTNAME=mh_axi_test_base \
    +UVM_VERBOSITY=UVM_MEDIUM \
    -L work \
    -L mtiUvm

# ---------- Add waves ----------
add wave -group CLOCK_RESET sim:/testbench/aclk
add wave -group CLOCK_RESET sim:/testbench/aresetn
add wave -group AW -r sim:/testbench/aw_if/*
add wave -group W -r sim:/testbench/w_if/*
add wave -group B -r sim:/testbench/b_if/*
add wave -group AR -r sim:/testbench/ar_if/*
add wave -group R -r sim:/testbench/r_if/*

# ---------- Run simulation ----------
run -all

# ---------- Save and display functional coverage ----------
coverage save [file join $SIM_DIR coverage.ucdb]
coverage report -cvg -details \
    -output [file join $SIM_DIR coverage_report.txt]
vsim -viewcov [file join $SIM_DIR coverage.ucdb]
