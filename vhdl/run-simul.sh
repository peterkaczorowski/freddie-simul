ghdl -a -fsynopsys --std=08 freddie.vhd tb_freddie.vhd
ghdl -e -fsynopsys --std=08 freddie_tb
ghdl -r -fsynopsys --std=08 freddie_tb --vcd=freddie.vcd --wave=freddie.ghw --stop-time=2800ns
