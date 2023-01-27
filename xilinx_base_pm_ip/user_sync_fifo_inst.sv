            user_sync_fifo #(
                        .FIFO_MEMORY_TYPE     ("auto"           ),  //"block" or "distributed"
            	        .FIFO_READ_LATENCY    (0                ),  //(0~100)
                        .FIFO_WRITE_DEPTH     (FIFO_WRITE_DEPTH ),
            	        .WRITE_DATA_WIDTH     (READ_DATA_WIDTH  ),
						.PROG_FULL_THRESH     (PROG_FULL_THRESH )
                    )
             u0    (
                        .clk                  (clk              ),   // input                                             
                        .rst                  (rst              ),   // input                                             
                        .sclr                 (sclr             ),   // input                                             
                        .din                  (din              ),   // input           [WRITE_DATA_WIDTH-1 : 0]          
                        .rd_en                (rd_en            ),   // input                                             
                        .wr_en                (wr_en            ),   // input                                                                   
                        .dout                 (dout             ),   // output  wire    [READ_DATA_WIDTH-1  : 0]          
                        .empty                (empty            ),   // output  wire                                      
                        .full                 (full             ),   // output  wire                                      
                        .prog_full            (prog_full        ),   // output  reg  
                        .wr_ovf               (wr_ovf           ),   // output  reg  
                        .rd_ovf               (rd_ovf           ),   // output  reg  					
                        .wr_data_count        (wr_data_count    )	 // output  wire    [RD_DATA_COUNT_WIDTH-1  : 0]   
						); 