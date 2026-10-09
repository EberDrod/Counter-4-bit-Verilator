`timescale 1ns/1ps

module tb_counter;

    logic clk;
    logic rst;
    logic [3:0] count;

    // Instancia del circuito
    counter dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Generador de reloj
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end

    // Testbench principal
    initial begin

        rst = 1;

        // Generar archivo VCD
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_counter);

        $display("=== VERILATOR SIMULATION ===");

        #12;
        rst = 0;

        repeat (20) begin
            @(negedge clk);

            $display(
                "Time=%0t | CLK=%b | COUNT=%d",
                $time, clk, count
            );
        end

        $display("=== SIMULATION COMPLETE ===");

        $finish;
    end

endmodule
