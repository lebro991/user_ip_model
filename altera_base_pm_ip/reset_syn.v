
// $Revision: #1 $
// $Date: 2013/08/12 $
// $Author: swbranch $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module reset_syn
#(
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in ,

    input   clk,
    output  reset_out
);


    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*preserve*) reg [DEPTH-1:0] rst_syn_chain;
    reg rst_syn_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                rst_syn_chain <= {DEPTH{1'b1}};
                rst_syn_chain_out <= 1'b1;
            end
            else begin
                rst_syn_chain[DEPTH-2:0] <= rst_syn_chain[DEPTH-1:1];
                rst_syn_chain[DEPTH-1] <= 0;
                rst_syn_chain_out <= rst_syn_chain[0];
            end
        end

        // assign reset_out = rst_syn_chain_out;
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            rst_syn_chain[DEPTH-2:0] <= rst_syn_chain[DEPTH-1:1];
            rst_syn_chain[DEPTH-1] <= reset_in;
            rst_syn_chain_out <= rst_syn_chain[0];
        end

        // assign reset_out = rst_syn_chain_out;
 
    end
    endgenerate
    
    assign reset_out = rst_syn_chain_out;   
      

endmodule

