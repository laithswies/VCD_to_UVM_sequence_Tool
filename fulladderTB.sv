`include "fulladder.sv"
module tb_full_adder;
    // Inputs
    reg a;
    reg b;
    reg cin;

    // Outputs
    wire sum;
    wire cout;
    
    // Instantiate the full adder
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // Test cases
    initial begin
        // Test case 1: 0 + 0 + 0 = 0, carry = 0
        a = 0; b = 0; cin = 0;
        #10; // Wait for 10 time units
        $display("Test case 1: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 2: 0 + 0 + 1 = 1, carry = 0
        a = 0; b = 0; cin = 1;
        #10; // Wait for 10 time units
        $display("Test case 2: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 3: 0 + 1 + 0 = 1, carry = 0
        a = 0; b = 1; cin = 0;
        #10; // Wait for 10 time units
        $display("Test case 3: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 4: 0 + 1 + 1 = 0, carry = 1
        a = 0; b = 1; cin = 1;
        #10; // Wait for 10 time units
        $display("Test case 4: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 5: 1 + 0 + 0 = 1, carry = 0
        a = 1; b = 0; cin = 0;
        #10; // Wait for 10 time units
        $display("Test case 5: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 6: 1 + 0 + 1 = 0, carry = 1
        a = 1; b = 0; cin = 1;
        #10; // Wait for 10 time units
        $display("Test case 6: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 7: 1 + 1 + 0 = 0, carry = 1
        a = 1; b = 1; cin = 0;
        #10; // Wait for 10 time units
        $display("Test case 7: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        // Test case 8: 1 + 1 + 1 = 1, carry = 1
        a = 1; b = 1; cin = 1;
        #10; // Wait for 10 time units
        $display("Test case 8: a = %b, b = %b, cin = %b -> sum = %b, cout = %b", a, b, cin, sum, cout);
        
        $finish; // End the simulation
    end

    initial begin
    $dumpfile("fulladder.vcd");
    $dumpvars;
    end
endmodule
