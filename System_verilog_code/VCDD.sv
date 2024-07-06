class Tokenizer;

    string tokens[$];
    int num_tokens;
    
    function void tokenize(string str,string delimiter);
        int token_start = 0;
        int token_length = 0;
        for (int i = 0; i < str.len(); i++) begin

                if ({str.getc(i)} == delimiter) begin
                    token_length = i - token_start;
                    if (token_length > 0) begin
                        this.tokens.push_back(str.substr(token_start,token_length+token_start-1));
                        this.num_tokens++;
                    end
                    token_start = i + 1;
                end
            token_length = 0;
        end

    token_length = str.len() - token_start;
    if (token_length > 0) begin
        this.tokens.push_back(str.substr(token_start,token_length+token_start-1));
        this.num_tokens++;
    end
    endfunction
endclass

class CSV_Signal_Driver#(parameter SIG_LENGTH= 56);

  string csv_file_path;
  string signal_name;

  
  function new( string signal_name,string csv_file_path = "./vcd_file.csv");
    this.csv_file_path = csv_file_path;
    this.signal_name = signal_name;
    endfunction

  function bit [SIG_LENGTH-1:0] bin_str_to_bits(string bin_str);
      bit [SIG_LENGTH-1:0] result;
      for (int i = 0; i < bin_str.len(); i++) begin
          result[i] = (bin_str[bin_str.len() - 1 - i] == "1") ? 1'b1 : 1'b0;
      end
      return result;
  endfunction


  task drive_signal;
    ref logic [SIG_LENGTH-1:0] generated_signal;
    ref real time_value;
    // File operation variables
    int file;
    string line;
    string token;
    string signal_value_str;
    logic [SIG_LENGTH-1:0] signal_value;
    Tokenizer tok = new();

    int signal_index;
    int index = 0;
    int found = 0;
    real prev_time=0;

    // Open the CSV file
    file = $fopen(csv_file_path, "r");
    if (!file) begin
      $display("ERROR: Could not open file %s", csv_file_path);
      return;
    end

    // Read the header line
    $fgets(line,file);
    // Find the index of the signal in the header
    tok.tokenize(line,",");

    foreach (tok.tokens[i]) begin
      token = tok.tokens[i];
      if (token == signal_name) begin
        signal_index = i;
        found = 1;
      end
    end

    tok = new();
    if (!found) begin
      $display("ERROR: Signal %s not found in the CSV file header", signal_name);
      $fclose(file);
      return;
    end

    // Read the CSV file line by line and drive the signal
    while (!$feof(file)) begin
      $fgets(line,file);
      tok.tokenize(line,",");
      token = tok.tokens[0];
      time_value = token.atoi();
      signal_value_str = tok.tokens[signal_index];
      // Convert string to logic signal
      signal_value = bin_str_to_bits(signal_value_str);
      // Wait for the specified time

      #time_value;
      // Drive the signal
      generated_signal = signal_value;
      tok = new();

    end

    // Close the file
    $fclose(file);
  endtask

endclass

module test;

  logic [31:1] ifc_fetch_addr_f;
  CSV_Signal_Driver#(31) ifc_fetch_addr_driver;

  initial begin
    ifc_fetch_addr_driver = new("tb_top.rvtop.orv.ifu.bpred.bp.ifc_fetch_addr_f[31:1]");
    ifc_fetch_addr_driver.drive_signal(ifc_fetch_addr_f);
  end



  // initial begin
  //   $fsdbDumpfile("generated.fsdb");
  //   $fsdbDumpvars;
  //   $fsdbDumpvars("+mda");
  //   $fsdbDumpvars("+struct");
  //   $fsdbDumpvars("+all");
  //   $fsdbDumpon;
  // end

endmodule

