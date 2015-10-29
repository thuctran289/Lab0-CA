# Work plan
midpoint checkin Mon. Nov 2 5PM

lab due: Mon. Nov 9 5PM

## Deliverables
### Input Conditioning: 10/28 - 10/29, 2 hours
1.5 hour: Input conditioner - DONE IN 1.1 HOUR :)
- Input Synchronization
- Input Debouncing
- Edge Detection

20 mins: Test bench -
- demonstrates 3 functions

10 mins: Test script - 30 MINUTES :) (problem with iverilog syntax)
- execute test bench and generate wave forms

### Shift Register: 10/31 - 11/1, 2.5 hours
1.5 hours: Shift register
- Parallel In/ Serial Out
- Serial In/ Parallel Out

1 hour: Test bench
- Parallel In/ Serial Out
- Serial In/ Parallel Out

### Midpoint Checkin: 11/1 - 11/2, 3.5 hours
1 hour: Top level module and load it onto FPGA

2 hours: Design a test sequence that demonstrates successful operation of this portion of the lab. Short written description of what the test engineer is to do, and what the state of the LEDS should be at each step

.5 hour: Show a NINJA of the test being executed and/or submit a ~60sec video

### SPI Memory: 11/3 - 11/4, 2 hours
128 bytes

FSM

### SPI Memory Testing: 11/5 - 11/6, 2 hours
test your SPI memory against the ARM processor

### Fault Injection: 11/7, 1 hour
Inject a fault

Explain the test pattern

### Final report: 11/8 - 11/9, 5 hours
Input Conditioner
- circuit diagram of structural circuit for input conditioner
- if main system clock is at 50MHz, what is the max length input glitch that will be suppressed by this design for a wait time of 10?

Shift Register
- describe test bench strategy

SPI Memory Testing
- detailed analysis of testing strategy. Why did you choose the test sequences you did?

Fault Injection
- describe the fault you are injecting. include schematic
- explain test pattern
