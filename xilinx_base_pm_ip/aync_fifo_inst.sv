            aync_fifo #(
                        .FIFO_MEMORY_TYPE     ("auto"           ),  //"block" or "distributed"
            	        .FIFO_READ_LATENCY    (0                ),
                        .FIFO_WRITE_DEPTH     (FIFO_WRITE_DEPTH ),
            	        .WRITE_DATA_WIDTH     (READ_DATA_WIDTH  ),
						.PROG_FULL_THRESH     (PROG_FULL_THRESH )						
                    )
             u0    (
                        .wr_clk               (wr_clk           ),   // input                                             
                        .rd_clk               (rd_clk           ),   // input                                             
                        .rst                  (rst              ),   // input                                             
                        .din                  (din              ),   // input           [WRITE_DATA_WIDTH-1 : 0]          
                        .rd_en                (rd_en            ),   // input                                             
                        .wr_en                (wr_en            ),   // input                                                                   
                        .dout                 (dout             ),   // output  wire    [READ_DATA_WIDTH-1  : 0]          
                        .empty                (empty            ),   // output  wire                                      
                        .full                 (full             ),   // output  wire                                      
                        .prog_full            (prog_full        ),   // output  wire 
                        .overflow             (overflow         ),	 // output  wire 					
                        .underflow            (underflow        ),	 // output  wire 					
                        .wr_data_count        (wr_data_count    )	 // output  wire    [RD_DATA_COUNT_WIDTH-1  : 0]   
						); 