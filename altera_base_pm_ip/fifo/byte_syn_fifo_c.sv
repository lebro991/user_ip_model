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
module  byte_syn_fifo_c
    #(
    //MUST BE ASSIGNMENT
        parameter   WIDTH                       = 32                           ,
        parameter   DEPTH                       = 32                           ,    //DEPTH
        parameter   DEPTHBIT                = $clog2(DEPTH  )    ,        
        parameter   AFULLSIZE                   = DEPTH-2            ,    //prog full size
        parameter   AEMPTYSIZE                  = 3                           ,    //prog empty size ,must > 2         
    //MUST BE ASSIGNMENT
    
    //Generally not required 
        parameter   S_ADD_RAM_OUTPUT_REGISTER   = "OFF"                        ,    //"ON"    or  "OFF" 
//        parameter   S_ENABLE_ECC		        = "FALSE"                      ,    //"TRUE"  or  "FALSE" 
        parameter   S_INTENDED_DEVICE_FAMILY    = "Agilex"                     ,    //"ON"    or  "OFF" 
        parameter   RAM_TYPE                  = "RAM_BLOCK_TYPE = M20K"      ,    //"M20K"  or "MLAB" or "AUTO"

        parameter   S_LPM_SHOWAHEAD             = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_LPM_TYPE                  = "scfifo"                     ,    // scfifo


        parameter   S_OVERFLOW_CHECKING         = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_UNDERFLOW_CHECKING        = "ON"                         ,    //"ON"    or  "OFF" 
        parameter   S_USE_EAB                   = "ON"                              //"ON"    or  "OFF" 
    //Generally not required 
    )(
    input                             clock        ,
    input                             rst          ,	
//    input                         sclr           ,	
    input   wire  [DEPTHBIT-1:0]                thd_cfg_afull ,//thd_cfg_afull >0 afullsize = thd_cfg_afull ,else use default AFULLSIZE
    input   wire  [DEPTHBIT-1:0]                thd_cfg_aempty,//thd_cfg_aempty >0 afullsize = thd_cfg_aempty ,else use default AEMPTYSIZE 
    input                             wen           ,
    input  [WIDTH - 1 : 0 ]     wdata         ,
    output logic                       overflow     ,
    
    input                              ren          ,
    output logic                       empty        ,
    output logic                       aempty       ,
    output logic                       underflow    ,
    output logic                       full         ,
    output logic                       afull        ,
    output logic[WIDTH  - 1  :0] rdata        ,
    output logic[DEPTHBIT - 1 :0]  usedw          	
	
	);
 
    wire  [DEPTHBIT-1:0]                thd_cfg_afull_sel ;
    wire  [DEPTHBIT-1:0]                thd_cfg_aempty_sel;
    
    assign thd_cfg_afull_sel  = thd_cfg_afull > {DEPTHBIT{1'b0}} ? thd_cfg_afull :AFULLSIZE;
    assign thd_cfg_aempty_sel = thd_cfg_aempty > {DEPTHBIT{1'b0}} ? thd_cfg_aempty :AEMPTYSIZE; 
  /**************************************************************************************/
//  debug function
/**************************************************************************************/   
  always @(posedge clock )
  begin
    if (rst)
    begin
      overflow <= 1'b0 ;
    end
    else 
    begin
      overflow <= ((wen & afull) | overflow ) ? 1'b1 : 1'b0 ;
    end 
  end
  
  always @(posedge clock)
  begin
    if (rst)
    begin
      underflow <= 1'b0 ;
    end
    else 
    begin
      underflow <= ((ren & empty)| underflow) ? 1'b1 : 1'b0 ;
    end
  end
  
  always @(posedge clock)
  begin
    if (rst)
    begin
      afull <= 1'b0 ;
    end
    else if ((usedw > thd_cfg_afull_sel) || (usedw == thd_cfg_afull_sel) )
    begin
      afull <= 1'b1 ;
    end
    else 
    begin
      afull <= 1'b0 ;
    end       
  end

  always @(posedge clock)
  begin
    if (rst)
    begin
      aempty <= 1'b1 ;
    end
    else if ( usedw < thd_cfg_aempty_sel )
    begin
      aempty <= 1'b1 ;
    end
    else 
    begin
      aempty <= 1'b0 ;
    end    
  end
  
  //synopsys translate_off  
  
  initial
  begin
    forever
    begin
      @(posedge clock) ;
      if (overflow )
        begin
          $display ("%m: at time %t ERROR: fifo write overflow. ",$time);
          $stop(0);
        end  
    end 
  end
  
  initial
  begin
    forever
    begin
      @(posedge clock) ;
      if (underflow )
        begin
          $display ("%m: at time %t ERROR: fifo write underflow. ",$time);
          $stop(0);
        end  
    end 
  end
  //synopsys translate_on  
  
  
  
  
  
    scfifo  scfifo_component (
                .clock        (clock       ),
                .data         (wdata        ),
                .rdreq        (ren       ),
                .wrreq        (wen       ),
                .empty        (empty       ),
                .full         (full        ),
                .q            (rdata           ),
                .usedw        (usedw       ),
                .aclr         (rst        ),
                .eccstatus    (            ),
                .sclr         (rst        )
				);
	
    defparam	
    scfifo_component.add_ram_output_register 	=  S_ADD_RAM_OUTPUT_REGISTER ,		
//    scfifo_component.enable_ecc              	=  S_ENABLE_ECC		       ,
    scfifo_component.intended_device_family  	=  S_INTENDED_DEVICE_FAMILY  ,
    scfifo_component.lpm_hint                   =  RAM_TYPE                ,
    scfifo_component.lpm_numwords               =  DEPTH           ,
    scfifo_component.lpm_showahead              =  S_LPM_SHOWAHEAD           ,
    scfifo_component.lpm_type                   =  S_LPM_TYPE                ,
    scfifo_component.lpm_width                  =  WIDTH               ,
    scfifo_component.lpm_widthu                 =  DEPTHBIT              ,
    scfifo_component.overflow_checking          =  S_OVERFLOW_CHECKING       ,
    scfifo_component.underflow_checking         =  S_UNDERFLOW_CHECKING      ,
    scfifo_component.use_eab                    =  S_USE_EAB                 ;

endmodule              