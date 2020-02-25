vlib work
vlog WaveMaker.v
vlog WaveAdder.v
vlog Enabler.v
vlog Channel.v
vlog RAM0.v
vlog RAM1.v
vlog newSim.v

vsim -L altera_mf_ver newSim
log -r {/*}
add wave {/*}


# KEY[3:0], SW[9:0], CLOCK_50


#initialize
force {SW} 10'b0000000000
force {KEY} 4'b1111

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns


#set playEn to 1, nothing should be outputting

force {SW} 10'b1111111111

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns
