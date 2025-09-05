General Purpose Input Output (GPIO) Protocol – APB Based

This project implements a General Purpose Input/Output (GPIO) controller compliant with the AMBA 3 APB (Advanced Peripheral Bus) protocol. The design is modular, scalable, and supports interrupts and auxiliary inputs for advanced SoC integration.

📌 Features

APB Compliant – Seamless communication with AMBA 3 APB protocol.

32 Configurable GPIO Lines – Each pin can be set as input, output, or bi-directional.

Interrupt Support – Rising/falling edge detection per GPIO line.

Auxiliary Input Multiplexing – Allows internal signals to be directly driven onto GPIO pins.

I/O Interface – Supports tri-state and open-drain configurations.

Synchronized Input – External clock edge synchronization supported via ECLK and NEC.

⚙️ Architecture Overview

The design is divided into the following main blocks:

APB Host Interface

Handles APB read/write transactions.

Decodes register addresses and synchronizes with system clock.
<img width="623" height="625" alt="image" src="https://github.com/user-attachments/assets/445b95d2-0043-4556-853a-bb01a2293f41" />


GPIO Registers

Configures input/output modes, interrupt triggers, and output values.

Key registers include RGPIO_IN, RGPIO_OUT, RGPIO_OE, RGPIO_INTE, and RGPIO_CTRL.

Auxiliary Input Block

Allows multiplexing of internal signals onto GPIO lines.

Controlled by the RGPIO_AUX register.

I/O Interface

Connects GPIO logic to external chip pads.

Manages bidirectional control, tri-state, and open-drain modes.

Interrupt Generation

Rising/falling edge detection logic.

Sets status flags (RGPIO_INTS) and asserts interrupt requests.

🏗️ Top Module Functionality

Receives APB transactions from the master.

Updates GPIO registers based on decoded address and control signals.

Controls GPIO outputs or samples external inputs.

Generates interrupts when enabled.

Supports auxiliary input override.

Key Signals:

Inputs: PCLK, PRESETn, PADDR, PWDATA, PWRITE, PSEL, PENABLE

Outputs: PRDATA, PREADY, IRQ

External Pads: in_pad_i, out_pad_o, oen_padoen_o, ext_clk_pad_i

📊 Verification

Waveform simulations confirm correct functionality of:

APB Slave Interface transactions.

GPIO Register reads/writes.

Auxiliary input multiplexing.

I/O pad driving and synchronization.

Interrupt generation and edge detection.

✅ Conclusion

This project successfully implements an APB-compliant GPIO controller with support for:

Multiple I/O modes,

Interrupt-driven control, and

Auxiliary input flexibility.

It provides a reusable and scalable IP block suitable for SoC and FPGA designs.
