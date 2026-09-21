`timescale 1ns / 1ps

module uart_tx_tb;

    reg clk;
    reg rst;
    reg [7:0] data_in;
    reg start;

    wire tx;
    wire busy;

    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .start(start),
        .tx(tx),
        .busy(busy)
    );

    // 50 MHz clock = 20 ns period
    always #10 clk = ~clk;

    initial begin
        clk     = 0;
        rst     = 1;
        data_in = 8'b0;
        start   = 0;

        #100;
        rst = 0;

        // Data to transmit
        data_in = 8'b10110010;

        #20;
        start = 1;

        #20;
        start = 0;

        // Wait for transmission
        #1200000;

        $finish;
    end

endmodule