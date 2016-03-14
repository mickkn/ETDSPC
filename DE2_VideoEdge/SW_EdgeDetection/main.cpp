/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

/*
*
* KBE/17. April 2013
*
* SoPC Demo program for simple access to LED's, Switches and LCD display
*
* Using the JTAG UART as console for sending commands:
* led <value> -> setting decimal value (0-255) on PIO_OUTPUT_0_BASE
* sw -> reads switch (0-7) from PIO_INPUT_BASE
* lcd <text> -> prints text on second line of LCD display
*/

#include <stdio.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "system.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_timestamp.h"
#include "SDCard.h"

#define CMD_LEN    100
#define IMG_WIDTH  640
#define IMG_HEIGHT 480

/****************************************************************************************
 * Draw a filled rectangle on the VGA monitor
****************************************************************************************/
void VGA_box(int x1, int y1, int x2, int y2, char pixel_color)
{
	int offset, row, col;
	/* Declare volatile pointer to pixel buffer (volatile means that IO load
	   and store instructions will be used to access these pointer locations,
	   instead of regular memory loads and stores) */
  	volatile char * pixel_buffer = (char *) PIXEL_BUFFER_BASE;	// VGA pixel buffer address

	/* assume that the box coordinates are valid */
	for (row = y1; row < y2; row++)
	{
		col = x1;
		while (col < x2)
		{
			offset = (row*IMG_WIDTH) + col;
			*(pixel_buffer + offset) = pixel_color;	// compute halfword address, set pixel
			++col;
		}
	}
}

//--------------------------------------------------------
void copyImg(char *dst, char *src, int width, int height)
{
	int row, col;
  	volatile char * pixel_buffer = src;	// VGA pixel buffer address
	for (row = 0; row < height; row++)
	{
		for (col = 0; col < width; col++)
		{
			*dst++ = *pixel_buffer++;	// read pixels
			//dst++;
			//pixel_buffer++;
		}
	}
}

//////////////////////////////////////////////////////////

int main()
{
    alt_u32 time1;
	alt_u32 time2;
	char cmd[CMD_LEN];
	char text[CMD_LEN];
	char file[CMD_LEN];
	// Image copy in SDRAM
	char img[IMG_WIDTH*IMG_HEIGHT];

	char* msg = "\x1b[1;1HSoPC Demo";
	unsigned char i_value;
	FILE *fp;
	SDCard sdCard;

    if (sdCard.init())
    {
       printf("SD card found\n");
    }

    if (alt_timestamp_start() < 0)
    {
	   printf ("No timestamp device available\n");
    }

    printf("Clock rate: %d \n", alt_timestamp_freq());

 	//VGA_box (0, 0, IMG_WIDTH, IMG_HEIGHT, 0); // clear screen
	//VGA_box (136 /*x1*/, 112 /*y1*/, 200 /*x2*/, 128 /*y2*/, 0x7f); // Grey Box

	// Opens LCD display driver
	fp = fopen (LCD_NAME, "w");
	if (fp==NULL)
		printf("Could not open LCD driver\n");
	else
		fprintf(fp, "%s", msg);

	// Set LED pattern
	IOWR_ALTERA_AVALON_PIO_DATA(GREEN_LEDS_BASE, 0xAA);
	IOWR_ALTERA_AVALON_PIO_DATA(RED_LEDS_BASE, 0x55);

	// Nios II Console welcome text
	printf("Inspection Scan SoPC program\n");
	printf("Enter command: ledr/ledg <value> | sw | lcd1/lcd2 <text>\n");
	printf("               clear | copy | save <file> | test <file> <text> \n\n");

	while(1)
	{
		printf("CMD:\\> ");
		scanf(" %s", cmd);

		// Clear pixel buffer 5 times
		if (!strcmp(cmd, "clear"))
		{
			for (int i = 0; i < 5; i++)
			{
			   VGA_box (0, 0, IMG_WIDTH, IMG_HEIGHT, 0xff); // White screen
			   printf("%d\n", i);
  			   usleep(100000); // Busy waiting 100 ms
			}
		}

		// Creates a test (*.txt) file parameters: <file> <string>
		if (!strcmp(cmd, "test"))
		{
			scanf(" %s", text);
			sprintf(file, "%s.txt", text);
			scanf(" %[^\n]", text);
			if (sdCard.fopen(file, true) != -1)
			{
				sdCard.fwrite(text, strlen(text));
				sdCard.fclose();
			}
		}

		// Copy image from pixel buffer to memory
		if (!strcmp(cmd, "copy"))
		{
			time1 = alt_timestamp();
   		    copyImg(img, PIXEL_BUFFER_BASE, IMG_WIDTH, IMG_HEIGHT);
			time2 = alt_timestamp();
			printf("Copy image time: %d ticks\n\n", time2-time1);
		}

		// Save copy of image in text file
		if (!strcmp(cmd, "save"))
		{
			scanf(" %s", text);
			if (strlen(text) > 0) // Empty string
				sprintf(file, "%s.bmp", text);
			else
				strcpy(file, "img.bmp");

			// Works only if image already exists
			if (sdCard.fopen(file, false) != -1)
			{
				sdCard.writeBmpImg(img, IMG_WIDTH, IMG_HEIGHT);
				//sdCard.writeAsText(img, IMG_WIDTH*6); // Error when file too big..
				//sdCard.fwrite(img, IMG_WIDTH*IMG_HEIGHT);
				//sdCard.fclose();
			} else
			{
				printf("Failed to save image %s\n", file);
			}
		}

		// LED command red
		if (!strcmp(cmd, "ledr"))
		{
			scanf(" %d", &i_value);
			// Writes to memory mapped PIO block
			IOWR_ALTERA_AVALON_PIO_DATA(RED_LEDS_BASE, i_value);
			printf("LED val:%d\n",i_value);
		}

		// LED command green
		if (!strcmp(cmd, "ledg"))
		{
			scanf(" %d", &i_value);
			// Writes to memory mapped PIO block
			IOWR_ALTERA_AVALON_PIO_DATA(GREEN_LEDS_BASE, i_value);
			printf("LED val:%d\n",i_value);
		}

		// Switch command
		if (!strcmp(cmd, "sw"))
		{
			// Reads from memory mapped PIO block
			printf("SW val: %02X\n", IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE));
		}

		// LCD command line 1
		if (!strcmp(cmd, "lcd1"))
		{
			// Uses SW driver to access LCD block
			scanf(" %[^\n]", text);
			fprintf(fp, "\x1B[1;1H"); // VT100 control command moves cursor left to second display line
			fprintf(fp, "%s", text);
		}

		// LCD command line 2
		if (!strcmp(cmd, "lcd2"))
		{
			// Uses SW driver to access LCD block
			scanf(" %[^\n]", text);
			fprintf(fp, "\x1B[2;1H"); // VT100 control command moves cursor left to second display line
			fprintf(fp, "%s", text);
		}

		usleep(500000); // Busy waiting 0.5 sec.
	}

	fclose (fp);
}
