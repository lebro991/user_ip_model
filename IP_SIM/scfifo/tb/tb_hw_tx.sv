  //----------------------------------------------------------------
  // read the test data and export with the avalon-st
  // Display the accumulated test results.
  //----------------------------------------------------------------
`timescale  1ps/1ps
  
module  tb_hw_tx();



	reg         tag_rev_scfifo_wreq    = 1'b0 ;
	reg [4:0]   tag_rev_scfifo_data    = 5'd0 ;
	reg         tag_rev_scfifo_rdreq   = 1'b0   ;	
	wire        tag_rev_scfifo_empty   ;
	wire [4:0]  tag_rev_scfifo_q       ;
    reg [5:0]   init_tag_cnt           ;
	reg         init_tag_fifo_end      ;

   task HW_DATA(      
                input [31:0]      test_time 
                );
    
      integer       hw_sour_len_rd_file;
      integer       hw_sour_data_rd_file; 
      integer       b,h; 
      reg[15:0]     hw_sour_data_len;
      reg[15:0]     hw_sour_data_real_len;
      reg[127:0]    hw_sour_data;  
      reg[0:0]      reg1,reg2;  
      reg[31:0]     pkt_base_addr ;	
	  reg[7:0]      pkt_id;
      reg[4:0]      pkt_tag ;
	  reg[3:0]      first_be;
	  reg[3:0]      last_be ;  
	  reg[1:0]      low_adress;
	  
    begin
        hw_sour_len_rd_file= $fopen("./data_file/test_sour_len.txt", "r");
        hw_sour_data_rd_file = $fopen("./data_file/test_sour_data.txt", "r");	
      // $display("************** rd start *****************************" );       
	    //输入仿真数据
         dn_cpl_mag_tb.tb_pcie_hdr   = 0;
         dn_cpl_mag_tb.tb_pcie_data  = 0;
         dn_cpl_mag_tb.tb_pcie_sop   = 0 ;
         dn_cpl_mag_tb.tb_pcie_eop   = 0;
         dn_cpl_mag_tb.tb_pcie_valid = 0;
		 hw_sour_data_real_len = 0;
         pkt_base_addr  = 0 ;
		 pkt_id =  0;
		 
        // while(!$feof(hw_sour_len_rd_file))begin 
         for(h= 0; h < test_time; h = h + 1 )begin 
		        $display("h: %h" , h);
				pkt_id = pkt_id + 1;
				pkt_base_addr = 1  + {$random}%65536;
                reg1  = $fscanf(hw_sour_len_rd_file, "%h", hw_sour_data_len);				
                GET_UNUSED_TAG (pkt_tag);

               // @(posedge dn_cpl_mag_tb.tb_clk);
				hw_sour_data_real_len = hw_sour_data_len[15:4] + |hw_sour_data_len[3:0] ;
				CAL_FBE_LBE (hw_sour_data_len,first_be,last_be,low_adress);
				
				$display("hw_sour_data_real_len: %h" ,hw_sour_data_real_len);  
                if(reg1 == 0)begin 
                   $display("*******************************************" ); 
                   $display("********read the data error****************" ); 
                   // $display("reg1: %h" ,reg1);  
                end
                else begin 

				    for(b=0; b < hw_sour_data_real_len ; b = b + 1)begin
                        reg2  = $fscanf(hw_sour_data_rd_file, "%h", hw_sour_data);
                        $display("*******************************************" );   			
                        $display("tb_pcie_eop: %h" ,dn_cpl_mag_tb.tb_pcie_eop);						
                        $display("hw_sour_data: %h" ,hw_sour_data);
                        @(posedge dn_cpl_mag_tb.tb_clk)
			    		 dn_cpl_mag_tb.tb_pcie_valid  =  1;
                            if(b == 0 )begin 
					     	    // dn_cpl_mag_tb.tb_pcie_hdr =   {hw_sour_data[127:96],pkt_base_addr,16'd0,pkt_tag,last_be,first_be,hw_sour_data[31:0]};
								dn_cpl_mag_tb.tb_pcie_hdr =   {hw_sour_data[127:96],16'd0,pkt_tag,6'd0,low_adress,20'd0,hw_sour_data_len[11:0],hw_sour_data[31:0]};
                               
							   reg2  = $fscanf(hw_sour_data_rd_file, "%h", hw_sour_data);
                                $display("*******************************************" );    
                                $display("hw_sour_data: %h" ,hw_sour_data);								
					     	    dn_cpl_mag_tb.tb_pcie_data  =  {hw_sour_data[103:96],hw_sour_data[111:104],hw_sour_data[119:112],hw_sour_data[127:120],
								                                hw_sour_data[71:64],hw_sour_data[79:72],hw_sour_data[87:80],hw_sour_data[95:88],
								                                hw_sour_data[39:32],hw_sour_data[47:40],hw_sour_data[55:48],hw_sour_data[63:56],
								                                hw_sour_data[7:0],hw_sour_data[15:8],hw_sour_data[23:16],hw_sour_data[31:24]
								                                } ;
                                dn_cpl_mag_tb.tb_pcie_sop   =   1;
                            end
                            else begin 
                               dn_cpl_mag_tb.tb_pcie_sop =   0;
							   dn_cpl_mag_tb.tb_pcie_data  =  hw_sour_data ;
                            end   
                            if(b == (hw_sour_data_real_len - 1))begin    
                               dn_cpl_mag_tb.tb_pcie_eop =   1;
                            end
                            else begin 
                               dn_cpl_mag_tb.tb_pcie_eop =   0;
                            end  							
                            // $display("*******************************************" ); 				
                        $display("tb_pcie_eop: %h" ,dn_cpl_mag_tb.tb_pcie_eop);
                        // $display("sour_data: %h" ,sour_data);
                    end
			    	@(posedge dn_cpl_mag_tb.tb_clk)
                    dn_cpl_mag_tb.tb_pcie_valid  =   0; 
					dn_cpl_mag_tb.tb_pcie_sop    =   0;
                    dn_cpl_mag_tb.tb_pcie_eop    =   0;					
                end
        end                
    end
  endtask // single_block_test
  
   task GET_UNUSED_TAG(     
   
    output reg [4:0]    unused_tag
    );
	begin 
	    tag_rev_scfifo_rdreq = 1'b0 ;
		unused_tag = 0;
		
  	    while(tag_rev_scfifo_empty)
		begin
            @(posedge dn_cpl_mag_tb.tb_clk)		
			tag_rev_scfifo_rdreq = 1'b0 ;
	    end 
        @(posedge dn_cpl_mag_tb.tb_clk)
            tag_rev_scfifo_rdreq = 1'b1 ;
        	unused_tag  =  tag_rev_scfifo_q[4:0];
        	dn_cpl_mag_tb.pack_id  = HW_DATA.pkt_id; 
        	dn_cpl_mag_tb.pack_len = HW_DATA.hw_sour_data_len;
        	dn_cpl_mag_tb.consum_tag  =  tag_rev_scfifo_q[4:0];
        	dn_cpl_mag_tb.consum_vld  = 1'b1 ;
        @(posedge dn_cpl_mag_tb.tb_clk)
            tag_rev_scfifo_rdreq = 1'b0 ;	
            dn_cpl_mag_tb.consum_vld  = 1'b0 ;		
    end 
    endtask //GET_UNUSED_TAG
	
/***********************************************************************
*************************tag    mag************************************
**************************************************************************/




  
  
endmodule 