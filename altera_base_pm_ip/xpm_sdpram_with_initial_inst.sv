xpm_sdpram_with_initial  #(
            .RAM_WIDTH        (72      )  , 
            .RAM_DEPTH        (128     )  , 
            .RAM_STYLE        ("AUTO" )  ,  //"M20K" "AUTO"	
			.INIT             (1       )  , 
			.INIT_VALUE       (0       )  	
            
         )
u0		 
         (
		 .clk           (clk           ), //input                           
		 .rst           (rst           ), //input                           
		 .dina          (dina          ), //input    [RAM_WIDTH - 1  :0]    
		 .addra         (addra         ), //input    [ADDR_WIDTH - 1 :0]    
		 .wea           (wea           ), //input                           
		 .doutb         (doutb         ), //input    [RAM_WIDTH - 1  :0]    
		 .addrb         (addrb         ), //input    [ADDR_WIDTH - 1 :0]     
		 .initial_done  (initial_done  )  //input    [ADDR_WIDTH - 1 :0]     
		 
         ); 