module PMT_ASTABLE (
	input wire pmt_in,
	input wire interrupt, // async reset
	output reg pmt_out
);

	always @(posedge pmt_in or posedge interrupt) begin
		if(interrupt) begin
			pmt_out <= 0;
		end else begin
			pmt_out <= 1;
		end
	end

endmodule


module PMT_ASTABLE_ASSEMBLY#(N=48)(
	input wire [N-1:0] pmts_in,
	input wire interrupt,
	output wire [N-1:0] pmts_out
);

	genvar i;
	for(i = 0; i < N; i = i + 1) begin
		PMT_ASTABLE pmt(.pmt_in(pmts_in[i]),
						.interrupt(interrupt),
						.pmt_out(pmts_out[i]));
	end


endmodule

module POPCOUNT#(IN_N=48, OUT_N=8)(
	input wire [IN_N-1:0] in,
	output reg [OUT_N-1:0] out
);
    // 8 bit register as really this module will not go beyond 64 counts
    reg [8:0] index;
    always @(in) begin
        out = 0;
        for(index = 0; index < IN_N; index = index + 1) begin
            out = out + in[index];
        end
    end

endmodule

module NHIT#(IN_N=48, OUT_N=8)(
	input wire [IN_N-1:0] pmts_in,
	input wire interrupt,
	output wire [OUT_N-1:0] nhit
);

	wire [IN_N-1:0] pmts_out;
	PMT_ASTABLE_ASSEMBLY#(IN_N) pmts(
		.pmts_in(pmts_in),
		.interrupt(interrupt),
		.pmts_out(pmts_out));

	POPCOUNT#(IN_N, OUT_N) pp(
		.in(pmts_out),
		.out(nhit)
		);

endmodule

// Dark noise module

module DN_COUNTER#(RES=16)(
	input wire pmt_in,
	input wire interrupt, // async reset
	output reg [RES-1:0] pmt_out
);

	always @(posedge pmt_in or posedge interrupt) begin
		if(interrupt) begin
			pmt_out <= 0;
		end else begin
			pmt_out <= pmt_out + 1;
		end
	end

endmodule

module DN_MODULE#(N=48, RES=16)(
	input wire [N-1:0] pmts_in,
	input wire interrupt,
	output wire [(RES*N-1):0] pmts_out
);

	genvar i;
	for (i = 0; i < N; i = i+1) begin
		DN_COUNTER#(RES) dn(.pmt_in(pmts_in[i]),
							.interrupt(interrupt),
							.pmt_out(pmts_out[(RES*(i+1) - 1):i*RES]));
	end
endmodule
// end Dark noise module