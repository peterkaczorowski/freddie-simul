# Atari Freddie Chip Simulation in Verilog

This project contains a Verilog-based simulation of the Atari Freddie chip, inspired by the original Freddie Simulation in VHDL by Pasiu ("Pasia stolowka"). The simulation models the functionality of the Atari Freddie chip and can be used for testing and further development in FPGA and Verilog environments.

## Files
- **freddie.v**: Verilog code for the Atari Freddie chip simulation.
- **tb_freddie.v**: Testbench for simulating and verifying the functionality of the Freddie chip.
- **freddie-simul-gktwave-view.png**: Screenshot from the GTKWave program.
- **run-simul.sh**: Script to run the simulation.

### Steps to run the simulation:

1. **Install Icarus Verilog**:
   Follow the instructions on the [Icarus Verilog website](http://iverilog.icarus.com/) to download and install the software.

2. **Install GTKWave**:
   Download and install GTKWave from [here](https://gtkwave.sourceforge.net/).

3. **Compile the Verilog code**:
   In the terminal, navigate to the directory containing the files `freddie.v` and `tb_freddie.v`. Run the following command to compile the Verilog files:

   ```bash
   iverilog -o freddie_tb tb_freddie.v freddie.v

4. **Run the simulation:**
   After successful compilation, execute the simulation with:

   ```bash
   vvp freddie_tb

6. **View the results in GTKWave:**
   After running the simulation, a VCD file (Value Change Dump) will be generated. To view the simulation waveform, run:

   ```bash
   gtkwave freddie.vcd
   
