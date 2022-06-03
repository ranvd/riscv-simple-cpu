#!/bin/bash

iverilog -o debug/iftest *.v
vvp debug/iftest
gtkwave.exe debug/debug.vcd
rm debug/*