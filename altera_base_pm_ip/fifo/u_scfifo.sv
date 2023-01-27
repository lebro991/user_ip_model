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
module  u_scfifo
    #(
        parameter   S_ADD_RAM_OUTPUT_REGISTER   = "OFF"                        ,    //"ON"    or  "OFF" 
        parameter   S_ENABLE_ECC		        = "FALSE"                      ,    //"TRUE"  or  "FALSE" 
        parameter   S_INTENDED_DEVICE_FAMILY    = "Agilex"                     ,    //"ON"    or  "OFF" 
        parameter   S_LPM_HINT                  = "RAM_BLOCK_TYPE = M20K"      ,    //"M20K"  or "MLAB" or "AUTO"
        parameter   S_LPM_NUM_WORDS             = 32                           ,   
        parameter   S_LPM_SHOWAHEAD             = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_LPM_TYPE                  = "scfifo"                     ,    // scfifo
        parameter   S_LPM_WIDTH                 = 5                            ,
        parameter   S_LPM_WIDTHU                = $clog2(S_LPM_NUM_WORDS  )    ,
        parameter   S_OVERFLOW_CHECKING         = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_UNDERFLOW_CHECKING        = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_USE_EAB                   = "ON"                              //"ON"    or  "OFF" 
   
    )(
    input                         clock        ,
    input                         aclr         ,	
	input                         sclr         ,	
    input  [S_LPM_WIDTH - 1 : 0 ] data         ,
    input                         rdreq        ,
    input                         wrreq        ,
    output                        empty        ,
    output                        full         ,
	output                        almost_empty ,
	output                        almost_full  ,
    output [S_LPM_WIDTH  - 1  :0]     q        ,
    output [S_LPM_WIDTHU - 1 :0]  usedw          	
	
	);
    scfifo  scfifo_component (
                .clock        (clock       ),
                .data         (data        ),
                .rdreq        (rdreq       ),
                .wrreq        (wrreq       ),
                .empty        (empty       ),
                .full         (full        ),
                .q            (q           ),
                .usedw        (usedw       ),
                .aclr         (aclr        ),
                .almost_empty (almost_empty),
                .almost_full  (almost_full ),
                .eccstatus    (            ),
                .sclr         (sclr        )
				);
	
    defparam	
    scfifo_component.add_ram_output_register 	=  S_ADD_RAM_OUTPUT_REGISTER ,		
    scfifo_component.enable_ecc              	=  S_ENABLE_ECC		       ,
    scfifo_component.intended_device_family  	=  S_INTENDED_DEVICE_FAMILY  ,
    scfifo_component.lpm_hint                   =  S_LPM_HINT                ,
    scfifo_component.lpm_numwords               =  S_LPM_NUM_WORDS           ,
    scfifo_component.lpm_showahead              =  S_LPM_SHOWAHEAD           ,
    scfifo_component.lpm_type                   =  S_LPM_TYPE                ,
    scfifo_component.lpm_width                  =  S_LPM_WIDTH               ,
    scfifo_component.lpm_widthu                 =  S_LPM_WIDTHU              ,
    scfifo_component.overflow_checking          =  S_OVERFLOW_CHECKING       ,
    scfifo_component.underflow_checking         =  S_UNDERFLOW_CHECKING      ,
    scfifo_component.use_eab                    =  S_USE_EAB                 ;

endmodule              