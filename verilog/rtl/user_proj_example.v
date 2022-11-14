// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    bka16 dut(.a(rdata[16:0]), .b(rdata[32:17]), .cin(rdata[33]), .sum(count[16:0]), .carryout(count[17]));

endmodule


module bka16
    (
input [15:0]a,
input [15:0]b,
input cin,
output [15:0]sum,
output carryout
    );
wire [15:0] p,g,p1,g1,p2,g2,p3,g3,p4,g4,p5,g5,p6,g6,p7,g7;
wire c;

assign p=a^b;
assign g=a&b;

assign g1[0]=(g[0]);
assign p1[0]=(p[0]);

assign g1[1]=(p[1]&g[0])|g[1];
assign p1[1]=(p[1]&p[0]);

assign g1[2]=(g[2]);
assign p1[2]=(p[2]);

assign g1[3]=(p[3]&g[2])|g[3];
assign p1[3]=p[3]&p[2];

assign g1[4]=(g[4]);
assign p1[4]=(p[4]);

assign g1[5]=(p[5]&g[4])|g[5];
assign p1[5]=p[5]&p[4];

assign g1[6]=(g[6]);
assign p1[6]=(p[6]);

assign g1[7]=(p[7]&g[6])|g[7];
assign p1[7]=p[7]&p[6];

assign g1[8]=(g[8]);
assign p1[8]=(p[8]);

assign g1[9]=(p[9]&g[8])|g[9];
assign p1[9]=p[9]&p[8];

assign g1[10]=(g[10]);
assign p1[10]=(p[10]);

assign g1[11]=(p[11]&g[10])|g[11];
assign p1[11]=p[11]&p[10];

assign g1[12]=(g[12]);
assign p1[12]=(p[12]);

assign g1[13]=(p[13]&g[12])|g[13];
assign p1[13]=p[13]&p[12];

assign g1[14]=(g[14]);
assign p1[14]=(p[14]);

assign g1[15]=(p[15]&g[14])|g[15];
assign p1[15]=p[15]&p[14];

assign g2[0]=g1[0];
assign p2[0]=p1[0];

assign g2[1]=g1[1];
assign p2[1]=p1[1];

assign g2[2]=g1[2];
assign p2[2]=p1[2];

assign g2[3]=(p1[3]&g1[1])|g1[3];
assign p2[3]=p1[3]&p1[1];

assign g2[4]=g1[4];
assign p2[4]=p1[4];

assign g2[5]=g1[5];
assign p2[5]=p1[5];

assign g2[6]=g1[6];
assign p2[6]=p1[6];

assign g2[7]=(p1[7]&g1[5])|g1[7];
assign p2[7]=p1[7]&p1[5];

assign g2[8]=g1[8];
assign p2[8]=p1[8];

assign g2[9]=g1[9];
assign p2[9]=p1[9];

assign g2[10]=g1[10];
assign p2[10]=p1[10];

assign g2[11]=(p1[11]&g1[9])|g1[11];
assign p2[11]=p1[11]&p1[9];

assign g2[12]=g1[12];
assign p2[12]=p1[12];

assign g2[13]=g1[13];
assign p2[13]=p1[13];

assign g2[14]=g1[14];
assign p2[14]=p1[14];

assign g2[15]=(p1[15]&g1[13])|g1[15];
assign p2[15]=p1[15]&p1[13];

assign g3[0]=g2[0];
assign p3[0]=p2[0];

assign g3[1]=g2[1];
assign p3[1]=p2[1];

assign g3[2]=g2[2];
assign p3[2]=p2[2];

assign g3[3]=g2[3];
assign p3[3]=p2[3];

assign g3[4]=g2[4];
assign p3[4]=p2[4];

assign g3[5]=g2[5];
assign p3[5]=p2[5];

assign g3[6]=g2[6];
assign p3[6]=p2[6];

assign g3[7]=(p2[7]&g2[3])|g2[7];
assign p3[7]=p2[7]&p2[3];

assign g3[8]=g2[8];
assign p3[8]=p2[8];

assign g3[9]=g2[9];
assign p3[9]=p2[9];

assign g3[10]=g2[10];
assign p3[10]=p2[10];

assign g3[11]=g2[11];
assign p3[11]=p2[11];

assign g3[12]=g2[12];
assign p3[12]=p2[12];

assign g3[13]=g2[13];
assign p3[13]=p2[13];

assign g3[14]=g2[14];
assign p3[14]=p2[14];

assign g3[15]=(p2[15]&g2[11])|g2[15];
assign p3[15]=p2[15]&p2[11];

assign g4[0]=g3[0];
assign p4[0]=p3[0];

assign g4[1]=g3[1];
assign p4[1]=p3[1];

assign g4[2]=g3[2];
assign p4[2]=p3[2];

assign g4[3]=g3[3];
assign p4[3]=p3[3];

assign g4[4]=g3[4];
assign p4[4]=p3[4];

assign g4[5]=g3[5];
assign p4[5]=p3[5];

assign g4[6]=g3[6];
assign p4[6]=p3[6];
      
assign g4[7]=g3[7];
assign p4[7]=p3[7];

assign g4[8]=g3[8];
assign p4[8]=p3[8];

assign g4[9]=g3[9];
assign p4[9]=p3[9];

assign g4[10]=g3[10];
assign p4[10]=p3[10];

assign g4[11]=g3[11];
assign p4[11]=p3[11];

assign g4[12]=g3[12];
assign p4[12]=p3[12];

assign g4[13]=g3[13];
assign p4[13]=p3[13];

assign g4[14]=g3[14];
assign p4[14]=p3[14];
        
assign g4[15]=(p3[15]&g3[7])|g3[15];
assign p4[15]=p3[15]&p3[7];

assign g5[0]=g4[0];
assign p5[0]=p4[0];
              
assign g5[1]=g4[1];
assign p5[1]=p4[1];
              
assign g5[2]=g4[2];
assign p5[2]=p4[2];
              
assign g5[3]=g4[3];
assign p5[3]=p4[3];
              
assign g5[4]=g4[4];
assign p5[4]=p4[4];
              
assign g5[5]=g4[5];
assign p5[5]=p4[5];
              
assign g5[6]=g4[6];
assign p5[6]=p4[6];
              
assign g5[7]=g4[7];
assign p5[7]=p4[7];
              
assign g5[8]=g4[8];
assign p5[8]=p4[8];
              
assign g5[9]=g4[9];
assign p5[9]=p4[9];

assign g5[10]=g4[10];
assign p5[10]=p4[10];

assign g5[11]=(p4[11]&g4[7])|g4[11];
assign p5[11]=p4[11]&p4[7];

assign g5[12]=g4[12];
assign p5[12]=p4[12];
              
assign g5[13]=g4[13];
assign p5[13]=p4[13];
     
assign g5[14]=g4[14];
assign p5[14]=p4[14];
  
assign g5[15]=g4[15];
assign p5[15]=p4[15];

assign g6[0]=g5[0];
assign p6[0]=p5[0];

assign g6[1]=g5[1];
assign p6[1]=p5[1];

assign g6[2]=g5[2];
assign p6[2]=p5[2];

assign g6[3]=g5[3];
assign p6[3]=p5[3];

assign g6[4]=g5[4];
assign p6[4]=p5[4];

assign g6[5]=(p5[5]&g5[3])|g5[5];
assign p6[5]=p5[5]&p5[3];

assign g6[6]=g5[6];
assign p6[6]=p5[6];

assign g6[7]=g5[7];
assign p6[7]=p5[7];

assign g6[8]=g5[8];
assign p6[8]=p5[8];

assign g6[9]=(p5[9]&g5[7])|g5[9];
assign p6[9]=p5[9]&p5[7];

assign g6[10]=g5[10];
assign p6[10]=p5[10];

assign g6[11]=g5[11];
assign p6[11]=p5[11];

assign g6[12]=g5[12];
assign p6[12]=p5[12];

assign g6[13]=(p5[13]&g5[11])|g5[13];
assign p6[13]=p5[13]&p5[11];

assign g6[14]=g5[14];
assign p6[14]=p5[14];

assign g6[15]=g5[15];
assign p6[15]=p5[15];

assign g7[0]=g6[0];
assign p7[0]=p6[0];

assign g7[1]=g6[1];
assign p7[1]=p6[1];

assign g7[2]=(p6[2]&g6[1])|g6[2];
assign p7[2]=p6[2]&p6[1];

assign g7[3]=g6[3];
assign p7[3]=p6[3];

assign g7[4]=(p6[4]&g6[3])|g6[4];
assign p7[4]=p6[4]&p6[3];

assign g7[5]=g6[5];
assign p7[5]=p6[5];

assign g7[6]=(p6[6]&g6[5])|g6[6];
assign p7[6]=p6[6]&p6[5];

assign g7[7]=g6[7];
assign p7[7]=p6[7];

assign g7[8]=(p6[8]&g6[7])|g6[8];
assign p7[8]=p6[8]&p6[7];

assign g7[9]=g6[9];
assign p7[9]=p6[9];

assign g7[10]=(p6[10]&g6[9])|g6[10];
assign p7[10]=p6[10]&p6[9];

assign g7[11]=g6[11];
assign p7[11]=p6[11];

assign g7[12]=(p6[12]&g6[11])|g6[12];
assign p7[12]=p6[12]&p6[11];

assign g7[13]=g6[13];
assign p7[13]=p6[13];

assign g7[14]=(p6[14]&g6[13])|g6[14];
assign p7[14]=p6[14]&p6[13];

assign g7[15]=g6[15];
assign p7[15]=p6[15];

assign c=g7[15];
assign sum[0]=p[0]^cin;
assign sum[1]=p[1]^g[0];
assign sum[2]=p[2]^g1[1];
assign sum[3]=p[3]^g7[2];
assign sum[4]=p[4]^g2[3];
assign sum[5]=p[5]^g7[4];
assign sum[6]=p[6]^g6[5];
assign sum[7]=p[7]^g7[6];
assign sum[8]=p[8]^g3[7];
assign sum[9]=p[9]^g7[8];
assign sum[10]=p[10]^g6[9];
assign sum[11]=p[11]^g7[10];
assign sum[12]=p[12]^g5[11];
assign sum[13]=p[13]^g7[12];
assign sum[14]=p[14]^g6[13];
assign sum[15]=p[15]^g7[14];
assign carryout=c;

endmodule
`default_nettype wire
