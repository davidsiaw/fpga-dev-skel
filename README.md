fpga dev skeleton
-----------------

commands

make apicula - make top with apicula
make apicula TARGET=tn9k_lcd_480_diag - make with the specified target
make wave - generate wave.vcd from test. can be read with gtkwave
make lint - lint project
make formal - run formal on project
make upload_apicula - upload using openfpgaloader
