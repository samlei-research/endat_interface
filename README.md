Absolute encoder VHDL core for Endat

This implementation is adjusted for the usage with the Motor Encoders in the Motors of the AMK Formula Student Kit.
The integration is done by including this source files into a AXI peripherial in a Vivado design to be synthesized onto a ZYNQ7020 SoC.
The repository can be used to understand the functionality of the EnDat protocol in simulation.

# Prerequisites

- GHDL 
- GTKWave

# How To

``cd src/ && make``

# Details

Adjusted for the use of the following motor encoder:
ECI 1118 (18 Bit Postion)

Excluded from implementation:
- com & sim folder

# Changelog

- Changed to GHDL Tools
- Added GHDL Simulation


Developer:
Samuel Leitenmaier 
Project: Formula Student Tractive System Inverter Development (Technical Uniersity of Applied Sciences Augsburg)


