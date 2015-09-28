vlog -reportprogress 300 -work work FourBitAdder.v
vsim -voptargs="+acc" test4BitAdd
run -all

