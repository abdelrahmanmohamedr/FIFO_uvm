////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO_config_obj class)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_config_obj;

//package import
import uvm_pkg::*;
`include "uvm_macros.svh";

     class FIFO_config_obj extends uvm_object;
     
    //factory registeration
        `uvm_object_utils(FIFO_config_obj);
    
    //virtual interface decleration
        virtual FIFO_int FIFO_config_vif;

    //functions
        function new(string name = "FIFO_config_obj");
            super.new(name);
        endfunction //new function

    endclass //FIFO_config_obj class
    
endpackage //FIFO_config_obj package