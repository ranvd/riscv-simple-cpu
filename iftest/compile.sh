#!/bin/bash
iverilog -o iftest *.v
vvp iftest
gtkwave.exe debug.vcd
