RED="\033[0;31m"
PURPLE="\033[0;35m"
BLUE="\033[0;36m"
BROWN="\033[0;33m"
NC="\033[0m"
echo "${BLUE}Test Benches for SPI Memory"
echo "===========================${NC}"

echo "${BROWN}"
iverilog -o inputconditioner.t.vvp inputconditioner.t.v inputconditioner.v
vvp inputconditioner.t.vvp

echo "${RED}============================="

echo "${BROWN}"
iverilog -o shiftregister.t.vvp shiftregister.t.v shiftregister.v
vvp shiftregister.t.vvp

echo "${RED}=============================${NC}"
iverilog -o spimemory.t.vvp spimemory.t.v spimemory.v datamemory.v shiftregister.v inputconditioner.v
vvp spimemory.t.vvp 

echo "${BLUE}"
echo "To view waveforms for the given parts,\nopen the following in Scansion (on a mac!!!):${NC}"
echo "${PURPLE}input conditioner: ${NC}inputconditioner.vcd"
echo "${PURPLE}shift register   : ${NC}shiftregister.vcd"
echo "${PURPLE}SPI memory       : ${NC}spimemory.vcd"