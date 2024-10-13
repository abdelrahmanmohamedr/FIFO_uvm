////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_main_sequence class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_main_sequence_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_main_sequence extends uvm_sequence #(FIFO_sequence_item);

//factory registeration
    `uvm_object_utils(FIFO_main_sequence);

//object decleration
    FIFO_sequence_item seq_item;

//functions
    function new(string name = "FIFO_main_sequence");
        super.new(name);
    endfunction //new function
    
    task body ();
    //sequence randomization
        repeat(10000)begin
            seq_item = FIFO_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert (seq_item.randomize()); 
            finish_item(seq_item);
        end
    endtask //body task

endclass //FIFO_main_sequence class

endpackage //FIFO_main_sequence package