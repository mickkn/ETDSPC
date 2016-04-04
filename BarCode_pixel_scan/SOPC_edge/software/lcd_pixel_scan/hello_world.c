#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "system.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_timestamp.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_lcd_16207.h"
#include "altera_avalon_lcd_16207_regs.h"

#define lcd LCD_NAME
#define barcode (volatile char *) BARCODE_SCAN_0_BASE

#define STR_EXPAND(tok) #tok
#define STR(tok)        STR_EXPAND(tok)
// Moves the cursor to the y,x position specified - counted from top left corner
#define SET_POS(y,x)    "\x1b[" STR(y) ";" STR(x) "H"
// Clears from current position to end of line
#define CLR_LINE()      "\x1b[K"
// Clears the whole screen
#define CLR_SCR()       "\x1b[2J"

typedef union {
	unsigned char comp[4];
	unsigned int vect;
	} vectorType;

FILE *fp;

void setLCD1(char *text)
{
	char* msg_prefix = "\x1b ";
	char* msg = malloc(strlen(text)+6);

	strcpy(msg, msg_prefix);
	strcat(msg, text);

	fp = fopen(lcd, "w");

	fprintf(fp, "%s", SET_POS(1,1));
	fprintf(fp, "%s", CLR_LINE());
	fprintf(fp, "%s", msg);

	fclose(fp);
}

void setLCD2(char *text)
{
	char* msg_prefix = "\x1b ";
	char* msg = malloc(strlen(text)+6);

	strcpy(msg, msg_prefix);
	strcat(msg, text);

	fp = fopen(lcd, "w");

	fprintf(fp, "%s", SET_POS(2,1));
	fprintf(fp, "%s", CLR_LINE());
	fprintf(fp, "%s", msg);

	fclose(fp);
}

int main()
{
	printf("NIOS Running\n");		//Intro message from NIOS in console

	int temp_barCode[14];			//Integer array to obtain numbers from MM-bus
	char barCode[14];				//Char array to print on 16x2 LCD display

	while(1)
	{
		if(IORD_8DIRECT(BARCODE_SCAN_0_BASE, 0) == 0xFF)
		{
			setLCD1("Analysing...");		//Set first line on LCD
			setLCD2("");					//Set second line on LCD
		}
		else
		{
			int i;
			for(i = 0 ; i < 13 ; i++)
			{
				temp_barCode[i] = IORD_8DIRECT(BARCODE_SCAN_0_BASE, 0);	//Read MM-bus data 8-bit
				barCode[i] = '0' + temp_barCode[i];						//Convert to char array
			}
			setLCD1("Barcode:");		//Set first line on LCD
			barCode[13] = '\0';			//Zero termination
			setLCD2(barCode);			//Put barcode number from mm-bus to LCD second line
			break;						//Exit the program
		}
	}
	return 0;
}
