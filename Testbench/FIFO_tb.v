`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Om Patel
// Create Date: 29.08.2026 21:59:23
// Design Name: Synchronous FIFO Testbench
// Module Name: FIFO_tb
// Project Name: Synchronous FIFO
// Nirma University
// Tool Versions:Vivado 2025.2
//////////////////////////////////////////////////////////////////////////////////

module FIFO_tb #(
    parameter N = 8,
    parameter FIFO_Depth = 16
);

reg clk, reset;
reg wr_en, rd_en, peek_en, flush;
reg [N-1:0] data_in;

wire [N-1:0] data_out;
wire empty, full;

integer i;

always #5 clk = ~clk;

Synch_FIFO #(
    .N(N),
    .FIFO_Depth(FIFO_Depth)
) DUT (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .peek_en(peek_en),
    .flush(flush),
    .data_out(data_out),
    .empty(empty),
    .full(full)
);

initial 
begin

    clk = 0;
    reset = 1;
    wr_en = 0;
    rd_en = 0;
    peek_en = 0;
    flush = 0;
    data_in = 0;

    @(posedge clk);
    @(posedge clk);
    #1;
    
    reset = 0;
    #10;
    
    wr_en = 1;

    for(i = 0; i < 20; i = i + 1) 
    begin    
        data_in = $random;
        @(posedge clk);
        #1;
    end
    
    #10;
    
    wr_en = 1;
    rd_en = 1;
    
    for(i = 0; i < 20; i = i + 1) 
    begin
        data_in = $random;
        @(posedge clk);
        #1;
    end
    
    #10;
    
    wr_en = 0;
    rd_en = 1;

    for(i = 0; i < 20; i = i + 1) 
    begin
        @(posedge clk);
        #1;
    end
    
    #10;
    
    wr_en = 1;
    rd_en = 1;
    
    for(i = 0; i < 20; i = i + 1) 
    begin
        data_in = $random;
        @(posedge clk);
        #1;
    end

    
    wr_en = 1;
    rd_en = 0;

    for(i = 0; i < 10; i = i + 1) 
    begin    
        data_in = $random;
        @(posedge clk);
        #1;
    end
    
    #10;
    
    wr_en = 0;
    rd_en = 0;
    peek_en = 1;
    
    #10;
    
    wr_en = 1;
    rd_en = 0;
    peek_en = 1;
    
    for(i = 0; i < 10; i = i + 1) 
    begin    
        data_in = $random;
        @(posedge clk);
        #1;
    end
    
    #10;
    
    wr_en = 0;
    rd_en = 1;
    peek_en = 1;
    
    #100;
    
    flush = 1;
    @(posedge clk);
    #1;
    
    flush = 0;

    wr_en = 1;
    rd_en = 1;
    peek_en = 1;
    
    for(i = 0; i < 20; i = i + 1) 
    begin    
        data_in = $random;
        @(posedge clk);
        #1;
    end
    
    #30;
    $finish;
end
endmodule