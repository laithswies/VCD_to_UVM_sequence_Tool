module full_adder (
    input wire a,     // First input
    input wire b,     // Second input
    input wire cin,   // Carry input
    output wire sum,  // Sum output
    output wire cout  // Carry output
);
    assign {cout, sum} = a + b + cin; // Full adder logic
endmodule
