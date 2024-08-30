`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2024 22:11:12
// Design Name: 
// Module Name: fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_synchronous_fifo;

  // Parameters
  parameter DEPTH = 8;
  parameter DATA_WIDTH = 8;

  // Signals
  reg clk;
  reg rst_n;
  reg w_en;
  reg r_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire full;
  wire empty;

  // DUT instantiation
  synchronous_fifo #(DEPTH, DATA_WIDTH) dut (
    .clk(clk),
    .rst_n(rst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initial conditions
    clk = 0;
    rst_n = 0;
    w_en = 0;
    r_en = 0;
    data_in = 0;

    // Reset the DUT
    #10;
    rst_n = 1;

    // Test Case 1: Write to FIFO until full
    $display("Test Case 1: Write to FIFO until full");
    repeat (DEPTH) begin
      #10;
      w_en = 1;
      data_in = $random % 256; // Random data
    end
    #10;
    w_en = 0;

    // Check full condition
    if (full) $display("FIFO is full as expected");
    else $display("FIFO full condition failed");

    // Test Case 2: Read from FIFO until empty
    $display("Test Case 2: Read from FIFO until empty");
    repeat (DEPTH) begin
      #10;
      r_en = 1;
    end
    #10;
    r_en = 0;

    // Check empty condition
    if (empty) $display("FIFO is empty as expected");
    else $display("FIFO empty condition failed");

    // Test Case 3: Parallel Write and Read
    $display("Test Case 3: Parallel Write and Read");
    repeat (DEPTH / 2) begin
      #10;
      w_en = 1;
      r_en = 1;
      data_in = $random % 256; // Random data
    end
    #10;
    w_en = 0;
    r_en = 0;

    // Test Case 4: Write to Full FIFO
    $display("Test Case 4: Write to Full FIFO");
    repeat (DEPTH) begin
      #10;
      w_en = 1;
      data_in = $random % 256; // Random data
    end
    #10;
    w_en = 0;

    // Attempt to write to full FIFO
    #10;
    w_en = 1;
    data_in = $random % 256; // Random data
    #10;
    w_en = 0;
    if (full) $display("FIFO is full, write operation prevented");
    else $display("FIFO full condition failed during write attempt");

    // Test Case 5: Read from Empty FIFO
    $display("Test Case 5: Read from Empty FIFO");
    repeat (DEPTH) begin
      #10;
      r_en = 1;
    end
    #10;
    r_en = 0;

    // Attempt to read from empty FIFO
    #10;
    r_en = 1;
    #10;
    r_en = 0;
    if (empty) $display("FIFO is empty, read operation prevented");
    else $display("FIFO empty condition failed during read attempt");

    $stop;
  end
  
 
endmodule
