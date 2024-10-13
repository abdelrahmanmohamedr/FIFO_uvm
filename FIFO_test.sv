////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_test class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_test_pkg;

//package import
import uvm_pkg::*;
import FIFO_env::*;
import FIFO_config_obj::*;
import FIFO_main_sequence_pkg::*;
import FIFO_rst_sequence_pkg::*;
`include "uvm_macros.svh";

    class FIFO_test extends uvm_test;

//factory registeration
    `uvm_component_utils(FIFO_test);

//object decleration
    FIFO_env env;
    FIFO_config_obj FIFO_config_obj_test;
    FIFO_main_sequence seq;
    FIFO_rst_sequence seq2;

//functions
        function new(string name = "FIFO_test" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new function

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        //object creation
            env = FIFO_env::type_id::create("env",this);
            seq = FIFO_main_sequence::type_id::create("seq");
            seq2 = FIFO_rst_sequence::type_id::create("seq2");
            FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test",this);

        //getting the interface from the top
            uvm_config_db#(virtual FIFO_int)::get(this,"","interface",FIFO_config_obj_test.FIFO_config_vif);
        //setting the configuration object
            uvm_config_db#(FIFO_config_obj)::set(this,"*","interface_test",FIFO_config_obj_test);
            
        endfunction //build_phase function

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            seq2.start(env.agent.sequencer);     //starting the rst sequence driving
            `uvm_info("run_phase","finish first test",UVM_MEDIUM);
            seq.start(env.agent.sequencer);     //starting the main sequence driving
            `uvm_info("run_phase","finish second test",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask //run_phase task

    endclass //FIFO_test class

endpackage //FIFO_test package