
`timescale  1ns/1ns
`define   Clk_Period  20

module dcfifo_tb();

   parameter    FIFO_DEPTH = 256                 ;
   parameter    FIFO_DWITH = 12                  ;
   parameter    FIFO_AWITH = $clog2(FIFO_DEPTH)  ;

   reg  [15:0]    test_time_input  ;
   reg            tb_rst           ;
   reg            tb_rclk          ;
   reg            tb_wclk          ;

   reg [FIFO_DWITH - 1 :0]    fifo_data         ;    
   reg [FIFO_DWITH - 1 :0]    fifo_rdata        ;     
   reg                        fifo_rdreq        ;  
   reg                        fifo_wrreq        ;
   wire [FIFO_DWITH - 1 :0]   fifo_q            ;
   wire                       fifo_rdempty      ;
   wire                       fifo_wrfull       ;
   wire                       fifo_wrpfull      ;
   wire                       fifo_wroverflow   ;
   wire [FIFO_AWITH - 1 :0]   fifo_wrusedw      ;
   wire                       fifo_rdfull       ;
   wire [FIFO_AWITH - 1 :0]   fifo_rdusedw      ;
   wire                       fifo_wrempty      ;
   
  //----------------------------------------------------------------
  // clk_gen
  //
  // Clock generator process.
  //----------------------------------------------------------------
	//时钟	
	initial	  tb_rclk = 1;
	always#(`Clk_Period/2)   tb_rclk = ~tb_rclk;   

	initial	  tb_wclk = 1;
	always#(`Clk_Period )   tb_wclk = ~tb_wclk;  	
  //----------------------------------------------------------------
  // make the test data and write in the txt()
  //the txt name is test_sour_data.txt
  // Display the accumulated test results.
  //-----------------------------------------------------------------
    task tb_data( );

	    begin 
		
		   fifo_data  = 0;
		   fifo_rdata = 0;
		   fifo_wrreq = 0;
		   fifo_rdreq = 0;
		   
		    while (1)begin 
			    while (~fifo_wrpfull)begin
				    @(posedge tb_wclk)
			        if (~fifo_wrfull)begin 
				        fifo_wrreq = 1'b1;
				    	fifo_data  = fifo_data + 1; 
				    end
                end 
				
				fifo_wrreq = 1'b0 ;
				fifo_data  = 0    ;
				
			    while (~fifo_rdempty)begin
				    @(posedge tb_rclk)
			        if (~fifo_rdempty)begin 
				        fifo_rdreq   = 1'b1;
				    	fifo_rdata  = fifo_q; 
				    end
                end

                fifo_rdreq = 1'b0 ;
				
                @(posedge tb_rclk)
                @(posedge tb_rclk)				
                 fifo_rdreq = 1'b0 ;				
			
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
		#(`Clk_Period * 10);
		 tb_data ();
         $display("   -- Testbench for fifo end --");
		// $finish;
    end // main	
 
u_dcfifo  #(
        .ENABLE_ECC		         ("FALSE"                ), // = "FALSE"                          ,    //"TRUE"  or  "FALSE" 
        .INTENDED_DEVICE_FAMILY  ("Agilex"               ), // = "Agilex"                         ,    //"ON"    or  "OFF" 
        .FIFO_TYPE               ("M20K"                 ), // = "M20K"                           ,    //"M20K"  or "MLAB" or "AUTO"
        .LPM_NUM_WORDS           (FIFO_DEPTH             ), // = 1024                             ,    //4~131072
        .LPM_SHOWAHEAD           ("ON"                   ), // = "ON"                             ,    //"ON"    or  "OFF" 
        .LPM_TYPE                ("dcfifo"               ), // = "dcfifo"                         ,    // scfifo or dcfifo
        .LPM_WIDTH               (FIFO_DWITH             ), // = 132                              ,
        .LPM_THRESH              (100                    ), // = 800                              ,    //1~ LPM_NUM_WORDS - 4
        .LPM_WIDTHU              ($clog2(FIFO_DEPTH  )   ), // = $clog2(LPM_NUM_WORDS  )          ,
        .OVERFLOW_CHECKING       ("ON"                   ), // = "ON"                             ,    //"ON"    or  "OFF" 
		.RDSYNC_DELAYPIPE        (4                      ), // = 4                                ,
        .UNDERFLOW_CHECKING      ("ON"                   ), // = "ON"                             ,    //"ON"    or  "OFF" 
        .USE_EAB                 ("ON"                   ), // = "ON"                             ,    //"ON"    or  "OFF" 
		.WRSYNC_DELAYPIPE        (4                      ) // = 4   
    )
u_dcfifo_inst
   (
        .data             (fifo_data      ),     //    input       [LPM_WIDTH -1 :0]      
        .rdclk            (tb_rclk        ),     //    input                              
        .aclr             (tb_rst         ),     //    input                              
        .rdreq            (fifo_rdreq     ),     //    input                              
        .wrclk            (tb_wclk        ),     //    input                              
        .wrreq            (fifo_wrreq     ),     //    input                              
        .q                (fifo_q         ),     //    output      [LPM_WIDTH - 1:0]      
        .rdempty          (fifo_rdempty   ),     //    output                             
        .wrfull           (fifo_wrfull    ),     //    output                             
        .wrpfull          (fifo_wrpfull   ),	 //	   output reg                         
        .wroverflow       (fifo_wroverflow),	 //    output reg                          		
        .wrusedw          (fifo_wrusedw   ),     //    output      [LPM_WIDTHU - 1:0]     
        .rdfull           (fifo_rdfull    ),     //	   output                             
        .rdusedw          (fifo_rdusedw   ),	 //    output      [LPM_WIDTHU - 1:0]     
        .wrempty   	      (fifo_wrempty   )      //    output                             
	);                                          
endmodule 