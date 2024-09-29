import Transaction_pkg::* ; 
import shared_pkg_0::* ;

module FIFO_TB( FIFO_if.TEST FIFO_if_obj) ;
    
FIFO_transaction tr ;    
    initial 
    begin
        tr = new ;

        $display("##########################################################");
        $display("------------------------start simulation------------------");

        FIFO_if_obj.rst_n = 0 ;
        #18 ;
        FIFO_if_obj.rst_n = 1 ;
        

        // Write phase
        tr.constraint_mode(0);                
        tr.rst_n = 1 ; tr.wr_en = 1; tr.rd_en = 0;
        tr.rand_mode(0) ;
        tr.data_in.rand_mode(1);                     

        repeat (1000) 
        begin
            assertions_TB_wr : assert(tr.randomize);
            connect_if_to_class();
            #20;
        end

        // Read phase
        tr.constraint_mode(0);                
        tr.rst_n = 1 ; tr.wr_en = 0; tr.rd_en = 1;
        tr.rand_mode(0) ; 

        repeat (1000) 
        begin
            assertions_TB_rd : assert(tr.randomize);
            connect_if_to_class();
            #20;
        end

        tr.constraint_mode(1);
        tr.rand_mode(1); 

        repeat (10000) 
        begin   // Mixed
           assertions_TB_Mix: assert( tr.randomize ) ;
            connect_if_to_class();
            #20 ; 
        end

        test_finished = 1 ;

    end

function void connect_if_to_class();
    FIFO_if_obj.data_in  = tr.data_in; 
    FIFO_if_obj.rst_n    = tr.rst_n;
    FIFO_if_obj.wr_en    = tr.wr_en;
    FIFO_if_obj.rd_en    = tr.rd_en;
endfunction
endmodule