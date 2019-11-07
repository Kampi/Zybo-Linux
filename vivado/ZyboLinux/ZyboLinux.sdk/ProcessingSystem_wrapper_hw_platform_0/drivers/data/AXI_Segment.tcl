proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AxiSegment" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
	xdefine_config_file $drv_handle "AxiSegment_g.c" "AxiSegment" "DEVICE_ID" "C_S_AXI_BASEADDR"
}
