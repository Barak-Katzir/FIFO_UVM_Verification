# FIFO Verification Repository

This repository contains a Universal Verification Methodology (UVM) based testbench for verifying a FIFO (First-In-First-Out) module. The testbench is designed to rigorously test the FIFO's functionality through various test scenarios to ensure it operates correctly under different conditions.

## Repository Structure

### 1. `fifo_tb.sv`
This is the top-level testbench module that sets up the simulation environment for the FIFO. It includes the following key components:
- **Clock and Reset Generation**: Generates the clock signal and manages the reset signal for the simulation.
- **FIFO Interface**: Instantiates the FIFO interface which connects the testbench to the FIFO module.
- **DUT Instantiation**: Instantiates the FIFO module (DUT - Device Under Test) and connects it to the FIFO interface signals.
- **UVM Configuration**: Sets the FIFO interface in the UVM configuration database to be accessible by UVM components.
- **Test Execution**: Calls the `run_test` method to execute the specified test (`fifo_test`).

### 2. `fifo_test.sv`
This file defines the `fifo_test` class, which is derived from `uvm_test`. It orchestrates the overall test by instantiating and configuring the FIFO environment and defining various test tasks:
- **`fifo_test` Class**: The main test class that inherits from `uvm_test`.
  - **Build Phase**: Creates an instance of the FIFO environment (`fifo_env`) and sets up the virtual interface.
  - **Enable Debug**: Conditional debug enabling based on a preprocessor directive.
  - **Test Tasks**: Defines multiple tasks to perform different types of FIFO tests:
    - **Random Test**: Performs random read and write operations.
    - **Full Test**: Writes data until the FIFO is full.
    - **Empty Test**: Writes and then reads data until the FIFO is empty.
    - **Fill & Reset Test**: Fills the FIFO partially, resets it, and checks the state.
    - **Simultaneous Read/Write Test**: Performs read and write operations simultaneously.
    - **Read from Empty Test**: Attempts to read from an empty FIFO.
    - **Write to Full Test**: Attempts to write to a full FIFO.
    - **Write to Last Place Test**: Writes to the last available spot in the FIFO.
    - **Read from First Place Test**: Writes to the FIFO and reads from the first position.
  - **Run Phase**: Executes the test tasks sequentially during the run phase of the simulation.

### 3. `fifo_pkg.sv`
Includes the package definition for the FIFO verification environment, including interface definitions and any additional utilities required for the testbench.

### Key Concepts
- **UVM Framework**: Utilizes UVM to structure the testbench, leveraging UVM components like `uvm_test`, `uvm_env`, and `uvm_sequence` for modular and reusable test development.
- **Virtual Interface**: Uses virtual interfaces to abstract the connection between the testbench and the DUT, enabling flexible reconfiguration and reuse.
- **Parameterized FIFO**: The DUT is a parameterized FIFO module, allowing different configurations for data and address widths.

## Usage
To use this repository, follow these steps:
1. **Setup**: Ensure you have a SystemVerilog simulator that supports UVM.
2. **Compile**: Compile the provided SystemVerilog files along with the UVM library.
3. **Run**: Execute the testbench by running the `fifo_tb` module.
4. **Analyze**: Review the simulation results to verify the correct behavior of the FIFO under various test conditions.

## License
This repository is licensed under the MIT License.

## Contributions
Contributions are welcome! Please open an issue or submit a pull request if you have any improvements or bug fixes.

## Contact
For any questions or issues, please contact the repository owner.
