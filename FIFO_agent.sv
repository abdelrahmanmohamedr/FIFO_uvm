////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (agent class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_agent_pkg;

//package import
import uvm_pkg::*;
import FIFO_sequencer_pkg::*;
import FIFO_monitor_pkg::*;
import FIFO_driver::*;
import FIFO_config_obj::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh";

class FIFO_agent extends uvm_agent;

//factory registeration
    `uvm_component_utils(FIFO_agent);

//objects decleration
    FIFO_driver driver;
    FIFO_sequencer sequencer;
    FIFO_monitor monitor;
    FIFO_config_obj FIFO_config_obj_agent;

//analysis_port decleration
    uvm_analysis_port #(FIFO_sequence_item) agent_p;

//functions
    function new(string name = "FIFO_agent" , uvm_component parent = null);
        super.new(name,parent);
    endfunction //new function

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    //agent port creation
        agent_p = new("agent_p",this);
    //creating objects
        driver = FIFO_driver::type_id::create("driver",this);
        monitor = FIFO_monitor::type_id::create("monitor",this);
        sequencer = FIFO_sequencer::type_id::create("sequencer",this);
        FIFO_config_obj_agent = FIFO_config_obj::type_id::create("FIFO_config_obj_agent",this);
    //getting the configuration object (interface)
        uvm_config_db#(FIFO_config_obj)::get(this,"","interface_test",FIFO_config_obj_agent);

    endfunction //build_phase function

    function void connect_phase (uvm_phase phase);
        super.connect_phase (phase);
    
    //TLM port-export connection
        driver.seq_item_port.connect(sequencer.seq_item_export);
    //interface connection
        driver.FIFO_driver_vif = FIFO_config_obj_agent.FIFO_config_vif;
        monitor.FIFO_monitor_vif = FIFO_config_obj_agent.FIFO_config_vif;
    //TLM analysis port-port connection
        monitor.mon_p.connect(agent_p);
    endfunction //connect_phase function

endclass //FIFO_agent class
    
endpackage //FIFO_agent package