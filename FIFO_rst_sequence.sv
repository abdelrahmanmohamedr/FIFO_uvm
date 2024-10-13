////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_rst_sequence class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_rst_sequence_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_rst_sequence extends uvm_sequence #(FIFO_sequence_item);

//factory registeration
    `uvm_object_utils(FIFO_rst_sequence);

//object decleration
    FIFO_sequence_item seq_item;

//functions
    function new(string name = "FIFO_rst_sequence");
        super.new(name);
    endfunction //new function
    
    task body ();
    //sequence randomization
            seq_item = FIFO_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            finish_item(seq_item);
    endtask //body task

endclass //FIFO_rst_sequence class

endpackage //FIFO_rst_sequence package