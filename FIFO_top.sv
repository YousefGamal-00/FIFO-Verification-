module FIFO_top ;
    bit clk ;  // Clock signal

    // Initial block to generate the clock signal
    initial 
    begin
        clk = 0 ;  // Initialize clock to 0
        forever 
        begin
            #10 clk = ~clk ;  // Toggle clock every 10 time units
        end    
    end

    // Instantiate the FIFO interface
    FIFO_if FIFO_if_obj(clk) ;

    // Instantiate the FIFO design under test (DUT)
    FIFO DUT (FIFO_if_obj) ;

    // Instantiate the FIFO testbench
    FIFO_TB TB (FIFO_if_obj) ;

    // Instantiate a monitor for observing signals
    monitor monitor_obj (FIFO_if_obj) ;
endmodule
