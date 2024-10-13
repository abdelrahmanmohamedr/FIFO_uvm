////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_monitor class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_monitor_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

 class FIFO_monitor extends uvm_monitor;

//factory registeration
    `uvm_component_utils(FIFO_monitor)

//virtual interface decleration
    virtual FIFO_int FIFO_monitor_vif;

//object decleration
    FIFO_sequence_item seq_item;

//TLM analysis port decleration
    uvm_analysis_port #(FIFO_sequence_item) mon_p;

//functions
    function new(string name = "FIFO_monitor" , uvm_component parent = null);
        super.new(name,parent);
    endfunction //new function

    function void build_phase (uvm_phase phase);
       super.build_phase(phase);
    //monitor port creation
        mon_p = new("mon_p",this);
    endfunction //build_phase function

    task run_phase(uvm_phase phase);
        super.run_phase (phase);

        forever begin
    //object creation
            seq_item = FIFO_sequence_item::type_id::create("seq_item",this);
    //assigning the value of the interface to the sequence_item object
            @(negedge FIFO_monitor_vif.clk);
            seq_item.data_in = FIFO_monitor_vif.data_in;
            seq_item.rst_n = FIFO_monitor_vif.rst_n;
            seq_item.wr_en = FIFO_monitor_vif.wr_en;
            seq_item.rd_en = FIFO_monitor_vif.rd_en;
            seq_item.data_out = FIFO_monitor_vif.data_out;
            seq_item.wr_ack = FIFO_monitor_vif.wr_ack;
            seq_item.overflow = FIFO_monitor_vif.overflow;
            seq_item.full = FIFO_monitor_vif.full;
            seq_item.empty = FIFO_monitor_vif.empty;
            seq_item.almostfull = FIFO_monitor_vif.almostfull;
            seq_item.almostempty = FIFO_monitor_vif.almostempty;
            seq_item.underflow = FIFO_monitor_vif.underflow;
        //brodcasting the sequence_item object
            mon_p.write(seq_item);
            `uvm_info("run_phase",seq_item.convert2string(),UVM_MEDIUM);
        end 
    endtask //run_phase function

 endclass//FIFO_monitor class
    
endpackage //FIFO_monitor package