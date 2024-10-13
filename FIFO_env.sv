////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_enviroment class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_env;

//package import
import uvm_pkg::*;
import FIFO_agent_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
`include "uvm_macros.svh";
    
    class FIFO_env extends uvm_env;

//factory registeration
    `uvm_component_utils(FIFO_env);

//object decleration
    FIFO_agent agent;
    FIFO_scoreboare sb;
    FIFO_coverge cov;

//functions
        function new (string name = "FIFO_env" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new function

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        //creat objects
            agent = FIFO_agent::type_id::create("agent",this);
            sb = FIFO_scoreboare::type_id::create("sb",this);     
            cov = FIFO_coverge::type_id::create("cov",this);
        endfunction //build_phase function

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        //TLM analysis port-export connection
            agent.agent_p.connect(sb.sb_exp);
            agent.agent_p.connect(cov.cov_exp);
        endfunction //connect_phase function
 
    endclass //FIFO_env

endpackage //FIFO_env package