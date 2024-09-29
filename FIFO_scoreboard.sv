package Scoreboard_pkg ;

import shared_pkg_0::* ;
import Transaction_pkg::* ;

class FIFO_Scoreboard #(parameter FIFO_WIDTH = 16 , FIFO_DEPTH = 8 ) ;

logic [FIFO_WIDTH-1 : 0] data_out_ref ;

bit [$clog2(FIFO_DEPTH) : 0] counter ;              
int My_ref_Queue[$] ;           
FIFO_transaction F_tr = new();  

function void check_data(input FIFO_transaction F_tr);

    reference_model(F_tr);

        if (F_tr.data_out != data_out_ref)
        begin
            $display("At time = %0t , the output of the DUT (data_out = %0d) , doesn't Match with the Golden model output (data_out_ref = %0d)",$time,F_tr.data_out,data_out_ref);
            error_count++;
            $stop;
        end    
    else 
    begin
        correct_count++;
    end

endfunction

function void reference_model(input FIFO_transaction F_txn);
fork

    begin // first thread -> write operation
        if (!F_txn.rst_n) 
            begin
                My_ref_Queue.delete() ;
                counter <= 0 ;
            end   
        else
             begin
                if ( F_txn.wr_en && (counter < FIFO_DEPTH) ) 
                    begin  
                        My_ref_Queue.push_front(F_txn.data_in) ;
                    end                
             end         
    end   

    begin // second thread -> read operation
        if (F_txn.rst_n) 
        begin
            if ( F_txn.rd_en && (counter != 0) ) 
            begin  
                data_out_ref <= My_ref_Queue.pop_back() ;
            end
        end

    end   

    begin //  third thread -> Counter updating   
        if (!F_txn.rst_n) 
            counter <= 0;
        else 
            begin
                casex ({F_txn.wr_en, F_txn.rd_en, F_txn.full, F_txn.empty})
                    4'b11_01: // Both write and read enabled, FIFO empty
                        counter <= counter + 1; // Prioritize write if FIFO is empty

                    4'b11_10: // Both write and read enabled, FIFO full
                        counter <= counter - 1; // Prioritize read if FIFO is full

                    4'b10_0x: // Write enabled, not full
                        counter <= counter + 1;

                    4'b01_x0: // Read enabled, not empty
                        counter <= counter - 1;
                 endcase
            end
    end            
join
endfunction 

function new() ;
    error_count = 0 ;
    correct_count = 0 ;
endfunction

endclass
endpackage