transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/altera/quartus ii 13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/RTL {U:/Projects/FPGA/Examples/13_PLL/RTL/PLL.v}
vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/Project/IP_core/PLL1 {U:/Projects/FPGA/Examples/13_PLL/Project/IP_core/PLL1/PLL1.v}
vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/Project/IP_core/PLL2 {U:/Projects/FPGA/Examples/13_PLL/Project/IP_core/PLL2/PLL2.v}
vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/Project/db {U:/Projects/FPGA/Examples/13_PLL/Project/db/pll1_altpll.v}
vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/Project/db {U:/Projects/FPGA/Examples/13_PLL/Project/db/pll2_altpll.v}

vlog -vlog01compat -work work +incdir+U:/Projects/FPGA/Examples/13_PLL/Project/../Sim {U:/Projects/FPGA/Examples/13_PLL/Project/../Sim/PLL_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  PLL_TB

add wave *
view structure
view signals
run 1 us
