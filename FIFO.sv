////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO( FIFO_if.DUT FIFO_if_obj );

/*-------------------------------------------internal signals-------------------------------------------*/
localparam max_fifo_addr = $clog2(FIFO_if_obj.FIFO_DEPTH);
reg [FIFO_if_obj.FIFO_WIDTH-1 : 0] mem [FIFO_if_obj.FIFO_DEPTH-1 : 0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count; 

/*-----------------------------------------------------------------------------------*/
logic rst_n, wr_en, rd_en , wr_ack ;
logic full, empty, almostfull, almostempty, underflow , overflow ;

assign full = FIFO_if_obj.full ;
assign empty = FIFO_if_obj.empty ;
assign almostempty = FIFO_if_obj.almostempty ;
assign almostfull = FIFO_if_obj.almostfull ;
assign overflow = FIFO_if_obj.overflow ;
assign underflow = FIFO_if_obj.underflow ;
assign rst_n = FIFO_if_obj.rst_n ;
assign wr_en = FIFO_if_obj.wr_en ;
assign rd_en = FIFO_if_obj.rd_en ;
assign wr_ack = FIFO_if_obj.wr_ack ;

/*-------------------------------------------assertions-------------------------------------------*/
`ifdef SIM
always_comb 
begin
if( !rst_n )
begin
	assert_reset_falgs:  assert final ( !full && empty && !almostempty && !almostfull  ) ;
	cover_reset_falgs :  cover ( !full && empty && !almostempty && !almostfull  ) ;
end
else 
begin
		if( count == 0 )
		begin
			assert_empty: assert (!full && empty && !almostempty && !almostfull ) ; 
			cover_empty : cover  (!full && empty && !almostempty && !almostfull ) ; 			
		end

		else if( count == FIFO_if_obj.FIFO_DEPTH )
		begin
			assert_full: assert (full && !empty && !almostempty && !almostfull ) ; 
			cover_full : cover  (full && !empty && !almostempty && !almostfull) ; 			
		end

		else if( count == (FIFO_if_obj.FIFO_DEPTH - 1'b1) )
		begin
			assert_almostfull: assert (!full && !empty && !almostempty && almostfull) ; 
			cover_almostfull : cover  (!full && !empty && !almostempty && almostfull) ; 
		end

		else if( count == 1'b1 )
		begin
			assert_almostempty: assert (!full && !empty && almostempty && !almostfull) ; 
			cover_almostempty : cover  (!full && !empty && almostempty && !almostfull) ; 
		end
end
end

property RD_ptr;
	@(posedge FIFO_if_obj.clk) disable iff(!rst_n) (rd_en && (count != 0) && rd_ptr < 7 ) |=> ( (rd_ptr == ($past(rd_ptr) + 1)) % FIFO_if_obj.FIFO_DEPTH );
endproperty

property WR_ptr;
	@(posedge FIFO_if_obj.clk) disable iff(!rst_n) (wr_en && (count < FIFO_if_obj.FIFO_DEPTH) && wr_ptr < 7) |=> ((wr_ptr == ($past(wr_ptr) + 1)) % FIFO_if_obj.FIFO_DEPTH);
endproperty

property prop_overflow ;
	@(posedge FIFO_if_obj.clk) disable iff (!rst_n) (wr_en && full) |=> (overflow) ;
endproperty

property prop_underflow ;
	@(posedge FIFO_if_obj.clk) disable iff (!rst_n) (rd_en && empty) |=> (underflow) ;
endproperty

property wr_ack_1 ;
	@(posedge FIFO_if_obj.clk) disable iff (!rst_n) (wr_en && ! full) |=> (wr_ack) ;
endproperty

property wr_ack_0 ;
	@(posedge FIFO_if_obj.clk) disable iff (!rst_n) (wr_en && full) |=> !(wr_ack) ;
endproperty

RD_PTR_assert : assert property (RD_ptr);
RD_PTR_cover  : cover  property (RD_ptr);

WR_PTR_assert : assert property (WR_ptr);
WR_PTR_cover  : cover  property (WR_ptr);


assert_overflow : assert property (prop_overflow) ; 
cover_overflow  : cover  property (prop_overflow) ; 

assert_underflow : assert property (prop_underflow) ; 
cover_underflow  : cover  property (prop_underflow) ; 

assert_wr_ack_1 : assert property (wr_ack_1) ; 
cover_wr_ack_1  : cover  property (wr_ack_1) ; 

assert_wr_ack_0 : assert property (wr_ack_0) ; 
cover_wr_ack_0  : cover  property (wr_ack_0) ; 

`endif 

always @(posedge FIFO_if_obj.clk or negedge FIFO_if_obj.rst_n) 
begin
	if (!FIFO_if_obj.rst_n) 
		begin
			wr_ptr <= 0;
			FIFO_if_obj.overflow <= 0; /* added to cleared with reset */ 
			FIFO_if_obj.wr_ack <= 0;   /* added to cleared with reset */
		end
	else if (FIFO_if_obj.wr_en && count < FIFO_if_obj.FIFO_DEPTH) 
		begin
			mem[wr_ptr] <= FIFO_if_obj.data_in;
			FIFO_if_obj.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			FIFO_if_obj.overflow <= 0; /* added to be cleared if we already write in FIFO */
		end
	else 
		begin 
			FIFO_if_obj.wr_ack <= 0; 
			if (FIFO_if_obj.full & FIFO_if_obj.wr_en)
				FIFO_if_obj.overflow <= 1;
			else
				FIFO_if_obj.overflow <= 0;
		end
end

always @(posedge FIFO_if_obj.clk or negedge FIFO_if_obj.rst_n) 
begin
	if (!FIFO_if_obj.rst_n) 
		begin
			rd_ptr <= 0;
			FIFO_if_obj.underflow <= 0; /* added to cleared with reset */
		end
	else if (FIFO_if_obj.rd_en && (count != 0) ) 
		begin
			FIFO_if_obj.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			FIFO_if_obj.underflow <= 0; /* added to be cleared if we already read from FIFO */
		end
	else  /* added to be sequential output not combinational */
		if (FIFO_if_obj.empty && FIFO_if_obj.rd_en)
			FIFO_if_obj.underflow <= 1;
		else
			FIFO_if_obj.underflow <= 0;
end

// always block specialized for counter signal
always @(posedge FIFO_if_obj.clk or negedge FIFO_if_obj.rst_n) 
begin
	if (!FIFO_if_obj.rst_n) 
		count <= 0;
	else if (FIFO_if_obj.wr_en && FIFO_if_obj.rd_en) 
		begin
			if (FIFO_if_obj.empty) 
				count <= count + 1;  /* Prioritize write if FIFO is empty */

			else if (FIFO_if_obj.full) 
				count <= count - 1;  /* Prioritize read if FIFO is full */
		end
	else if( FIFO_if_obj.wr_en && !FIFO_if_obj.full ) 
		     	count <= count + 1;

	else if ( FIFO_if_obj.rd_en && !FIFO_if_obj.empty )
				count <= count - 1;

	end

assign FIFO_if_obj.full = (count == FIFO_if_obj.FIFO_DEPTH)? 1 : 0;
assign FIFO_if_obj.empty = (count == 0)? 1 : 0;
assign FIFO_if_obj.almostfull = (count == FIFO_if_obj.FIFO_DEPTH-1)? 1 : 0; /* adjusted to be FIFO_DEPTH-1 */
assign FIFO_if_obj.almostempty = (count == 1)? 1 : 0;

endmodule