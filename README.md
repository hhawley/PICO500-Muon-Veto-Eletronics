This github contains three projects all related to the Muon Veto electronics:

## LED driver
The LED driver is meant to drive 2 LEDs (for redundancy) in ultra short pulses (10-100 ns). These are used to verify the PMTs are working. These boards are 99%
finished. The final design needs 12 of these.

## Fan-in-Fan-out
This is meant to be located inside the crate for the LEDs. Only 1 is required.
It is intentionally incomplete as the final implementation does not really care
about how this board is constructed but it MUST follow the circuit shown.

## Nhit counting board
A 2-3 slot VME board. This one has two projects:

### Nhit comparators
The comparators used to digitize the PMTs output and fed into the counting board. The output is mean to be a SYGYZY port that connects to the FPGA. This needs to be finished.

### Nhit counting Board
Based on a Eclypse Z7, the code here is just a small sample of the Verilog code
used for the final design. The entire project I used to originally program the board is not found here because it is too big and usually does not port well.

Read me thesis or ask me a question!