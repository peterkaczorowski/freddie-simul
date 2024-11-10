//-----------------------------------------------------------------------------
// Subject: Atari Freddie chip simulation testbench
// Author: Verilog code by Piotr D. Kaczorowski
// Based on: Freddie Simulation in VHDL by Pasiu ("Pasia stolowka")
//-----------------------------------------------------------------------------
// Description:
// This testbench verifies the functionality of the Atari Freddie chip simulation
// in Verilog, based on the original Freddie Simulation in VHDL by Pasiu.
//
//-----------------------------------------------------------------------------
// Version: 1.0
// Date: November 10th, 2024
//-----------------------------------------------------------------------------
// Change History:
// Version 1.0 - Initial release
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_freddie;

    reg         s_clk_in;
    wire        s_clk_out;
    reg         s_rst;
    reg         s_extsel;
    reg         s_casinh;
    reg         s_phi2;
    reg         s_rw;
    reg  [15:0] s_a;
    wire        s_osc;
    wire        s_ras;
    wire        s_cas;
    wire        s_w;
    wire [7:0]  s_ba;

    // Clock period
    parameter period = 35;

    // Instantiate the freddie module
    freddie uut (
        .clk_in(s_clk_in),
        .clk_out(s_clk_out),
        .rst(s_rst),
        .extsel(s_extsel),
        .casinh(s_casinh),
        .phi2(s_phi2),
        .rw(s_rw),
        .a(s_a),
        .osc(s_osc),
        .ras(s_ras),
        .cas(s_cas),
        .w(s_w),
        .ba(s_ba)
    );

    // Clock generation
    always begin
        s_clk_in = 1;
        #(period/2);
        s_clk_in = 0;
        #(period/2);
    end

    // Clock for phi2 signal
    initial begin
        s_phi2 = 0;
        #(period * 7);
        s_phi2 = 1;
        #(period * 8);
        s_phi2 = 0;
        #(period);
    end

    // Test sequence
    initial begin
        // Dump the waveform to a file
        $dumpfile("freddie.vcd");
        $dumpvars(0, tb_freddie, uut);

        s_rst = 0;
        s_rw = 0;
        s_extsel = 0;
        s_casinh = 0;
        s_a = 16'b0000000011111111;
        #(period * 11);

        s_rst = 1;
        #(period * 5);

        s_extsel = 1;
        s_casinh = 1;
        #(period * 16);

        s_rw = 1;
        #(period * 16);

        s_rw = 0;
        #(period * 32);

        #80 $finish;
    end

endmodule

