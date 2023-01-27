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

/////////////////////////////////////////////////////////////////
//Notice:
//1. AEMPTYSIZE >=4 & AFULLSIZE <= DEPTH-4  or these signal will lose efficacy
// 2. thd_cfg_afull/thd_cfg_aempty  is reconfig AEMPTYSIZE/AFULLSIZE,if nouse plz drive 0 .
// 3. you shall use comb logic to generate fifo_ren when you use empty as condition 
// every err PLZ  contact XIEXIAO
/////////////////////////////////////////////////////////////////

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
byte_syn_fifo_c
    #(
        .WIDTH                       (32                     ), 
        .DEPTH                       (32                     ), //DEPTH 
        .RAM_TYPE                    ("RAM_BLOCK_TYPE = M20K"), //"M20K"  or "MLAB" or "AUTO"
        .S_LPM_SHOWAHEAD             ("ON"                   )  //"ON"    or  "OFF" 
    )
u0
	(
    .clock         (clock         ),
    .rst           (rst           ),
    .thd_cfg_afull (thd_cfg_afull ),
    .thd_cfg_aempty(thd_cfg_aempty),
    .wen           (wen           ),
    .wdata         (wdata         ),
    .overflow      (overflow      ),
    .ren           (ren           ),
    .empty         (empty         ),
    .aempty        (aempty        ),
    .underflow     (underflow     ),
    .full          (full          ),
    .afull         (afull         ),
    .rdata         (rdata         ),
    .usedw         (usedw         ) 	
	
	);          