# Lab 0 Report
## 1. Waveforms

## 2. Test Case Strategy
We chose our test cases to show, most importantly, that our adder can add, without failure, the numbers that it can and should be able to handle (unsigned 4-bit integers whose sum is also a 4-bit integer).

However, we also wanted to show that our adder can gracefully handle addition of signed 4-bit integers, overflow, and carryout. For example, the addition of two negative numbers might yield a positive number, and if such, this should be marked with an overflow.

## 3. Test Case Failures
When we first programmed our board, we did not take into account that we would be doing 2's complement addition; we only thought about unsigned integers. Thus, once we tried to add two negative numbers, our board failed the test and did not show any overflow. Originally, our board could not handle overflow. In many instances (INSERT EXAMPLES HERE) two positive numbers would sum to a negative number and two negative numbers would yield a positive number. As a result, we realized that we had to do handle overflows differently. XOR

## 4. Summary of Testing on board
To make sure our adder is fully functional, we devised various test cases to cover all the possible cases; the categories are as following:
I. adding on each of the four digit
example. 0010 + 0100 = 0110         1001 + 0000 = 1001
II. Carryout = 1, Overflow = 0
example. 1111 + 1111 = 1110         1100 + 0100 = 0000
III. Carryout = 0, Overflow = 1
example. 0100 + 0110 = 1010         0111 + 0101 = 1100
IV. Carryout = 1, Overflow = 1
example. 1010 + 1001 = 0011         1100 + 1011 = 0111
V. Carryout = 0, Overflow = 0
example. 0001 + 1100 = 1101         0110 + 0010 = 1000
VI. Commutative law
example. 1011 + 1101 = 1000         1101 + 1011 = 1000

The full test cases are listed below:

Picture of testing on FPGA:
## 5. Summary Statistics of Synthesized Design
