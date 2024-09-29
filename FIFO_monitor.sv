import coverage_pkg::* ;      // import coverge package
import Scoreboard_pkg::* ;    // import scoreboard package
import Transaction_pkg::* ;   // import trnasaction package
import shared_pkg_0::* ;      // import shared package

module monitor (FIFO_if.monitor FIFO_if_obj) ;  
FIFO_transaction F_tr  ;
FIFO_Scoreboard  F_sb  ;
FIFO_coverage    F_cov ;
initial 
    begin
    F_tr  =  new() ;  // create an object of class FIFO_transaction
    F_sb  =  new() ;  // create an object of class FIFO_Scoreboard
    F_cov =  new() ;  // create an object of class FIFO_coverage

        forever 
        begin
                @(negedge FIFO_if_obj.clk) ;            
                connect_class_to_if() ; /* pass the randomized Data to class to get sampled and compared to golden model */
                fork
                    begin
                            F_cov.sample_data(F_tr)  ; /* Sample the data */
                    end

                    begin   
                            F_sb.check_data( F_tr ) ;   /* Compare with Golden Model */             
                    end
                join

                if( test_finished )
                begin
                    $display("correct count = 0d%0d" , correct_count);
                    $display("Error   count = 0d%0d" , error_count);
                    $display("Test finished, stopping simulation");
                    $display("------------------------END   simulation------------------");
                    $display("##########################################################");

                    $stop;
                end
                
        end    
    end

function void connect_class_to_if( );
    F_tr.data_in     = FIFO_if_obj.data_in; 
    F_tr.rst_n       = FIFO_if_obj.rst_n;
    F_tr.wr_en       = FIFO_if_obj.wr_en;
    F_tr.rd_en       = FIFO_if_obj.rd_en;
    F_tr.data_out    = FIFO_if_obj.data_out;
    F_tr.wr_ack      = FIFO_if_obj.wr_ack;
    F_tr.overflow    = FIFO_if_obj.overflow;
    F_tr.underflow   = FIFO_if_obj.underflow;
    F_tr.full        = FIFO_if_obj.full;
    F_tr.almostfull  = FIFO_if_obj.almostfull;
    F_tr.empty       = FIFO_if_obj.empty;
    F_tr.almostempty = FIFO_if_obj.almostempty;    
endfunction

endmodule