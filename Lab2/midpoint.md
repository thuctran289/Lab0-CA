# Midpoint deliverable physical test bench
Our test for verification of the midpoint deliverable was the following:
1. We loaded xA5 into the register by pressing button 0. This will help verify the parallel load functionality.

2. We verify that xA5 was loaded by repeatedly flipping switch 1 in order to shift on the clock. We expect to get eventually all zeros after the fifth flip and through to the eighth flip for our output due to the left shift not rotating. This will verify the shifting functionality.

3. Following this, we flip switch 0 to on, and then continue shifting on the clock. We expect to start seeing LEDs on after the 4th flip. and eventually they should all be on. This verifies the serial in functionality.
