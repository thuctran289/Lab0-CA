
iverilog -o cpu.t.vvp   cpu.t.v cpu.v InstructionFetch/instructionfetch.v InstructionFetch/mux.v InstructionFetch/programcounter.v InstructionFetch/signextend.v InstructionFetch/FullAdder30.v InstructionFetch/concatenate.v InstructionFetch/instructionmemory.v datapath.v alu.v registerfile.v instructiondecoder.v memory.v regfile/register32.v regfile/mux32to1by32.v regfile/register32zero.v regfile/decoder1to32.v 
vvp cpu.t.vvp
