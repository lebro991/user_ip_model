// (C) 2001-2021 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  u_dcfifo  #(
        parameter   ENABLE_ECC		          = "FALSE"                          ,    //"TRUE"  or  "FALSE" 
        parameter   INTENDED_DEVICE_FAMILY    = "Agilex"                         ,    //"ON"    or  "OFF" 
        parameter   FIFO_TYPE                 = "M20K"                           ,    //"M20K"  or "MLAB" or "AUTO"
        parameter   DEPTH                     = 1024                             ,    //4~131072
        parameter   SHOWAHEAD                 = "ON"                             ,    //"ON"    or  "OFF" 
        parameter   LPM_TYPE                  = "dcfifo"                         ,    // scfifo or dcfifo
        parameter   WIDTH                     = 132                              ,
        parameter   DEPTHBIT                  = $clog2(REQ_ARB_FIFO_WRITE_DEPTH) ,
        parameter   OVERFLOW_CHECKING         = "ON"                             ,    //"ON"    or  "OFF" 
		parameter   RDSYNC_DELAYPIPE          = 4                                ,
        parameter   UNDERFLOW_CHECKING        = "ON"                             ,    //"ON"    or  "OFF" 
        parameter   USE_EAB                   = "ON"                             ,    //"ON"    or  "OFF" 
		parameter   WRSYNC_DELAYPIPE          = 4   
    )
   (
    input  [WIDTH -1 :0]          data      ,
    input                         rdclk     ,
	input                         aclr      ,
    input                         rdreq     ,
    input                         wrclk     ,
    input                         wrreq     ,
    output [WIDTH - 1:0]          q         ,
    output                        rdempty   ,
    output                        wrfull    , 
    output [DEPTHBIT - 1:0]       wrusedw   ,
	output [1:0]                  eccstatus ,
	output                        rdfull    ,
    output [DEPTHBIT - 1:0]       rdusedw   ,	
    output                        wrempty   ,		
	);
	generate  if (FIFO_TYPE == "M20K" )begin 
        localparam   LPM_HINT  = "RAM_BLOCK_TYPE = M20K,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT = FALSE",    //"M20K"  or "MLAB" or "AUTO"
    end 
    else begin 
        if(FIFO_TYPE == "MLAB" ) begin 
		    localparam   LPM_HINT  = "RAM_BLOCK_TYPE = MLAB,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT = TURE",    //"M20K"  or "MLAB" or "AUTO"
		end 

    end 	
	endgenerate
	
    dcfifo  dcfifo_component (
                .data     (data     ),
                .rdclk    (rdclk    ),
                .rdreq    (rdreq    ),
                .wrclk    (wrclk    ),
                .wrreq    (wrreq    ),
                .q        (q        ),
                .rdempty  (rdempty  ),
                .wrfull   (wrfull   ),
                .wrusedw  (wrusedw  ),
                .aclr     (aclr     ),
                .eccstatus(eccstatus),
                .rdfull   (rdfull   ),
                .rdusedw  (rdusedw  ),
                .wrempty  (wrempty  )
				);
    defparam                                                                ,
        dcfifo_component.enable_ecc              = ENABLE_ECC               ,
        dcfifo_component.intended_device_family  = INTENDED_DEVICE_FAMILY   ,
        dcfifo_component.lpm_hint                = LPM_HINT                 ,
        dcfifo_component.lpm_numwords            = DEPTH                    ,
        dcfifo_component.lpm_showahead           = SHOWAHEAD                ,
        dcfifo_component.lpm_type                = LPM_TYPE                 ,
        dcfifo_component.lpm_width               = WIDTH                    ,
        dcfifo_component.lpm_widthu              = DEPTHBIT                 ,
        dcfifo_component.overflow_checking       = OVERFLOW_CHECKING        ,
        dcfifo_component.rdsync_delaypipe        = RDSYNC_DELAYPIPE         ,
        dcfifo_component.underflow_checking      = UNDERFLOW_CHECKING       ,
        dcfifo_component.use_eab                 = USE_EAB                  ,
        dcfifo_component.wrsync_delaypipe        = WRSYNC_DELAYPIPE         ;


endmodule