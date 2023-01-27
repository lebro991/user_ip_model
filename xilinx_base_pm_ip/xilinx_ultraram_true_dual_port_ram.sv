`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        ruijie
// Engineer:       wangshan
// 
// Create Date:    16:42:00 20/09/2019 
// Design Name:    
// Module Name:    table_a_cell 
// Project Name:    
// Target Devices: S10GX2100F1760-2E
// Tool versions:  QUARTUS 19.2
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//delay 8clk 
module xilinx_ultraram_true_dual_port_ram # 
(
  parameter AWIDTH             = 18     , //17
  parameter DWIDTH             = 19     , //18
  parameter LEVEL              = 2      ,
  parameter INITAL             = 1      , // 1 : ram can be initaled after rst ;1 : ram cantnot be initaled after rst ;
  parameter INIT_VALUE         = 0      ,
  parameter MEMORY_PRIMITIVE   = "block"  //"auto"-Allow Vivado Synthesis to choose; "distributed"-Distributed memory; "block"-Block memory; "ultra"-Ultra RAM memory     
  
)
(
  input  wire                             clk                     ,  
  // Port A                                                       
  input  wire                             rsta                    ,  
  input  wire                             wea                     ,  
  input  wire                             regcea                  ,   
  (* dont_touch = "true" *)input  wire    mem_ena                 ,   
  input  wire   [DWIDTH-1:0]              dina                    ,  
  input  wire   [AWIDTH-1:0]              addra                   ,   
  output wire   [DWIDTH-1:0]              douta                   ,  
  // Port B                                                       
  input  wire                             rstb                    ,  
  input  wire                             web                     ,  
  input  wire                             regceb                  ,   
  (* dont_touch = "true" *)input  wire    mem_enb                 ,   
  input  wire   [DWIDTH-1:0]              dinb                    ,  
  input  wire   [AWIDTH-1:0]              addrb                   ,   
  output wire   [DWIDTH-1:0]              doutb                   ,
  output reg                              inital_done_falg = 1'b0 ,  
);

  wire   [DWIDTH-1:0]       s_douta                ;
  wire   [DWIDTH-1:0]       s_doutb                ;
  reg  [AWIDTH : 0]         uram_inital_cnt   = 'b0;
  wire                      s_wea   = 'b0 ;
  wire [DWIDTH-1:0]         s_dina  = 'b0 ;
  wire [AWIDTH - 1 : 0]     s_addra = 'b0 ;  
  
  localparam DEPTH       = 1 << AWIDTH        ;
  localparam MEMORY_SIZE = DWIDTH*DEPTH       ;
  //localparam LEVEL       = (DEPTH/4096) + 2   ;


  assign douta = s_douta ;
  assign doutb = s_doutb ;

generate if (INITAL == 1)begin
 
always@(posedge clk) begin 
    if(rsta)begin
        uram_inital_cnt <=  'b0;
	end
	else if(~ uram_inital_cnt[AWIDTH])begin 
       uram_inital_cnt <= uram_inital_cnt + 1'b1 ;
	end 
end 
always@(posedge clk) begin 
    if(rsta)begin
       inital_done_falg <=  1'b0;
	end
	else if(uram_inital_cnt[AWIDTH])begin 
       inital_done_falg  <= 1'b1 ;
	end 
end    
 
assign   s_wea   =    ~uram_inital_cnt[AWIDTH] |  wea ;
assign   s_dina  =   (~uram_inital_cnt[AWIDTH]) ? INIT_VALUE  :  dina ;
assign   s_addra =   (~uram_inital_cnt[AWIDTH]) ? uram_inital_cnt[AWIDTH- 1 : 0]  :  addra ;
end 
else begin 

assign   s_wea    =   wea      ;
assign   s_dina   =   dina     ;
assign   s_addra  =   addra    ;

end  
endgenerate 
  xpm_memory_tdpram #
  (
    .ADDR_WIDTH_A          ( AWIDTH           ),// DECIMAL
    .ADDR_WIDTH_B          ( AWIDTH           ),// DECIMAL
    .MEMORY_PRIMITIVE      ( MEMORY_PRIMITIVE ),// String  "auto"-Allow Vivado Synthesis to choose; "distributed"-Distributed memory; "block"-Block memory; "ultra"-Ultra RAM memory 
    .MEMORY_SIZE           ( MEMORY_SIZE      ),// DECIMAL
    .READ_DATA_WIDTH_A     ( DWIDTH           ),// DECIMAL
    .READ_DATA_WIDTH_B     ( DWIDTH           ),// DECIMAL
    .READ_LATENCY_A        ( LEVEL            ),// DECIMAL
    .READ_LATENCY_B        ( LEVEL            ),// DECIMAL
    .WRITE_DATA_WIDTH_A    ( DWIDTH           ),// DECIMAL
    .WRITE_DATA_WIDTH_B    ( DWIDTH           ),// DECIMAL
    .BYTE_WRITE_WIDTH_A    ( DWIDTH           ),
    .BYTE_WRITE_WIDTH_B    ( DWIDTH           ),
    .WRITE_MODE_A          ( "read_first"     ),// String Allowed values: no_change, read_first, write_first. Default value = no_change.
    .WRITE_MODE_B          ( "read_first"     ) // String Allowed values: no_change, read_first, write_first. Default value = no_change.
  )
  xpm_memory_tdpram_inst  
  (
    .douta                  ( s_douta   ), 
    .doutb                  ( s_doutb   ), 
    .addra                  ( s_addra   ), 
    .addrb                  ( addrb     ), 
    .clka                   ( clk       ), 
    .clkb                   ( clk       ), 
    .dina                   ( s_dina    ), 
    .dinb                   ( dinb      ), 
    .ena                    ( mem_ena   ),      
    .enb                    ( mem_enb   ),  
    .regcea                 ( regcea    ), 
    .regceb                 ( regceb    ), 
    .rsta                   ( rsta      ), 
    .rstb                   ( rstb      ), 
    .wea                    ( s_wea     ), 
    .web                    ( web       ), 
    .injectdbiterra         ( 1'b0      ),
    .injectdbiterrb         ( 1'b0      ),
    .injectsbiterra         ( 1'b0      ),
    .injectsbiterrb         ( 1'b0      ),
    .sleep                  ( 1'b0      )
  );

endmodule
