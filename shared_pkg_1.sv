package Transaction_pkg ;

class FIFO_transaction  #(parameter FIFO_WIDTH = 16) ;
    
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit  rst_n, wr_en, rd_en;
logic  [FIFO_WIDTH-1:0] data_out;
logic  wr_ack, overflow;
logic  full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST ;
int WR_EN_ON_DIST ;

constraint rst_N_cons { rst_n dist {0:/5 , 1:/95 } ;}
constraint WR_EN_cons { wr_en dist {0:/(100-WR_EN_ON_DIST) , 1:/WR_EN_ON_DIST } ;}
constraint RD_EN_cons { rd_en dist {0:/(100-RD_EN_ON_DIST) , 1:/RD_EN_ON_DIST } ;}

function new ( int RD_EN_ON_DIST=30 , int WR_EN_ON_DIST=70 ) ;
    this.WR_EN_ON_DIST = WR_EN_ON_DIST ;    
    this.RD_EN_ON_DIST = RD_EN_ON_DIST ;    
endfunction

endclass
    
endpackage