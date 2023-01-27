///////////////////////////////////////////////////////////////////////////////
//  Current version info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
//  $current version            : 1.0
//  $last modified date         : 2021/10/15 
//  $last modified author       : zlw
//  $last modified description  : add_cal_mod
//-----------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////////
//  History version info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// Modification history :
// Rev.  Date        Author         Cause
// 1.0   2021/10/15    zlw            new
//-----------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//  module and copyright info
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// RUIJIE IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
// SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
// RUIJIE DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
// AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
// OR STANDARD, RUIJIE IS MAKING NO REPRESENTATION THAT THIS
// IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
// AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
// FOR YOUR IMPLEMENTATION.  RUIJIE EXPRESSLY DISCLAIMS ANY
// WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
// IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
// REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
// INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE.
// (c) Copyright 2010 RUIJIE, Inc.
// All rights reserved.
//-----------------------------------------------------------------------------
`timescale 1ns / 1ps
(* use_dsp = "yes" *)

module  add_cal_mod #(
        parameter          ADD_IN_WIDTH             =  8  ,				
        parameter          ADD_OT_WIDTH             =  64 ,				
        parameter          ADD_TP_WIDTH             =  ADD_OT_WIDTH/2  							
      )
	 (
    input                                 clk           ,
	input                                 rst           ,
	input                                 clr_en        ,
																					     
    input       [ADD_IN_WIDTH - 1:0]      data_in       ,
    input                                 data_in_en    ,
	
	output reg  [ADD_OT_WIDTH - 1:0]      data_out       

);
               
reg  [ADD_IN_WIDTH - 1:0]  data_in_1d      ;
reg  [ADD_IN_WIDTH - 1:0]  data_in_2d      ;
reg                        data_in_en_1d   ;
reg                        data_in_en_2d   ;
reg                        data_in_en_3d   ;
reg                        data_in_en_4d   ;

reg  [ADD_TP_WIDTH :0]     add_data_tmp    ;
reg  [ADD_TP_WIDTH :0]     add_data_tmp1   ;
reg  [ADD_TP_WIDTH :0]     add_data_tmp_1d ;


    always@(posedge clk) begin 
        data_in_1d  <= data_in    ; 	
        data_in_2d  <= data_in_1d ;
        data_clr_en <=  rst|clr_en ;		
    end 
    always@(posedge clk) begin 
        if (data_clr_en)begin 
    	    data_in_en_1d  <= 1'b0 ;
    	    data_in_en_2d  <= 1'b0 ;            
    	    data_in_en_3d  <= 1'b0 ;            
    	    data_in_en_4d  <= 1'b0 ;            
    	end             
    	else begin             
    	    data_in_en_1d  <= data_in_en     ;            
    	    data_in_en_2d  <= data_in_en_1d  ;            
    	    data_in_en_3d  <= data_in_en_2d  ;            
    	    data_in_en_4d  <= data_in_en_3d  ;            
    	end 			
    end 
    always@(posedge clk) begin				
        if( data_clr_en )begin 
            add_data_tmp <= 'd0 ;
        end		
	 	else if (data_in_en_2d)begin 
	 		add_data_tmp <=  add_data_tmp + data_in_2d ;
	 	end	
    end	
    always@(posedge clk) begin				
        if(data_clr_en)begin 
            add_data_tmp1[ADD_TP_WIDTH ] <= 1'b0  ;
        end	
        else if((add_data_tmp[ADD_TP_WIDTH])!= (add_data_tmp_1d[ADD_TP_WIDTH] ))begin 
            add_data_tmp1[ADD_TP_WIDTH ] <= 1'b1  ;
        end 			
	 	else begin 
	 		add_data_tmp1[ADD_TP_WIDTH ] <= 1'b0  ;
	 	end	
    end	
	
    always@(posedge clk) begin 
        add_data_tmp1[ADD_TP_WIDTH - 1 :0]   <= add_data_tmp[ADD_TP_WIDTH - 1 :0]     ; 	
        add_data_tmp_1d                    <= add_data_tmp    ; 		
    end 			

    always@(posedge clk) begin				
        if(data_clr_en)begin 
            data_out <= 'd0 ;
        end
	 	else if (data_in_en_2d)begin 
	 		data_out[ADD_OT_WIDTH - 1 : ADD_TP_WIDTH] <=  data_out[ADD_OT_WIDTH - 1 : ADD_TP_WIDTH] + add_data_tmp1[ADD_TP_WIDTH] ;
			data_out[ADD_TP_WIDTH - 1  : 0]           <=  add_data_tmp1[ADD_TP_WIDTH - 1  : 0]  ;
	 	end	
    end		
				
endmodule 