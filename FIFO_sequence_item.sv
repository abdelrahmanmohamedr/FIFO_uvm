////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_sequence_item class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_sequence_item_pkg;

//package import
import uvm_pkg::*;
`include "uvm_macros.svh";

class FIFO_sequence_item extends uvm_sequence_item;

//factory registeration
    `uvm_object_utils(FIFO_sequence_item);

//parameters
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;


//internal_signals
    bit clk;

    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    int RD_EN_ON_DIST;
    int WR_EN_ON_DIST;


//functions
    function new(string name = "FIFO_sequence_item" ,input int WR_EN_ON_DIST_int = 70 , RD_EN_ON_DIST_int = 30);
        super.new(name);
        WR_EN_ON_DIST = WR_EN_ON_DIST_int;
        RD_EN_ON_DIST = RD_EN_ON_DIST_int;
    endfunction //new function

    function string convert2string();
        return $sformatf("%s data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostempty = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b"
        ,super.convert2string(),data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        
    endfunction //convert2string function

    function string convert2string_stimulus();
        return $sformatf("data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b"
        ,data_in, rst_n, wr_en, rd_en);
    endfunction //convert2string_stimulus function


    //constraints
        constraint c{

            rst_n dist {0:/10 , 1:/90};                                 //reset is off 10% and on 90%
            wr_en dist {0:/(100-WR_EN_ON_DIST) , 1:/WR_EN_ON_DIST};     //write enable is on with the percantage of WR_EN_ON_DIST signal and off with 100-WR_EN_ON_DIST
            rd_en dist {0:/(100-RD_EN_ON_DIST) , 1:/RD_EN_ON_DIST};     //write enable is on with the percantage of RD_EN_ON_DIST signal and off with 100-RD_EN_ON_DIST
            
        } //constraint c

endclass //FIFO_sequence_item class
    
endpackage //FIFO_sequence_item package


    