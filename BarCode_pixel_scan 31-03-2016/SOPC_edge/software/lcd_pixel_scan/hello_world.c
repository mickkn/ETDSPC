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

#define switches (volatile char *) SWITCH_BASE
#define leds (char *) RED_LEDS_BASE
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

void setLed(char byte)
{
	*leds = byte;
}

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

unsigned char getSW()
{
	return *switches;
}

unsigned char getBarcode()
{
	return *barcode;
}



int main()
{

	setLCD1("Analysing...");		//Set first line on LCD

	printf("NIOS Running\n");		//Intro message from NIOS

	char test[13];
	int i;

	while(IORD_8DIRECT(BARCODE_SCAN_0_BASE, 0) == 0xFF);

	setLCD1("Barcode:");

	if (IORD_8DIRECT(BARCODE_SCAN_0_BASE, 0) == 0x80)
	{
		for (i = 0 ; i < 13 ; i++)
		{
			test[i] = IORD_8DIRECT(BARCODE_SCAN_0_BASE, 0);
		}
	}


	printf("Avalon D: ");
	for (i = 0 ; i < 13 ; i++)
	{
		printf("0x%X ", test[i]);
	}

	printf("\n");

	return 0;
}
