# Dear PM,

We have finished designing our ALU! Below you will find our process and results.

## Implementation

We decided to take a bit-slice approach to implementing our ALU. First, we decided to implement the adder function. We realized that our adder already computed some of the computations necessary for the other functions of the ALU, including XOR, NAND, and AND. As a result, we decided to use these computations from the adder as the results for those ALU functions. We made this choice in order to minimize our area at the potential cost of speed.

Our ALU commands were sent to a look-up table that would output values for which the internal bitslice multiplexer uses to determine which function to output, e.g. ADD, OR, AND, etc. In addition, the look-up table also controls the inversion of the B input in the case of subtraction and setting SLT control.

As you can see from the below bit-slice diagram, only NOR and OR are not included in the adder; both subtract and SLT expand upon the adder.

![Bit-slice](images/bit_slice.png)

The bit-slice diagram above shows that our bit-slice includes the bitslice implementation of our ADD, SUB, XOR, AND, NAND, NOR, OR functionality.

![Overall architecture](images/top_level.png)

We implemented the flags and SLT function on a higher level of abstraction.

The zero flag was implemented via ORing all the bits of a result, and then NOTing it in order to generate the output on the flag. This flag is always set to the appropriate output regardless of the ALU command.

The carryout and overflow flags are checked as per how an adder generally sets the flags, with the output flags being set only if ADD or SUB is the active ALU command.

SLT is accomplished via utilizing the subtraction function within the bitslice ALU elements, and then comparing the most significant bit (MSB) of the subtraction result, internal overflow, and MSB of the A operand. We set the ALU result to be one if the MSB of the subtraction result is one in the case of no overflow. In the case of overflow, we have to determine the sign of A, setting the ALU result to be one if it is negative.

![Black boxes](images/black_boxes.png)

## Test Results
Overall, our test results were very helpful to us in showing bugs in our code. Furthermore, they were also helpful for reminding us that we had to implement certain functions and flags such as the ZERO flag.

### Adder
For the adder we chose test cases that have input of two positive numbers, one positive and one negative number, and two negative numbers. On the output side, we covered the cases of no overflow or carryout, overflow but no carryout, carryout but no overflow, and both overflow and carryout. We had no issues verifying.

### Subtractor
For the subtractor we chose test cases that have input of two positive numbers, one positive one negative, and two negative numbers. On the output side, we covered the cases of no overflow or carryout, overflow but no carryout, carryout but no overflow, and both overflow and carryout. We had no issues verifying.

### XOR
For the XOR testbench, we covered all four test cases for one bit and multiple bits cases. Through these test cases, we had discovered that our AND and XOR was being multiplexed to the same line, and hence, required fixing because our XOR result was the ADD result.

### SLT
For the SLT cases we tried to compare positive number to positive number, positive to negative, negative to positive, negative to negative and two same numbers. This testbench showed us an issue that we had with competing gates driving a wire. As a result, we had to adjust our strategy of how we set wires to a fixed state.

### AND
For the AND testbench, we covered all four test cases for one bit and multiple bits cases.  See the statement under XOR for our issue here.

### NAND
For the NAND testbench, we covered all four test cases for one bit and multiple bits cases. We had no issues verifying.

### NOR
For the NOR testbench, we covered all four test cases for one bit and multiple bits cases. We had no issues verifying.

### OR
For the OR testbench, we covered all four test cases for one bit and multiple bits cases. We had no issues verifying.

#### Test Results
```
Command                  A                             B                  |                  R               | OFL CO     ZERO |              Exp R               Exp OFL Exp CO Exp Zero

                            ADD Tests                          
000   00000000000000000000000000100000  00000000000000000000000000000001  | 00000000000000000000000000100001 |  0   0    0     |  00000000000000000000000000100001   0    0     0
000   00000000000000000000000000000010  00000000000000000000000000000011  | 00000000000000000000000000000101 |  0   0    0     |  00000000000000000000000000000101   0    0     0
000   10000000000000000000000000000000  10000000000000000000000000000000  | 00000000000000000000000000000000 |  1   1    1     |  00000000000000000000000000000000   1    1     1
000   11111111111111111111111111111000  00000000000000000000000000000010  | 11111111111111111111111111111010 |  0   0    0     |  11111111111111111111111111111010   0    0     0
000   00000000000000000000000000001000  11111111111111111111111111111110  | 00000000000000000000000000000110 |  0   1    0     |  00000000000000000000000000000110   0    1     0
000   11111111111111111111111111111000  11111111111111111111111111110111  | 11111111111111111111111111101111 |  0   1    0     |  11111111111111111111111111101111   0    1     0
000   11111111111111111111111111111000  00000000000000000000000000000010  | 11111111111111111111111111111010 |  0   0    0     |  11111111111111111111111111111010   0    0     0
000   10000000000000000000000000000000  10000000000000000000000000000000  | 00000000000000000000000000000000 |  1   1    1     |  00000000000000000000000000000000   1    1     1
000   11111111111111111111111111111111  11111111111111111111111111111111  | 11111111111111111111111111111110 |  0   1    0     |  11111111111111111111111111111110   0    1     0
000   00000000000000000000000000000001  00000000000000000000000000000001  | 00000000000000000000000000000010 |  0   0    0     |  00000000000000000000000000000010   0    0     0

                            SUB Tests                          
001   00000000000000000000000000000001  00000000000000000000000000000000  | 00000000000000000000000000000001 |  0   1    0     |  00000000000000000000000000000001   0    1     0
001   00000000000000000000000000000001  00000000000000000000000000100000  | 11111111111111111111111111100001 |  0   0    0     |  11111111111111111111111111100001   0    0     0
001   00000000000000000000000000000001  11111111111111111111111111100000  | 00000000000000000000000000100001 |  0   0    0     |  00000000000000000000000000100001   0    0     0
001   11111111111111111111111111111111  00000000000000000000000000100000  | 11111111111111111111111111011111 |  0   1    0     |  11111111111111111111111111011111   0    1     0
001   11111111111111111111111111111111  11111111111111111111111111100000  | 00000000000000000000000000011111 |  0   1    0     |  00000000000000000000000000011111   0    1     0
001   11111111111111111111111111111000  00000000000000000000000000001001  | 11111111111111111111111111101111 |  0   1    0     |  11111111111111111111111111101111   0    1     0
001   11111111111111111111111111111000  11111111111111111111111111111110  | 11111111111111111111111111111010 |  0   0    0     |  11111111111111111111111111111010   0    0     0
001   10000000000000000000000000000000  10000000000000000000000000000000  | 00000000000000000000000000000000 |  0   1    1     |  00000000000000000000000000000000   0    1     1
001   11111111111111111111111111111111  00000000000000000000000000000001  | 11111111111111111111111111111110 |  0   1    0     |  11111111111111111111111111111110   0    1     0

                            XOR Tests                          
010   00000000000000000000000000000000  00000000000000000000000000000000  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
010   00000000000000000000000000000001  00000000000000000000000000000001  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
010   00000000000000000000000000000001  00000000000000000000000000000000  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
010   00000000000000000000000000000001  00000000000000000000000000000000  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0

                            SLT Tests                          
011   00000000000000000000000000100000  11111111111111111111111111111111  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
011   11111111111111111111111111100000  00000000000000000000000000000001  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
011   00000000000000000000000000100000  00000000000000000000000000000001  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
011   00000000000000000000000000000001  00000000000000000000000000100000  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
011   11111111111111111111111111100000  11111111111111111111111111111111  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
011   11111111111111111111111111111111  11111111111111111111111111100000  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
011   00000000000000000000000000000001  00000000000000000000000000000001  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1

                            AND Tests                          
100   00000000000000000000000000000000  00000000000000000000000000000000  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
100   00000000000000000000000000000001  00000000000000000000000000000001  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
100   00000000000000000000000000000001  00000000000000000000000000000000  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
100   00000000000000000000000000000000  00000000000000000000000000000001  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1

                           NAND Tests                          
101   00000000000000000000000000000000  00000000000000000000000000000000  | 11111111111111111111111111111111 |  0   0    0     |  all 1   0    0     0
101   00000000000000000000000000000001  00000000000000000000000000000001  | 11111111111111111111111111111110 |  0   0    0     |  all1, last 0   0    0     0
101   00000000000000000000000000000001  00000000000000000000000000000000  | 11111111111111111111111111111111 |  0   0    0     |  all 1   0    0     0
101   00000000000000000000000000000000  00000000000000000000000000000001  | 11111111111111111111111111111111 |  0   0    0     |  all 1   0    0     0

                            NOR Tests                          
110   00000000000000000000000000000000  00000000000000000000000000000000  | 11111111111111111111111111111111 |  0   0    0     |  all 1   0    0     0
110   00000000000000000000000000000001  00000000000000000000000000000001  | 11111111111111111111111111111110 |  0   0    0     |  all 1, last 0   0    0     0
110   00000000000000000000000000000001  00000000000000000000000000000000  | 11111111111111111111111111111110 |  0   0    0     |  all 1, last 0   0    0     0
110   00000000000000000000000000000000  00000000000000000000000000000001  | 11111111111111111111111111111110 |  0   0    0     |  all 1, last 0   0    0     0

                             OR Tests                          
111   00000000000000000000000000000000  00000000000000000000000000000000  | 00000000000000000000000000000000 |  0   0    1     |  0   0    0     1
111   00000000000000000000000000000001  00000000000000000000000000000001  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
111   00000000000000000000000000000000  00000000000000000000000000000001  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
111   00000000000000000000000000000001  00000000000000000000000000000000  | 00000000000000000000000000000001 |  0   0    0     |  1   0    0     0
```

## Timing Analysis

The worst case propagation delay of the entire ALU is when calculating the result of the zero flag when doing an SLT calculation. We found that this delay is 2640 time units.  

For each different operation, finding the result of the zero flag is always the slowest. For both addition and subtraction, the worst case timing takes 2560 units. For XOR, the worst case timing is 590 units. For the AND, the worst case timing is 610 units. For NAND, the worst case timing is 540 units. For NOR, the worst case timing is 540 units. For OR, the worst case timing is 570 units.

## Work Plan Reflection
Generally speaking, we followed our work plan well for the majority part of the lab. In aggregate, we had matched our planned time quite well, spending about 10 hours, as per our work plan. The actual distribution of the hours differed due to a change of direction regarding speed vs. area decisions and unexpected delays in implementing the SLT component and typo correction. The typo debugging was the largest time expenditure. In the future, we plan to implement a more rigorous standard for labeling and preparing a visual representation of our circuit in order to minimize time spent chasing typos. Furthermore, we will also allocate more time for debugging and other unforeseen issues.


### Sincerely,
### The CPU team
