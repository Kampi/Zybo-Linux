/*
 * axisegment_sinit.h
 *
 *  Copyright (C) Daniel Kampert, 2018
 *	Website: www.kampis-elektroecke.de

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

/*******************************************************************************/
/*
*
* @file axisegment_sinit.c
*
* This file contains the implementation of the Axisegment driver's static
* initialization functionality.
*
* @note 	None.
*
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who    Date		Changes
* ----- -----  -------- -----------------------------------------------
* 1.00  dk     09/01/18 First release
*
* </pre>
*
********************************************************************************/

#include "xparameters.h"
#include "axisegment.h"


AxiSegment_Config* AxiSegment_LookupConfig(u16 DeviceId)
{
	AxiSegment_Config* CfgPtr = NULL;
    extern AxiSegment_Config AxiSegment_ConfigTable[];

	for(u32 Index = 0; Index < XPAR_AXISEGMENT_NUM_INSTANCES; Index++) 
	{
		if(AxiSegment_ConfigTable[Index].DeviceId == DeviceId) 
		{
			CfgPtr = &AxiSegment_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}
