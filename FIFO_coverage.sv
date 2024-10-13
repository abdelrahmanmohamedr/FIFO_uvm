////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_coverge class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_coverage_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_coverge extends uvm_component;

//factory registeration
    `uvm_component_utils(FIFO_coverge);

//object decleration
    FIFO_sequence_item seq_item;

//tlm analysis export-fifo decleration
    uvm_analysis_export #(FIFO_sequence_item) cov_exp;
    uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;

    //covergroup
        covergroup write;

        write_enable:                       coverpoint seq_item.wr_en{option.weight=0;}                                  //wr_en signal coverage
        overflow:                           coverpoint seq_item.overflow{option.weight=0;}                               //overflow signal coverage
        full:                               coverpoint seq_item.full{option.weight=0;}                                   //full signal coverage
        almostfull:                         coverpoint seq_item.almostfull{option.weight=0;}                             //almostfull signal coverage
        empty:                              coverpoint seq_item.empty{option.weight=0;}                                  //empty signal coverage
        almostempty:                        coverpoint seq_item.almostempty{option.weight=0;}                            //almostempty signal coverage
        underflow:                          coverpoint seq_item.underflow{option.weight=0;}                              //underflow signal coverage
        write_ack:                          coverpoint seq_item.wr_ack{option.weight=0;}                                 //wr_ack signal coverage

        write_enable_full_bins:             cross write_enable , full;                      //cross coverage between wr_en and full signals
        write_enable_almost_full_bins:      cross write_enable , almostfull;                //cross coverage between wr_en and almost full signals
        write_enable_empty_bins:            cross write_enable , empty;                     //cross coverage between wr_en and empty signals
        write_enable_almost_empty_bins:     cross write_enable , almostempty;               //cross coverage between wr_en and almost empty signals
        write_enable_overflow_bins:         cross write_enable , overflow {                 //cross coverage between wr_en and overflow signals
        ignore_bins writeenable0_overflow1 = binsof(write_enable) intersect {0} && binsof(overflow) intersect {1};
        }
        write_enable_underflow_bins:        cross write_enable , underflow;                 //cross coverage between wr_en and underflow signals
        write_enable_write_ack_bins:        cross write_enable , write_ack{                 //cross coverage between wr_en and wr_ack signals
        ignore_bins writeenable0_write_ack1 = binsof(write_enable) intersect {0} && binsof(write_ack) intersect {1};
        }

        endgroup //write enable covergroup

        covergroup read;

        read_enable:                        coverpoint seq_item.rd_en{option.weight=0;}                                  //rd_en signal coverage
        overflow:                           coverpoint seq_item.overflow{option.weight=0;}                               //overflow signal coverage
        full:                               coverpoint seq_item.full{option.weight=0;}                                   //full signal coverage
        almostfull:                         coverpoint seq_item.almostfull{option.weight=0;}                             //almostfull signal coverage
        empty:                              coverpoint seq_item.empty{option.weight=0;}                                  //empty signal coverage
        almostempty:                        coverpoint seq_item.almostempty{option.weight=0;}                            //almostempty signal coverage
        underflow:                          coverpoint seq_item.underflow{option.weight=0;}                              //underflow signal coverage
        write_ack:                          coverpoint seq_item.wr_ack{option.weight=0;}                                 //wr_ack signal coverage

        read_enable_full_bins:             cross read_enable , full{                      //cross coverage between rd_en and full signals
        ignore_bins readenable1_full1 = binsof(read_enable) intersect {1} && binsof(full) intersect {1};
        }
        read_enable_almost_full_bins:      cross read_enable , almostfull;                //cross coverage between rd_en and almost full signals
        read_enable_empty_bins:            cross read_enable , empty;                     //cross coverage between rd_en and empty signals
        read_enable_almost_empty_bins:     cross read_enable , almostempty;               //cross coverage between rd_en and almost empty signals
        read_enable_overflow_bins:         cross read_enable , overflow;                  //cross coverage between rd_en and overflow signals
        read_enable_underflow_bins:        cross read_enable , underflow{                 //cross coverage between rd_en and underflow signals
        ignore_bins readenable0_underflow1 = binsof(read_enable) intersect {0} && binsof(underflow) intersect {1};
        }
        read_enable_write_ack_bins:        cross read_enable , write_ack;                 //cross coverage between rd_en and wr_ack signals

        endgroup //write enable covergroup 

    function new(string name = "FIFO_coverge", uvm_component parent = null);
        super.new(name,parent);
        write = new();
        read = new();
    endfunction //new function

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        cov_exp = new("cov_exp",this);
        cov_fifo = new("cov_fifo",this);  
    endfunction //build_phase function

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        cov_exp.connect(cov_fifo.analysis_export);
    endfunction //connect_phase function

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item);
            write.sample();
            read.sample();
        end
    endtask //run_phase task

endclass //FIFO_coverge class

endpackage //FIFO_coverge package