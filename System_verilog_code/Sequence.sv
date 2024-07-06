`include "VCDD.sv"  // include the signal driver

class fulladder_RE_Sequence extends uvm_sequence#(fulladder_SequenceItem);

    CSV_Signal_Driver#(1) a_driver; //the driver is parametized on the signal length in our case just one
    CSV_Signal_Driver#(1) b_driver;
    CSV_Signal_Driver#(1) cin_driver;


    logic a=0;
    logic b=0;
    logic c=0;

    real time_value=0; //it's used to synchronize all the signal drivers.


    `uvm_object_utils(fulladder_RE_Sequence)
    function new(string name="fulladder_RE_Sequence");
        super.new(name);

        //pass the signal name the same way its written in the "signal_names.txt" into the signal driver's constructor.
        a_driver =new("tb_full_adder.a");
        b_driver =new("tb_full_adder.b");
        cin_driver =new("tb_full_adder.cin");

    endfunction

    virtual task body();
        fulladder_SequenceItem transaction=new();

    // run each signal driver in a seperate thread so that all the signal drivers run at the same time value.
        fork
            a_driver.drive_signal(a,time_value);
        join_none

        fork
            b_driver.drive_signal(b,time_value);
        join_none

        fork
            cin_driver.drive_signal(cin,time_value);
        join_none

        // keep sending packets until all the signal changes happen in the simulation.
        repeat(500) begin 
            transaction.a = a;
            transaction.b = b;
            transaction.cin = cin;

            // start_item(transaction);
            // finish_item(transaction);
            #time_value;
            `uvm_send(transaction)
        end
    endtask


endclass