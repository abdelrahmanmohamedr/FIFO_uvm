////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_scoreboard class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_scoreboard_pkg;
    
//package import
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_scoreboare extends uvm_scoreboard;

//factory registeration
    `uvm_component_utils(FIFO_scoreboare);

//parameters
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

//internal signals
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
    logic [max_fifo_addr-1:0] wr_ptr, rd_ptr; 
    logic [max_fifo_addr:0] count;

    int correct_case = 0;
    int wrong_case = 0;


//objects decleration
    FIFO_sequence_item seq_item;

//tlm export-fifo decleration
    uvm_analysis_export #(FIFO_sequence_item) sb_exp;
    uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;


//functions
    function new(string name = "FIFO_scoreboare" , uvm_component parent = null);
        super.new(name,parent);
    endfunction //new function

    function void build_phase (uvm_phase phase);
    super.build_phase(phase);
//scoreboard export-TLM_fifo creation 
    sb_exp = new("sb_exp",this);
    sb_fifo = new("sb_fifo",this);   
    endfunction //build_phase function

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
    //scoreboard export and scoreboard TLM_fifo connection
        sb_exp.connect(sb_fifo.analysis_export);
    endfunction //connect_phase function

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item);      //receving the sequence_item from the monitor
            golden_ref(seq_item);       //golden reference task instantiation

        //checking the value
            if ((data_out_ref === seq_item.data_out) && (wr_ack_ref === seq_item.wr_ack) && 
            (overflow_ref === seq_item.overflow) && (full_ref === seq_item.full) && (empty_ref === seq_item.empty) && 
            (almostfull_ref === seq_item.almostfull) && (almostempty_ref === seq_item.almostempty) && (underflow_ref === seq_item.underflow)) begin
                correct_case++;
                `uvm_info("run_phase",$sformatf("correct case = %0d , wrong case = %0d , time = %0d",correct_case,wrong_case,$time),UVM_MEDIUM);
            end else begin
                wrong_case++;
                `uvm_error("run_phase",$sformatf("correct case = %0d , wrong case = %0d , time = %0d , %0s , data_out_ref = %0b , wr_ack_ref = %0b ,overflow_ref = %0b ,full_ref = %0b ,empty_ref = %0b,almostfull_ref = %0b,almostempty_ref = %0b,underflow_ref = %0b  ",
                correct_case,wrong_case,$time,seq_item.convert2string(),data_out_ref,wr_ack_ref, overflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref));
            end
        end
    endtask //run_phase task

    function void golden_ref (FIFO_sequence_item seq_item);
        
    //write if-condition
	    if (!seq_item.rst_n) begin
	    	wr_ptr = 0;
            overflow_ref = 0;
            wr_ack_ref = 0;
	    end
	    else if (seq_item.wr_en && !full_ref) begin
	    	mem[wr_ptr] = seq_item.data_in;
	    	wr_ack_ref = 1;
	    	wr_ptr = wr_ptr + 1;
            overflow_ref = 0;
	    end
	    else begin 
	    	wr_ack_ref = 0; 
	    	if (full_ref && seq_item.wr_en)
	    		overflow_ref = 1;
	    	else
	    		overflow_ref = 0;
	    end


    //read if-condition
	    if (!seq_item.rst_n) begin
	    	rd_ptr = 0;
            underflow_ref = 0;
	    end
	    else if (seq_item.rd_en && !empty_ref) begin
	    	data_out_ref = mem[rd_ptr];
	    	rd_ptr = rd_ptr + 1;
            underflow_ref = 0;
        end else begin
            if (empty_ref && seq_item.rd_en) begin
                underflow_ref = 1;
            end else begin
                underflow_ref = 0;
            end
        end

    //count if-condition
	    if (!seq_item.rst_n) begin
	    	count = 0;
	    end
	    else begin
            if (seq_item.wr_en && seq_item.rd_en && !full_ref && !empty_ref) 
                count <= count; 
            else if	(seq_item.wr_en && !full_ref)
	    		count = count + 1;
	    	else if (seq_item.rd_en && !empty_ref)
	    		count = count - 1;
	    end

    //FIFO-state decleration
        full_ref =(count == seq_item.FIFO_DEPTH)? 1 : 0;
        empty_ref =(count == 0)? 1 : 0;
        almostfull_ref =(count == seq_item.FIFO_DEPTH-1)? 1 : 0; 
        almostempty_ref =(count == 1)? 1 : 0;
        
    endfunction //golden refrence function

    function void report_phase (uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("correct case = %0d , wrong case = %0d",correct_case,wrong_case),UVM_MEDIUM);
    endfunction 

endclass //FIFO_scoreboare 

endpackage //FIFO_scoreboare package