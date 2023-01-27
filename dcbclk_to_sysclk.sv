///////////////////////////////////////////////////////////////////////////////
//  Current version info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
//  $current version            : 1.0
//  $last modified date         : 2022/6/28
//  $last modified author       : zhangluwei
//  $last modified description  : dcbclk_to_sysclk
//-----------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////////
//  History version info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// Modification history :
// Rev.  Date        Author         Cause
// 1.0   2022/6/28   zhangluwei     new
//-----------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////////
//  module and copyright info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
//  module name  :  dcbclk_to_sysclk
//-----------------------------------------------------------------------------
// JINGSHENGKEJI IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
// SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
// JINGSHENGKEJI DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
// AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
// OR STANDARD, JINGSHENGKEJI IS MAKING NO REPRESENTATION THAT THIS
// IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
// AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
// FOR YOUR IMPLEMENTATION.  JINGSHENGKEJI EXPRESSLY DISCLAIMS ANY
// WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
// IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
// REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
// INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE.
// (c) Copyright 2010 JINGSHENGKEJI, Inc.
// All rights reserved.
//************************************************************************
//************************************************************************
// filename   : dcbclk_to_sysclk.sv
// description: dcbclk_to_sysclk.sv
//************************************************************************
`timescale 1ns / 1ps
//************************************************************************
//  Module
//************************************************************************
module dcbclk_to_sysclk#(
  parameter         DATA_WIDTH          = 32

)(
	//global                                                                       
    input                                       dcb_clk       ,    	                    
    input                                       dcb_rst       ,    	                    
    input                                       sys_clk       ,                            
    input                                       sys_rst       ,                
    //dcb_clk                                                            
    input                                       dcb_in_val    ,      
    input           [DATA_WIDTH - 1 :0 ]        dcb_in_data   ,      
	//sys_clk                                                        
    output  reg                                 sys_out_val   ,      
    output  reg     [DATA_WIDTH - 1 :0 ]        sys_out_data   
                                                
								                                                            
                        		
 );
 
    reg                           sys_data_val       =  0  ; 
    reg                           sys_data_val_1d    =  0  ; 
    reg                           sys_data_val_2d    =  0  ; 
    reg                           sys_data_val_3d    =  0  ;
	
    reg                           dcb_in_val_1d      =  0  ; 
    reg     [DATA_WIDTH - 1 :0 ]  dcb_in_data_loc    =  0  ; 
//************************************************************************	
    always @(posedge dcb_clk) begin
        if(dcb_rst) begin
            dcb_in_val_1d  <= 1'b0 ;	
        end
        else begin 
            dcb_in_val_1d  <= dcb_in_val  ;
        end 
    end
    always @(posedge dcb_clk) begin
        if(dcb_in_val) begin
            dcb_in_data_loc  <= dcb_in_data  ;
        end
    end 
    always @(posedge sys_clk) begin
        if(sys_rst) begin
            sys_data_val      <=    1'b0;
            sys_data_val_1d   <=    1'b0;
            sys_data_val_2d   <=    1'b0;
            sys_data_val_3d   <=    1'b0;
        end
    	else begin
    	    sys_data_val     <= dcb_in_val_1d    ;
    	    sys_data_val_1d  <= sys_data_val     ;
    	    sys_data_val_2d  <= sys_data_val_1d  ;
    	    sys_data_val_3d  <= sys_data_val_2d  ;
    	end
    end
    always @(posedge sys_clk) begin
        if(sys_rst) begin
            sys_out_val  <= 1'b0 ;	
        end
        else begin 
            sys_out_val  <= sys_data_val_2d & (~sys_data_val_3d)  ;
        end 
    end 
    always @(posedge sys_clk) begin
        sys_out_data  <= dcb_in_data_loc  ;
    end     
endmodule
