# Seven segment
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Anode[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports Segment]

set_property PACKAGE_PIN T20 [get_ports {Anode[0]}]
set_property PACKAGE_PIN U20 [get_ports {Anode[1]}]
set_property PACKAGE_PIN V20 [get_ports {Anode[2]}]
set_property PACKAGE_PIN W20 [get_ports {Anode[3]}]
set_property PACKAGE_PIN V15 [get_ports {Anode[4]}]
set_property PACKAGE_PIN W15 [get_ports {Anode[5]}]
set_property PACKAGE_PIN T11 [get_ports {Anode[6]}]

set_property PACKAGE_PIN T10 [get_ports Segment]

# Buttons
set_property IOSTANDARD LVCMOS33 [get_ports {Button_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Button_tri_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Button_tri_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Button_tri_i[3]}]

set_property PACKAGE_PIN R18 [get_ports {Button_tri_i[0]}]
set_property PACKAGE_PIN P16 [get_ports {Button_tri_i[1]}]
set_property PACKAGE_PIN V16 [get_ports {Button_tri_i[2]}]
set_property PACKAGE_PIN Y16 [get_ports {Button_tri_i[3]}]

# Switches
set_property PACKAGE_PIN G15 [get_ports {Switch_tri_i[0]}]
set_property PACKAGE_PIN P15 [get_ports {Switch_tri_i[1]}]
set_property PACKAGE_PIN W13 [get_ports {Switch_tri_i[2]}]
set_property PACKAGE_PIN T16 [get_ports {Switch_tri_i[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Switch_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switch_tri_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switch_tri_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switch_tri_i[0]}]

# I2C
set_property PACKAGE_PIN V12 [get_ports IIC_0_0_scl_io]
set_property PACKAGE_PIN W16 [get_ports IIC_0_0_sda_io]

set_property IOSTANDARD LVCMOS33 [get_ports IIC_0_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_0_0_sda_io]


set_property PACKAGE_PIN J14 [get_ports Vaux6_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux6_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux6_v_p]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux7_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux7_v_p]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux14_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux14_v_p]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux15_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux15_v_p]
