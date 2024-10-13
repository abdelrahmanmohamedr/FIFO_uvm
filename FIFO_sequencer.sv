////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_sequencer class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_sequencer_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_sequencer extends uvm_sequencer #(FIFO_sequence_item);

//factory registeration
    `uvm_component_utils(FIFO_sequencer);

//functions
    function new(string name = "FIFO_sequencer" , uvm_component parent = null);
        super.new(name,parent);
    endfunction //new function

endclass //FIFO_sequencer class
    
endpackage //FIFO_sequencer package