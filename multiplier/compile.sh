#!/bin/sh

iverilog -o test *.v
vvp test
gtkwave.exe debug.vcd