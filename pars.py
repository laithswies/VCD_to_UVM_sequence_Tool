import csv
from vcdvcd import VCDVCD
# from vcd.reader import TokenKind, tokenize, tokenize_string
# from vcd.vcd import VCD, VCDPhase
def read_signal_names(file_path):
    with open(file_path, 'r') as file:
        signals = [line.strip() for line in file.readlines()]
    return signals
# Function to generate CSV file for each signal
def generate_csv_for_signals(vcd_path, output_csv_path,signal_names_path):
    vcd = VCDVCD(vcd_path)
    
    # Extract all signals
    # signals = vcd.signals
    signals = read_signal_names(signal_names_path)
    
    # Create and open the CSV file
    with open(output_csv_path, mode='w', newline='') as file:
        writer = csv.writer(file)
        
        # Write the header row
        header = ['time'] + signals
        writer.writerow(header)
        
        # Initialize a dictionary to hold the current value of each signal
        signal_values = {signal: None for signal in signals}
        
        # Collect all time points from the VCD file
        time_points = set()
        for signal in signals:
            for time, _ in vcd[signal].tv:
                time_points.add(time)
        
        # Sort the time points
        sorted_time_points = sorted(time_points)
        
        # Write the time and signal values to the CSV file
        for time in sorted_time_points:
            row = [time]
            for signal in signals:
                values_at_time = [value for t, value in vcd[signal].tv if t == time]
                if values_at_time:
                    signal_values[signal] = values_at_time[-1]
                row.append(signal_values[signal])
            writer.writerow(row)

# Example usage
vcd_path = './fulladder.vcd'  # Replace with the path to your VCD file
output_csv_path = 'vcd_file.csv'  # Replace with the desired output CSV file path
signal_names_path = './signal_names.txt'
generate_csv_for_signals(vcd_path, output_csv_path,signal_names_path)
