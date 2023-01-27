// | FIFO_MEMORY_TYPE     | String             | Allowed values: auto, block, distributed. Default value = auto.         |
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate the fifo memory primitive (resource type) to use.                                                         |
// |                                                                                                                     |
// |   "auto"- Allow Vivado Synthesis to choose                                                                          |
// |   "block"- Block RAM FIFO                                                                                           |
// |   "distributed"- Distributed RAM FIFO                                                                               |
// |                                                                                                                     |
// | NOTE: There may be a behavior mismatch if Block RAM or Ultra RAM specific features, like ECC or Asymmetry, are selected with FIFO_MEMORY_TYPE set to "auto".|
// |---------------------------------------------------------------------------------------------------------------------|
// | Number of output register stages in the read data path.                                                             |
// |                                                                                                                     |
// |   If READ_MODE = "fwft", then the only applicable value is 0.                                                       |
// +---------------------------------------------------------------------------------------------------------------------+
// | FIFO_WRITE_DEPTH     | Integer            | Range: 16 - 4194304. Default value = 2048.                              |
// |---------------------------------------------------------------------------------------------------------------------|
// | FIFO_READ_LATENCY    | Integer            | Range: 16 - 4194304. Default value = 2048.                              |
// |---------------------------------------------------------------------------------------------------------------------|
// | Defines the FIFO Write Depth, must be power of two.                                                                 |
// |                                                                                                                     |
// |   In standard READ_MODE, the effective depth = FIFO_WRITE_DEPTH-1                                                   |
// |   In First-Word-Fall-Through READ_MODE, the effective depth = FIFO_WRITE_DEPTH+1                                    |
// |                                                                                                                     |
// | NOTE: The maximum FIFO size (width x depth) is limited to 150-Megabits.                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | PROG_EMPTY_THRESH    | Integer            | Range: 3 - 4194301. Default value = 10.                                 |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specifies the minimum number of read words in the FIFO at or below which prog_empty is asserted.                    |
// |                                                                                                                     |
// |   Min_Value = 3 + (READ_MODE_VAL*2)                                                                                 |
// |   Max_Value = (FIFO_WRITE_DEPTH-3) - (READ_MODE_VAL*2)                                                              |
// |                                                                                                                     |
// | If READ_MODE = "std", then READ_MODE_VAL = 0; Otherwise READ_MODE_VAL = 1.                                          |
// | NOTE: The default threshold value is dependent on default FIFO_WRITE_DEPTH value. If FIFO_WRITE_DEPTH value is      |
// | changed, ensure the threshold value is within the valid range though the programmable flags are not used.           |
// +---------------------------------------------------------------------------------------------------------------------+
// | PROG_FULL_THRESH     | Integer            | Range: 5 - 4194301. Default value = 10.                                 |
// |---------------------------------------------------------------------------------------------------------------------|
// | RD_DATA_COUNT_WIDTH  | Integer            | Range: 1 - 23. Default value = 1.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specifies the width of rd_data_count. To reflect the correct value, the width should be log2(FIFO_READ_DEPTH)+1.    |
// |                                                                                                                     |
// |   FIFO_READ_DEPTH = FIFO_WRITE_DEPTH*WRITE_DATA_WIDTH/READ_DATA_WIDTH                                               |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_DATA_WIDTH      | Integer            | Range: 1 - 4096. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Defines the width of the read data port, dout                                                                       |
// |                                                                                                                     |
// |   Write and read width aspect ratio must be 1:1, 1:2, 1:4, 1:8, 8:1, 4:1 and 2:1                                    |
// |   For example, if WRITE_DATA_WIDTH is 32, then the READ_DATA_WIDTH must be 32, 64,128, 256, 16, 8, 4.               |
// |                                                                                                                     |
// | NOTE:                                                                                                               |
// |                                                                                                                     |
// |   READ_DATA_WIDTH should be equal to WRITE_DATA_WIDTH if FIFO_MEMORY_TYPE is set to "auto". Violating this may result incorrect behavior. |
// |   The maximum FIFO size (width x depth) is limited to 150-Megabits.                                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_MODE            | String             | Allowed values: std, fwft. Default value = std.                         |
// |---------------------------------------------------------------------------------------------------------------------|
// |                                                                                                                     |
// |   "std"- standard read mode                                                                                         |
// |   "fwft"- First-Word-Fall-Through read mode                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_DATA_WIDTH     | Integer            | Range: 1 - 4096. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Defines the width of the write data port, din                                                                       |
// |                                                                                                                     |
// |   Write and read width aspect ratio must be 1:1, 1:2, 1:4, 1:8, 8:1, 4:1 and 2:1                                    |
// |   For example, if WRITE_DATA_WIDTH is 32, then the READ_DATA_WIDTH must be 32, 64,128, 256, 16, 8, 4.               |
// |                                                                                                                     |
// | NOTE:                                                                                                               |
// |                                                                                                                     |
// |   WRITE_DATA_WIDTH should be equal to READ_DATA_WIDTH if FIFO_MEMORY_TYPE is set to "auto". Violating this may result incorrect behavior. |
// |   The maximum FIFO size (width x depth) is limited to 150-Megabits.                                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | WR_DATA_COUNT_WIDTH  | Integer            | Range: 1 - 23. Default value = 1.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specifies the width of wr_data_count. To reflect the correct value, the width should be log2(FIFO_WRITE_DEPTH)+1.   |
// +---------------------------------------------------------------------------------------------------------------------+
`timescale 1ns / 1ps


module user_sync_fifo#(
        parameter   FIFO_MEMORY_TYPE     =  "auto"                         , //"block"  "distributed"       
	    parameter   FIFO_READ_LATENCY    =  0                              , //(0~100)
        parameter   FIFO_WRITE_DEPTH     =  2048                           , 
	    parameter   PROG_FULL_THRESH     =  FIFO_WRITE_DEPTH - 3           , 
	    parameter   DATA_WIDTH           =  32                             , 
	    parameter   WR_DATA_COUNT_WIDTH  =  ($clog2(FIFO_WRITE_DEPTH) + 1) 
    )
    (
        input                                             clk             ,
        input                                             rst             ,
        input                                             sclr            ,
        input           [DATA_WIDTH-1 : 0]                din             ,
        input                                             rd_en           ,
        input                                             wr_en           ,                         
        //output 
        output  wire    [DATA_WIDTH-1  : 0]               dout            ,
        output  wire                                      empty           ,
        output  wire                                      full            ,
        output  wire                                      prog_full       ,
        output  reg                                       wr_ovf          ,
        output  reg                                       rd_ovf          ,
        output  wire    [WR_DATA_COUNT_WIDTH-1  : 0]      wr_data_count    
        
    ); 

    always @ (posedge clk)begin 
        if(sclr)begin 
            wr_ovf   <= 1'b0;
        end
        else if(full & wr_en) begin 
            wr_ovf   <= 1'b1;             
        end 		
    end	
    always @ (posedge clk)begin 
        if(sclr)begin 
            rd_ovf   <= 1'b0;
        end
        else if(empty & rd_en) begin 
            rd_ovf   <= 1'b1;             
        end 		
    end		
	
            sync_fifo #(
                        .FIFO_MEMORY_TYPE     (FIFO_MEMORY_TYPE ),  //"block" or "distributed"
            	        .FIFO_READ_LATENCY    (FIFO_READ_LATENCY),
                        .FIFO_WRITE_DEPTH     (FIFO_WRITE_DEPTH ),
            	        .WRITE_DATA_WIDTH     (DATA_WIDTH       ),
						.PROG_FULL_THRESH     (PROG_FULL_THRESH ),						
            	        .READ_MODE            (READ_MODE        )   //or "std"
                    )
             u0    (
                        .clk                  (clk              ),   // input                                             
                        .rst                  (rst              ),   // input                                             
                        .din                  (din              ),   // input           [WRITE_DATA_WIDTH-1 : 0]          
                        .rd_en                (rd_en            ),   // input                                             
                        .wr_en                (wr_en            ),   // input                                                                   
                        .dout                 (dout             ),   // output  wire    [READ_DATA_WIDTH-1  : 0]          
                        .empty                (empty            ),   // output  wire                                      
                        .full                 (full             ),   // output  wire                                      
                        .prog_full            (prog_full        ),   // output  reg  					
                        .wr_data_count        (wr_data_count    )	 // output  wire    [RD_DATA_COUNT_WIDTH-1  : 0]   
						); 
						
						
endmodule 