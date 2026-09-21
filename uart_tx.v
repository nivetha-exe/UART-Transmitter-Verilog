module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] data_in,
    input  wire       start,
    output reg        tx,
    output reg        busy
);

    // 50 MHz clock, 9600 baud
    localparam BAUD_COUNT = 5208;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0]  state;
    reg [7:0]  shift_reg;
    reg [2:0]  bit_count;
    reg [12:0] baud_counter;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state        <= IDLE;
            shift_reg    <= 8'b0;
            bit_count    <= 3'b0;
            baud_counter <= 13'b0;
            tx           <= 1'b1;
            busy         <= 1'b0;
        end

        else begin

            case (state)

                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (start) begin
                        shift_reg    <= data_in;
                        bit_count    <= 3'b0;
                        baud_counter <= 13'b0;
                        busy         <= 1'b1;
                        state        <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (baud_counter == BAUD_COUNT - 1) begin
                        baud_counter <= 13'b0;
                        state <= DATA;
                    end
                    else begin
                        baud_counter <= baud_counter + 1'b1;
                    end
                end

                DATA: begin
                    tx <= shift_reg[0];

                    if (baud_counter == BAUD_COUNT - 1) begin
                        baud_counter <= 13'b0;

                        if (bit_count == 3'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1'b1;
                            shift_reg <= shift_reg >> 1;
                        end
                    end
                    else begin
                        baud_counter <= baud_counter + 1'b1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (baud_counter == BAUD_COUNT - 1) begin
                        baud_counter <= 13'b0;
                        state <= IDLE;
                        busy <= 1'b0;
                    end
                    else begin
                        baud_counter <= baud_counter + 1'b1;
                    end
                end

            endcase
        end
    end

endmodule