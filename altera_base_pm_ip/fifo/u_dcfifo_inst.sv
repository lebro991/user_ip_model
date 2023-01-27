u_dcfifo    #(

        .FIFO_TYPE                 ("M20K"   ),    //"M20K"  or "MLAB" or "AUTO"
        .DEPTH                     (1024     ),    //4~131072
        .SHOWAHEAD                 ("ON"     ),    //"ON"    or  "OFF" 
        .WIDTH                     (132      )
    )
u0	
   (
    .data      (data   ),
    .rdclk     (rdclk  ),
	.aclr      (aclr   ),
    .rdreq     (rdreq  ),
    .wrclk     (wrclk  ),
    .wrreq     (wrreq  ),
    .q         (q      ),
    .rdempty   (rdempty),
    .wrfull    (wrfull ), 
    .wrusedw   (wrusedw),
	.rdfull    (rdfull ),
    .rdusedw   (rdusedw)	
	);