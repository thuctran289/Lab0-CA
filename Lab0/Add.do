vlog -reportprogress 300 -work work FourBitAdder.v Adder.v
vsim -voptargs="+acc" test4BitAdd
add wave -position insertpoint  \
sim:/test4BitAdd/a \
sim:/test4BitAdd/b \
sim:/test4BitAdd/out \
sim:/test4BitAdd/cout \
sim:/test4BitAdd/overflow 
run -all
wave zoom full
