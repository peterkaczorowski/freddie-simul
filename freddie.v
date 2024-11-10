//-----------------------------------------------------------------------------
// Subject: Atari Freddie chip simulation
// Author: Verilog code by Piotr D. Kaczorowski
// Based on: Freddie Simulation in VHDL by Pasiu ("Pasia stolowka")
//-----------------------------------------------------------------------------
// Description:
// This module simulates the Atari Freddie chip functionality in Verilog,
// based on the original Freddie Simulation in VHDL by Pasiu.
//
//-----------------------------------------------------------------------------
// Version: 1.0
// Date: November 10th, 2024
//-----------------------------------------------------------------------------
// Change History:
// Version 1.0 - Initial release
//-----------------------------------------------------------------------------

module freddie (
    input  wire        clk_in,
    input  wire        rst,
    input  wire        extsel,
    input  wire        casinh,
    input  wire        phi2,
    input  wire        rw,
    input  wire [15:0] a,
    output reg         clk_out,
    output reg         osc,
    output reg         ras,
    output reg         cas,
    output reg         w,
    output reg [7:0]   ba
);

reg        neg_clk;
reg [2:0]  fcount;
reg        mpy;
reg        l_rw;

always @(posedge clk_in or negedge rst) begin
    if (!rst)
        fcount <= 3'b000;
    else begin
        fcount[0] <= (~fcount[2] & ~fcount[1] & ~phi2) | (fcount[2] & fcount[1] & phi2);
        fcount[1] <= (~fcount[2] & fcount[0] & ~phi2) |
                     (~fcount[2] & fcount[1] & ~fcount[0] & ~phi2) |
                     (fcount[2] & fcount[1] & ~fcount[0] & phi2);
        fcount[2] <= (~fcount[2] & fcount[1] & ~fcount[0] & ~phi2) |
                     (fcount[2] & fcount[1] & ~fcount[0] & phi2) |
                     (fcount[2] & fcount[0] & phi2);
    end
end

always @(posedge neg_clk or negedge rst) begin
    if (!rst) begin
        ras   <= 1'b1;
        l_rw  <= 1'b1;
    end else begin
        if (fcount == 3'b000 || fcount == 3'b001 || fcount == 3'b011)
            ras <= 1'b1;
        else
            ras <= 1'b0;

        if (fcount == 3'b010)
            l_rw <= rw;
    end
end

always @(*) begin
    neg_clk = ~clk_in;
    clk_out = neg_clk;
    osc = (fcount[2:1] == 2'b00 || fcount[2:1] == 2'b11) ? 1'b1 : 1'b0;
    mpy = (fcount == 3'b001 || fcount == 3'b011 || fcount == 3'b010) ? 1'b0 : 1'b1;
    ba[0] = (mpy == 1'b0) ? a[0] : a[8];
    ba[1] = (mpy == 1'b0) ? a[1] : a[9];
    ba[2] = (mpy == 1'b0) ? a[2] : a[10];
    ba[3] = (mpy == 1'b0) ? a[3] : a[11];
    ba[4] = (mpy == 1'b0) ? a[4] : a[12];
    ba[5] = (mpy == 1'b0) ? a[5] : a[13];
    ba[6] = (mpy == 1'b0) ? a[6] : a[14];
    ba[7] = (mpy == 1'b0) ? a[7] : a[15];
    w = (fcount == 3'b001 || fcount == 3'b011 || (fcount == 3'b010 && neg_clk == 1'b0)) ? rw : l_rw;
    cas = (extsel == 1'b0 || casinh == 1'b0 || fcount == 3'b011 || fcount == 3'b010 || fcount == 3'b110 ||
           (l_rw == 1'b1 && fcount == 3'b001) || (l_rw == 1'b0 && fcount == 3'b111) ||
           (l_rw == 1'b0 && fcount == 3'b001 && neg_clk == 1'b1) ||
           (l_rw == 1'b0 && fcount == 3'b101 && neg_clk == 1'b0)) ? 1'b1 : 1'b0;
end

endmodule

