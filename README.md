# CSE Bubble Processor

The CSE Bubble Processor is a processor implementation based on the MIPS architecture. It features a single-cycle fetch, decode, and execution of instructions. This readme file provides an overview of the processor design and implementation.

## Features

- Single-cycle fetch, decode, and execution of instructions.
- Arithmetic Logic Unit (ALU) with modules for R-type, I-type, and J-type instructions.
- Finite State Machine (FSM) for generating control signals.
- Support for MIPS-like Instruction Set Architecture (ISA).
- Execution of MIPS code translated to machine code following the ISA.

## Design and Implementation

The CSE Bubble Processor consists of the following key components:

1. Arithmetic Logic Unit (ALU): The ALU performs arithmetic and logical operations required by the instructions. It is designed using a top-down approach and includes modules for R-type, I-type, and J-type instructions.

2. Finite State Machine (FSM): The FSM is responsible for generating control signals required for executing the processor. It controls the flow of instructions and signals the appropriate actions based on the current state.

3. Instruction Execution: The processor executes instructions in a single cycle. It fetches each instruction from memory, decodes it to determine the operation to be performed, and executes the instruction using the ALU.

4. MIPS Code and Machine Code Translation: The Bubble Sort algorithm is implemented using MIPS assembly code. The MIPS code is then translated into machine code following the ISA of the CSE Bubble processor. The machine code represents the instructions in a binary format that the processor can understand and execute.

## Usage

To use the CSE Bubble Processor, follow these steps:

1. Set up the processor design by including the ALU, FSM, and other required components.
2. Load the MIPS code for the Bubble Sort algorithm into the processor.
3. Translate the MIPS code into machine code following the ISA of the CSE Bubble processor.
4. Execute the machine code on the processor and observe the sorting operation.

## Future Improvements

The current implementation of the CSE Bubble Processor provides a basic functionality for executing MIPS-like instructions. However, there are several areas where improvements can be made:

- Performance Optimization: Implement pipeline stages to improve processor performance and instruction throughput.
- Expanded ISA Support: Enhance the processor to support a wider range of MIPS instructions for broader applicability.
- Error Handling: Implement error detection and exception handling mechanisms to ensure proper handling of exceptional situations during execution.
- Debugging and Testing: Develop tools and techniques for debugging and testing the processor design to ensure its correctness and reliability.

## Conclusion

The CSE Bubble Processor is a single-cycle MIPS-like processor implementation with an ALU, FSM, and support for executing MIPS code. By following the provided steps, users can load MIPS code, translate it into machine code, and execute it on the processor. This readme file serves as an overview of the processor design and implementation. For more detailed information, refer to the documentation and source code of the project.
