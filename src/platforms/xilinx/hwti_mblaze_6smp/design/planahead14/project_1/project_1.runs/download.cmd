setMode -bscan
setCable -p auto
identify
assignfile -p 2 -file config_2.bit
program -p 2
quit