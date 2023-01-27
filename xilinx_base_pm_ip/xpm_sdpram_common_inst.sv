xpm_sdpram_common  #(
            .RAM_WIDTH  = 72            ,
            .RAM_DEPTH  = 128           ,
            .RAM_STYLE  = "block"       ,  // "block" "distribute"	
            .LAYTENCY   = 2             			
            
         )
u0		 
         (
		 .clk    (clk    ), //input                           
		 .rst    (rst    ), //input                           
		 .dina   (dina   ), //input    [RAM_WIDTH - 1  :0]    
		 .addra  (addra  ), //input    [ADDR_WIDTH - 1 :0]    
		 .wea    (wea    ), //input                           
		 .doutb  (doutb  ), //input    [RAM_WIDTH - 1  :0]    
		 .addrb  (addrb  )	//input    [ADDR_WIDTH - 1 :0]     
		 
         ); 