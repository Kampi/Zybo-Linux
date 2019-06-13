/*
 * axisegment.c
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

#include "axisegment.h"

int AxiSegment_CfgInitialize(AxiSegment* InstancePtr, AxiSegment_Config* Config)
{
    InstancePtr->BaseAddress = Config->BaseAddress;
	InstancePtr->Initialized = 1;

    return XST_SUCCESS;
}

int AxiSegment_Write(AxiSegment* InstancePtr, u8 Value)
{
    u8 Temp = 0x00;
    u8 Shift = 0x00;
    u8 ValueTemp = Value;

	if(!InstancePtr->Initialized)
	{
		return XST_FAILURE;
	}
	
	while(ValueTemp > 0) 
	{
       Temp |= (ValueTemp % 0x0A) << (Shift++ << 0x02);
       ValueTemp /= 0x0A;
    }

	AXI_SEGMENT_mWriteReg(InstancePtr->BaseAddress, AXI_SEGMENT_S_AXI_SLV_REG0_OFFSET, Temp);
	
	return XST_SUCCESS;
}