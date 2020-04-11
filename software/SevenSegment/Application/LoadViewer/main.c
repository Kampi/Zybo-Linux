/*
 * main.c
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

/** @file main.c
 *  @brief This program implements a simple load viewer for the digilent seven segment display PMOD.
 *         It uses the /dev/Display device from the PMOD driver to visualize the CPU load
 *
 *  @author Daniel Kampert
 *  @bug No known bugs
 */

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

FILE* File;
size_t Length = 0x00;
char* CPU = NULL;
pthread_t Thread;
int Active;
int User, Nice, System, Idle, Iowait, IRQ, SoftIRQ, Steal;

void* Update(void* vargp)
{
	while(Active)
	{
		// Read the load values
		File = fopen("/proc/stat", "r");
		if(File == NULL)
		{
			Active = 0x00;
		}
		getline(&CPU, &Length, File);
		fclose(File);

		// Calculate the CPU usage
		sscanf(CPU, "%*s %d %d %d %d %d %d %d %d", &User, &Nice, &System, &Idle, &Iowait, &IRQ, &SoftIRQ, &Steal);
		long TotalCPUTime = User + Nice + System + Idle + Iowait + IRQ + SoftIRQ + Steal;
		long TotalCPUIdle = Idle + Iowait;
		long TotalCPUUsage = TotalCPUTime - TotalCPUIdle;
		int TotalCPUPercentage = (float)TotalCPUUsage/(float)TotalCPUTime * 100.0;

		// Write the result to the display
		File = fopen("/dev/Display", "w");
		if(File == NULL)
		{
			Active = 0x00;
		}
		fwrite(&TotalCPUPercentage, 1, 1, File);
		fclose(File);

		#ifdef DEBUG
			printf("%s\n", CPU);
			printf("user - %d\n", user);
			printf("nice - %d\n", nice);
			printf("system - %d\n", system);
			printf("idle - %d\n", idle);
			printf("iowait - %d\n", iowait);
			printf("irq - %d\n", irq);
			printf("softirq - %d\n", softirq);
			printf("steal - %d\n", steal);

			printf("Total cpu time - %lu\n", TotalCPUTime);
			printf("Total CPU idle time - %lu\n", TotalCPUIdle);
			printf("Total CPU usage - %lu\n", TotalCPUUsage);
			printf("Total CPU usage rel. - %d\n", TotalCPUPercentage);
		#endif

		sleep(1);
	}
}

int main ()
{
	Active = 0x01;
	pthread_create(&Thread, NULL, Update, NULL); 
	pthread_join(Thread, NULL); 

  	return 0;
}

