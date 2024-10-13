////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (top module)
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh";

module FIFO_top ();

//internal signals
    bit clk;

//clock generation
    initial begin
        clk = 0;
        forever begin
            #20;
            clk = ~clk;
        end
    end

//modules instantiation
    FIFO_int FIFOint(clk);                               //interface module
    FIFO FIFO(FIFOint);                                  //design module

    bind FIFO FIFO_assertions FIFOassertions (FIFOint);  //assertions module

//UVM_instantiate
    initial begin
        uvm_config_db#(virtual FIFO_int)::set(null,"*","interface",FIFOint);
        run_test("FIFO_test");
    end


endmodule