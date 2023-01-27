

// XPM_MEMORY instantiation template for Simple Dual Port RAM configurations
// Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
// =======================================================================================================================

// Parameter usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Parameter name       | Data type          | Restrictions, if applicable                                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// |operation_mode       | string           |    "SINGLE_PORT", "DUAL_PORT", "BIDIR_DUAL_PORT", or "ROM"                 |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specifies the operation of the RAM. Values are "SINGLE_PORT", "DUAL_PORT", "BIDIR_DUAL_PORT", or "ROM".             |
// | If omitted, the default is "BIDIR_DUAL_PORT".                                                                       |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// |numwords_a           | integer           |                                                                           |
// |numwords_b           |                   |                                                                           |
// |---------------------------------------------------------------------------------------------------------------------|
// | Number of words stored in memory. If omitted, the default is 256                                                    |  
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// |width_a              | integer           |                                                                           |
// |width_b              |                   |   the WIDTH_B parameter is required.  the default is "16".                |
// |---------------------------------------------------------------------------------------------------------------------|
// | 	Specifies the width of the data_b[] input port. When the OPERATION_MODE parameter is set to "DUAL_PORT" mode,    |  
// +---------------------------------------------------------------------------------------------------------------------+ 	
// +---------------------------------------------------------------------------------------------------------------------+
// |INIT_FILE            | String            |                                                                           |
// |---------------------------------------------------------------------------------------------------------------------|
// | 	The default is "UNUSED"  ,if you use this parameter ,the format is "reg.mif"                                     |  
// +---------------------------------------------------------------------------------------------------------------------+ 	
// +---------------------------------------------------------------------------------------------------------------------+
// |ram_block_type       | String            |                                                                           |
// |---------------------------------------------------------------------------------------------------------------------|
// | 	Specifies the RAM block type. Values are "M20K", or "AUTO".                                                      |  
// +---------------------------------------------------------------------------------------------------------------------+ 

// xpm_memory_sdpram : In order to incorporate this function into the design,
//      Verilog      : the following instance declaration needs to be placed
//     instance      : in the body of the design code.  The instance name
//    declaration    : (xpm_memory_sdpram_inst) and/or the port declarations within the
//       code        : parenthesis may be changed to properly reference and
//                   : connect this function to the design.  All inputs
//                   : and outputs must be connected.

//  Please reference the appropriate libraries guide for additional information on the XPM modules.

//  <-----Cut code below this line---->

   // xpm_memory_sdpram: Simple Dual Port RAM
   // Xilinx Parameterized Macro, version 2021.1
   
module  xpm_sdpram_with_initial#(
            parameter   RAM_WIDTH  = 72                   ,
            parameter   RAM_DEPTH  = 128                  ,
            parameter   LAYTENCY   = 2                    ,
            parameter   INIT_VALUE = {RAM_WIDTH{1'b0}}    ,
            parameter   INIT       = 1                    ,
            parameter   INIT_FILE  = "UNUSED"             ,
            parameter   RAM_STYLE  = "M20K"               ,  //"M20K" "AUTO"
            parameter   ADDR_WIDTH = $clog2(RAM_DEPTH)        			  			
            
         )
         (
		 input                              clk            ,
		 input                              rst            ,
		 input       [RAM_WIDTH - 1  :0]    dina           ,
		 input       [ADDR_WIDTH - 1 :0]    addra          ,
		 input                              wea            ,
		 output      [RAM_WIDTH - 1  :0]    doutb          ,
		 input       [ADDR_WIDTH - 1 :0]    addrb	       ,
         output reg                         initial_done		 
		 
         );   
parameter   OPERATION_MODE   =   "DUAL_PORT"      ;

		 
    reg  [ADDR_WIDTH : 0 ]   	     initial_cnt = 'd0  ;    
    wire                             s_wea              ;
    wire [RAM_WIDTH - 1 : 0 ]        s_dina             ;
    wire [ADDR_WIDTH - 1 : 0 ]       s_addra            ; 	

    generate if (INIT == 1)begin	
	     	
        always@(posedge clk) begin 
            if(rst)begin
                initial_cnt <=  'b0;
        	end
        	else if(~ initial_done )begin 
                initial_cnt <= initial_cnt + 1'b1 ;
        	end 
        end 
        always@(posedge clk) begin 
            if(rst)begin
                initial_done  <=  1'b0;
        	end
        	else if(initial_cnt[ADDR_WIDTH])begin 
                initial_done  <= 1'b1 ;
        	end 
        end      
        
        // assign   s_wea   =   ((~initial_cnt[ADDR_WIDTH])&(~rst)) |  wea ;
        assign   s_wea   =   (~initial_done) |  wea ;
        assign   s_dina  =   (~initial_done) ? INIT_VALUE  :  dina ;
        assign   s_addra =   (~initial_done) ? initial_cnt[ADDR_WIDTH - 1 : 0]  :  addra ;    
		
    end 
    else begin 
        assign   s_wea    =   wea      ;
        assign   s_dina   =   dina     ;
        assign   s_addra  =   addra    ;
    end     	
	endgenerate 	 

    altera_syncram  altera_syncram_component (
                .address_a      ({1'b0,s_addra}   ),
                .address_b      ({1'b0,addrb  }   ),
                .clock0         (clk              ),
                .clock1         (clk              ),
                .data_a         (s_dina           ),
                .wren_a         (s_wea            ),
                .q_b            (doutb            ),
                .aclr0          (1'b0             ),
                .aclr1          (1'b0             ),
                .address2_a     (1'b1             ),
                .address2_b     (1'b1             ),
                .addressstall_a (1'b0             ),
                .addressstall_b (1'b0             ),
                .byteena_a      (1'b1             ),
                .byteena_b      (1'b1             ),
                .clocken0       (1'b1             ),
                .clocken1       (1'b1             ),
                .clocken2       (1'b1             ),
                .clocken3       (1'b1             ),
                .data_b         ({RAM_WIDTH{1'b1}}),
                .eccencbypass   (1'b0             ),
                .eccencparity   ( 'b0             ),
                .eccstatus      (                 ),
                .q_a            (                 ),
                .rden_a         (1'b1             ),
                .rden_b         (1'b1             ),
                .sclr           (1'b0             ),
                .wren_b         (1'b0             )
				);
    defparam
        altera_syncram_component.address_aclr_b          = "NONE",
        altera_syncram_component.address_reg_b           = "CLOCK0",
        altera_syncram_component.clock_enable_input_a    = "BYPASS",
        altera_syncram_component.clock_enable_input_b    = "BYPASS",
        altera_syncram_component.clock_enable_output_b   = "BYPASS",
        altera_syncram_component.enable_ecc              = "FALSE",
        altera_syncram_component.init_file               = INIT_FILE,
        altera_syncram_component.intended_device_family  = "Agilex",
        altera_syncram_component.lpm_type                = "altera_syncram",
        altera_syncram_component.numwords_a              = RAM_DEPTH,    
        altera_syncram_component.numwords_b              = RAM_DEPTH,
        altera_syncram_component.operation_mode          = OPERATION_MODE,              
        altera_syncram_component.outdata_aclr_b          = "NONE",
        altera_syncram_component.outdata_sclr_b          = "NONE",
        altera_syncram_component.outdata_reg_b           = "CLOCK0",
        altera_syncram_component.power_up_uninitialized  = "FALSE",
        altera_syncram_component.ram_block_type          = RAM_STYLE ,
        altera_syncram_component.widthad_a               = 8,
        altera_syncram_component.widthad_b               = 8,
        altera_syncram_component.width_a                 = RAM_WIDTH,
        altera_syncram_component.width_b                 = RAM_WIDTH,
        altera_syncram_component.width_byteena_a         = 1;

   // End of xpm_memory_sdpram_inst instantiation
   
  endmodule  
				
				