////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO module (assertions))
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO_assertions (FIFO_int.DUT FIFOint);

//assertions
    always_comb begin
    	if (!FIFOint.rst_n) begin
    		reseta: assert final((!FIFO.wr_ptr) && (!FIFO.rd_ptr) && (!FIFO.count) && (!FIFOint.overflow) && (!FIFOint.underflow) && (!FIFOint.wr_ack));																				//reset assertion
    	end
    end

    always_comb begin
    	fulla: assert final(FIFOint.full == (FIFO.count == FIFOint.FIFO_DEPTH)? 1 : 0);																																				    //full assertion
    	almostfulla: assert final(FIFOint.almostfull == (FIFO.count == FIFOint.FIFO_DEPTH-1)? 1 : 0);																																    //almostfull assertion
    	emptya: assert final(FIFOint.empty == (FIFO.count == 0)? 1 : 0);																																								//emprt assertion
    	almostemptya: assert final(FIFOint.almostempty == (FIFO.count == 1)? 1 : 0);																																				    //almostempty assertion
    end

    property overflowa;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.full) && $past(FIFOint.wr_en) && $past(FIFOint.rst_n)) |-> FIFOint.overflow																			        //overflow property
    endproperty

    property underflowa;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.empty) && $past(FIFOint.rd_en) && $past(FIFOint.rst_n)) |-> FIFOint.underflow																		        //underflow property
    endproperty

    property wr_acka;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && $past(FIFO.count) < FIFOint.FIFO_DEPTH && $past(FIFOint.rst_n)) |-> (FIFOint.wr_ack)															    //wr_ack property
    endproperty

    property wr_ptra;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && $past(FIFO.count) < FIFOint.FIFO_DEPTH && $past(FIFOint.rst_n)) |-> (FIFO.wr_ptr == $past(FIFO.wr_ptr) + 1'b1)									    //wr_ptr property
    endproperty

    property rd_prta;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.rd_en) && $past(FIFO.count) != 0 && $past(FIFOint.rst_n)) |-> FIFO.rd_ptr == $past(FIFO.rd_ptr) + 1'b1														//rd_ptr property
    endproperty

    property count_constant;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && !$past(FIFOint.full) && $past(FIFOint.rd_en) && !$past(FIFOint.empty) && $past(FIFOint.rst_n)) |-> FIFO.count == $past(FIFO.count)			        //count_constant property
    endproperty

    property count_incrementa;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && !$past(FIFOint.full) && !$past(FIFOint.rd_en) && $past(FIFOint.rst_n)) |-> FIFO.count == $past(FIFO.count) + 1'b1									//count_increment property
    endproperty

    property count_decrementa;
    	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) (!$past(FIFOint.wr_en) && $past(FIFOint.rd_en) && !$past(FIFOint.empty) && $past(FIFOint.rst_n)) |-> FIFO.count == $past(FIFO.count) - 1'b1									//count_decrement property
    endproperty

    assert property (overflowa);				//overflow property assertion
    cover property  (overflowa);				//overflow property cover

    assert property (underflowa);				//underflow property assertion
    cover property  (underflowa);				//underflow property cover

    assert property (wr_acka);					//wr_ack property assertion
    cover property  (wr_acka);					//wr_ack property cover

    assert property (wr_ptra);					//wr_ptr property assertion
    cover property  (wr_ptra);					//wr_ptr property cover

    assert property (rd_prta);					//rd_ptr property assertion
    cover property  (rd_prta);					//rd_ptr property cover

    assert property (count_incrementa);			//count_increment property assertion	
    cover property  (count_incrementa);			//count_increment property cover

    assert property (count_decrementa);			//count_decrement property assertion
    cover property  (count_decrementa);			//count_decrement property cover

endmodule
