////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_driver class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_driver;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
import FIFO_config_obj::*;
`include "uvm_macros.svh";

    class FIFO_driver extends uvm_driver #(FIFO_sequence_item);

    //factory registeration
        `uvm_component_utils(FIFO_driver);

    //virtual interface decleration
        virtual FIFO_int FIFO_driver_vif;

    //object decleration
        FIFO_sequence_item seq_item;

    //functions
        function new(string name = "FIFO_driver" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new function
        
        function void build_phase (uvm_phase phase);  
            super.build_phase(phase);
        endfunction //build_phase function

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
            //creating objects
                seq_item = FIFO_sequence_item::type_id::create("seq_item",this);
            //start requisting items
                seq_item_port.get_next_item(seq_item);                                      //request the next item
                FIFO_driver_vif.data_in = seq_item.data_in;
                FIFO_driver_vif.rst_n = seq_item.rst_n;
                FIFO_driver_vif.wr_en = seq_item.wr_en;
                FIFO_driver_vif.rd_en = seq_item.rd_en;
                @(negedge FIFO_driver_vif.clk);
                seq_item_port.item_done();                                                  //end the current item
                `uvm_info("run_phase",seq_item.convert2string_stimulus(),UVM_MEDIUM);
                #0;
            end
        endtask //run_phase function
        
    endclass //FIFO_driver class

endpackage //FIFO_driver package