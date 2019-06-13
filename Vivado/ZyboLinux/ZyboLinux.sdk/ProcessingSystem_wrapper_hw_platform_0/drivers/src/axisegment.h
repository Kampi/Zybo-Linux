/*
 * axisegment.h
 *
 *  Copyright (C) Daniel Kampert, 2018
 *	Website: www.kampis-elektroecke.de
 *  File info: Driver for digilent SSD PMOD

  GNU GENERAL PUBLIC LICENSE:
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

  Errors and commissions should be reported to DanielKampert@kampis-elektroecke.de
 */

#ifndef AXISEGMENT_H
#define AXISEGMENT_H

 #include "xil_io.h"
 #include "xstatus.h"
 #include "xil_types.h"

 /** 
  * Register offset
  */
 #define AXI_SEGMENT_S_AXI_SLV_REG0_OFFSET  0					/**< Register 0 */
 #define AXI_SEGMENT_S_AXI_SLV_REG1_OFFSET  4					/**< Register 1 */
 #define AXI_SEGMENT_S_AXI_SLV_REG2_OFFSET  8					/**< Register 2 */
 #define AXI_SEGMENT_S_AXI_SLV_REG3_OFFSET  12					/**< Register 3 */

 /** 
  * Seven segment configuration object
  */
 typedef struct 
 {
	 u16 DeviceId;                                              /**< Unique ID of the device */
	 u32 BaseAddress;		                                    /**< Device base address */
 } AxiSegment_Config;

 /** 
  * Seven segment object
  */
 typedef struct 
 {
     u32 BaseAddress;		                                    /**< Device base address */
	 u32 Initialized;			                                /**< Device is initialized and ready */
 } AxiSegment;

 /**************************** Type Definitions *****************************/
 /**
  *
  * Write a value to a AXI_SEGMENT register. A 32 bit write is performed.
  * If the component is implemented in a smaller width, only the least
  * significant data is written.
  *
  * @param   BaseAddress is the base address of the AXI_SEGMENTdevice.
  * @param   RegOffset is the register offset from the base to write to.
  * @param   Data is the data written to the register.
  *
  * @return  None.
  *
  * @note
  * C-style signature:
  * 	void AXI_SEGMENT_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
  *
  */
 #define AXI_SEGMENT_mWriteReg(BaseAddress, RegOffset, Data)    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

 /**
  *
  * Read a value from a AXI_SEGMENT register. A 32 bit read is performed.
  * If the component is implemented in a smaller width, only the least
  * significant data is read from the register. The most significant data
  * will be read as 0.
  *
  * @param   BaseAddress is the base address of the AXI_SEGMENT device.
  * @param   RegOffset is the register offset from the base to write to.
  *
  * @return  Data is the data from the register.
  *
  * @note
  * C-style signature:
  * 	u32 AXI_SEGMENT_mReadReg(u32 BaseAddress, unsigned RegOffset)
  *
  */
 #define AXI_SEGMENT_mReadReg(BaseAddress, RegOffset) 			Xil_In32((BaseAddress) + (RegOffset))
 
 /** @brief				Look up the hardware configuration for a device instance
  *  @param DeviceId    Unique device ID of the device to lookup for
  *  @return            The configuration structure for the device. If the device ID is not found, a NULL pointer is returned
  */
 AxiSegment_Config* AxiSegment_LookupConfig(u16 DeviceId);
 
 /** @brief				This function initializes a seven segment display. This function must be called prior to using a seven segment display.
  *  @param InstancePtr Pointer to the seven segment display instance to be worked on
  *  @param Config     	Pointer to an AxiSegment_Config structure
  *  @return            *XST_SUCCESS for successful initialization
  */
 int AxiSegment_CfgInitialize(AxiSegment* InstancePtr, AxiSegment_Config* Config);
 
 /** @brief				Write a new value to the seven segment display.
  *  @param InstancePtr Pointer to the seven segment display instance to be worked on
  *  @param Callback    Display value
  *  @return            *XST_SUCCESS when successful
  */
 int AxiSegment_Write(AxiSegment* InstancePtr, u8 Value);

#endif // AXISEGMENT_H