
`timescale  1ns/1ns
`define   Clk_Period  20

module dcfifo_tb();

   parameter    RAM_DEPTH = 128                    ;
   parameter    RAM_WIDTH = 8                      ;
   parameter    RAM_DWIDTH = $clog2(RAM_DEPTH)    ;

   reg  [15:0]    test_time_input  ;
   reg            tb_rst           ;
   reg            tb_clk           ;

   reg [RAM_WIDTH - 1 :0]     dina                    ;    
   reg [RAM_DWIDTH    :0]     addra                   ;     
   reg [RAM_DWIDTH    :0]     addrb                   ;     
   reg                        wea                     ;  
   wire                       initial_done            ;
   reg [3:0]                  test_cnt                ;

   
  //----------------------------------------------------------------
  // clk_gen
  //
  // Clock generator process.
  //----------------------------------------------------------------
	//时钟	
	initial	  tb_clk = 1;
	always#(`Clk_Period/2)   tb_clk = ~tb_clk;   
	
  //----------------------------------------------------------------
  // make the test data and write in the txt()
  //the txt name is test_sour_data.txt
  // Display the accumulated test results.
  //-----------------------------------------------------------------
    task tb_data( );

	    begin 
		
		   dina       = 0;
		   addra      = 0;
		   addrb      = 0;
		   wea        = 0;
		   test_cnt   = 0;
		   
		    while (test_cnt < 4'd4 )begin 
			    // while ((~addra[RAM_DWIDTH]))begin
				while (initial_done)begin
				    @(posedge tb_clk)    
			        if (~addra[RAM_DWIDTH])begin 
				        wea = 1'b1;
				    	addra  = addra + 1; 
				    	dina   = dina + 1 ; 
				    end
                end 
				
				wea    = 1'b0 ;
				addra  = 0    ;
				dina   = 0    ;
				
			    while (~addrb[RAM_DWIDTH])begin
				    @(posedge tb_clk)
			        if (~addrb[RAM_DWIDTH])begin 
				        addrb  = addrb + 1; 
				    end
                end

                addrb = 1'b0 ;
				
                @(posedge tb_clk)
                @(posedge tb_clk)								
			    test_cnt <= test_cnt + 1 ;
			end 
		end 
  
    endtask;  // tb_data

  //----------------------------------------------------------------
  // The main test functionality.
  //----------------------------------------------------------------
  initial
    begin : main
	    $display("   -- Testbench for fifo started --");
		tb_rst = 1 ;
		 #(`Clk_Period * 1000);
		tb_rst = 0 ; 
		#(`Clk_Period * 1);
		 tb_data ();
         $display("   -- Testbench for fifo end --");
		// $finish;
    end // main	


xpm_sdpram_with_initial  #(
            .RAM_WIDTH   (RAM_WIDTH  )                 ,
            .RAM_DEPTH   (RAM_DEPTH  )                 ,
            .INIT        (1          )                  			
            
         )
xpm_sdpram_with_initial_inst
         (
		.clk            (tb_clk                            ),
		.rst            (tb_rst                            ),
		.dina           (dina                              ),
		.addra          (addra[RAM_DWIDTH - 1    :0]       ),
		.wea            (wea                               ),
		.doutb          (doutb                             ),
		.addrb	        (addrb[RAM_DWIDTH - 1    :0]       ),
        .initial_done	(initial_done                      )	 
		 
         );  	
endmodule 