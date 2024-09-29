# Synchronous FIFO Verification Project

## Overview

This repository contains the SystemVerilog code for a **Synchronous FIFO Design** and its **verification**. The project was developed to verify the functionality and robustness of a First-In-First-Out (FIFO) memory buffer, handling synchronous read and write operations. It includes a complete testbench, assertions, coverage metrics, and more.

## Features

- **FIFO Design**: Includes a parametrizable FIFO model with depth and width settings.
- **Assertions**: Embedded assertions to verify FIFO behavior under different conditions, including full, empty, almost full, and almost empty states.
- **Testbench**: A comprehensive testbench that runs various test scenarios, including write-only, read-only, and mixed operations.
- **Scoreboard & Coverage**: Implements a scoreboard for checking data integrity and coverage metrics to ensure functional completeness.

## Repository Contents

1. **Design RTL**  
   - The core FIFO module is located in `FIFO.sv`, which includes assertions to validate key FIFO properties.
   
2. **Detected Bugs**  
   - Documentation of bugs discovered during the development process and how they were fixed.

3. **Verification Plan**  
   - Detailed plan for verifying the FIFO, ensuring coverage of all edge cases, available in `verification_plan.pdf`.

4. **Verification Code**  
   - Several SystemVerilog packages are used for verification:
     - **Interface Package**: Defines the interface between the testbench and the FIFO.
     - **Shared Package**: Contains shared variables like error count and status flags.
     - **Transaction Package**: Defines the transactions for reading and writing to the FIFO.
     - **Coverage Package**: Implements functional coverage metrics.
     - **Testbench**: Runs the simulation scenarios.
     - **Scoreboard**: Implements the reference model to verify data correctness.
     - **Monitor**: Observes the signals and connects transactions to the FIFO.

5. **Do File**  
   - Contains the simulation script for running tests, located in `fifo.do`.

6. **Waveforms**  
   - Captured waveform of the FIFO behavior during simulation, saved in the `waveforms` folder.

7. **Code Coverage**  
   - Includes reports generated for code coverage.

8. **Assertion & Functional Coverage**  
   - Assertion and functional coverage metrics are tracked to ensure thorough verification.
