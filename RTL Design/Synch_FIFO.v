`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Om Patel
// Create Date: 29.08.2026 21:59:23
// Design Name: Synchronous FIFO Design
// Module Name: Synch_FIFO
// Project Name: Synchronous FIFO
// Nirma University
// Tool Versions:Vivado 2025.2
//////////////////////////////////////////////////////////////////////////////////

module Synch_FIFO#(
    parameter N = 8, //Data Width
    parameter FIFO_Depth = 16 //FIFO Depth
)(
input clk,
input reset,
input [N-1:0] data_in,
input wr_en,
input rd_en,
input peek_en,
input flush,
output reg [N-1:0] data_out,
output reg empty,
output reg full
  );
localparam M = $clog2(FIFO_Depth); 

reg [M-1:0] wr_ptr = 0;
reg [M-1:0] rd_ptr = 0;
reg [M:0] count = 0;
reg [N-1:0]memory[0:(FIFO_Depth-1)];
reg [M:0] next_count = 0;

always@(*)
begin
    next_count = count;
    case({peek_en,rd_en,wr_en})
    3'b000:
            next_count = count;
    3'b001:
            if(count < FIFO_Depth)
                next_count = count+1;
    3'b010:
            if(count>0)
                next_count = count-1;
    3'b011:
            if(count == 0)
                next_count = count +1;
            else
                next_count = count;
    3'b100:
            next_count = count;
    3'b101:
            if(count < FIFO_Depth)
                next_count = count + 1;
    3'b110:
            if(count > 0)
                next_count = count - 1;
    3'b111:
            if(count == 0)
                next_count = count + 1;
            else
                next_count = count;
    endcase
end

always@( posedge clk )
begin
    if((reset==1) || (flush==1))
        begin
            wr_ptr <= 0;
            rd_ptr <=0;
            count <=0;
            empty <=1;
            full <=0; 
            data_out <= 0;
        end
    else 
    begin
        case({peek_en,rd_en,wr_en})
        3'b000:
                begin
                end
        3'b001:
                begin   
                        if(count<FIFO_Depth)
                            begin
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr+ 1;
                            end
                end
        3'b010:      
                begin
                        if(count > 0)
                            begin
                                data_out <= memory[rd_ptr];
                                rd_ptr <= rd_ptr+1;
                            end
                        else
                            data_out<=0;
                end
        3'b011:          
                begin
                        if(count==0)
                            begin
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr+1;
                                data_out <= 0;
                            end
                        else
                            begin
                                data_out <= memory[rd_ptr];
                                rd_ptr <= rd_ptr+1;
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr +1;
                            end
                end
        3'b100:               
                begin
                        if(count>0)
                            begin
                                data_out <= memory[rd_ptr];
                            end
                        
                end
        3'b101:
                begin
                        if (count < FIFO_Depth && count != 0)
                            begin
                                data_out <= memory[rd_ptr];
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr + 1;
                            end
                        else if(count == 0)
                            begin
                                data_out <= 0;
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr + 1;
                            end
                        else
                            begin
                                data_out <= memory[rd_ptr];
                            end
                end
        3'b110:
                begin
                        if(count > 0)
                            begin
                                data_out <= memory[rd_ptr];
                                rd_ptr <= rd_ptr+1;
                        end
                        else
                            data_out<=0;
                end
        3'b111:
                begin
                        if(count==0)
                            begin
                                memory[wr_ptr] <= data_in;
                                wr_ptr <= wr_ptr + 1;
                                data_out <= 0;
                            end
                        else 
                            begin
                                memory[wr_ptr] <= data_in;
                                data_out <= memory[rd_ptr];
                                rd_ptr <= rd_ptr+1;
                                wr_ptr <= wr_ptr+1;
                            end
                end              
        endcase
        
        count <= next_count;
        
        if (next_count == 0) 
            begin
                empty <= 1;
                full  <= 0;
            end
        else if(next_count == FIFO_Depth)
            begin
                empty <= 0;
                full  <= 1;
            end
        else 
            begin
                empty <= 0;
                full  <= 0;
            end
    end
end
endmodule