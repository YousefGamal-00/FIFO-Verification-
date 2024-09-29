package coverage_pkg ;

import Transaction_pkg::* ;
    
class FIFO_coverage ;
FIFO_transaction F_cvg_txn  ;

covergroup code_cov ;

cross_coverage_full : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.full;

cross_coverage_empty : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.empty ;

cross_coverage_wr_ack : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.wr_ack ;

cross_coverage_overflow : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.overflow  ;

cross_coverage_underflow : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.underflow ;

cross_coverage_almostfull : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostfull ;

cross_coverage_almostempty : cross  F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostempty ;
 
endgroup    

 
function void sample_data(input FIFO_transaction F_txn) ;
    F_cvg_txn = F_txn; /* because the sampling is done for F_cvg_txn */
    code_cov.sample();
endfunction

function new();
F_cvg_txn = new ; /* create an object from transaction class */
code_cov  = new ; /* create an object from covergroup */
endfunction

endclass    
endpackage