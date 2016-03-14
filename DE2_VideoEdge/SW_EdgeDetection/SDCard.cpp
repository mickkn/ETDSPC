/*
 * SDCard.cpp
 *
 *  Created on: 12/05/2013
 *      Author: kbe
 */
#include <stdio.h>
#include <string.h>
#include "SDCard.h"
#include "system.h"
#include "alt_types.h"
#include "BmpUtil.h"


SDCard::SDCard()
{
	device_reference = NULL;
	connected = 0;
	handler = -1;
}

bool SDCard::isConnected(void)
{
	return connected == 1;
}

int SDCard::init(void)
{
	device_reference = alt_up_sd_card_open_dev(ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME);
	if (device_reference != NULL)
	{
		if ((connected == 0) && (alt_up_sd_card_is_Present()))
		{
			printf("Card connected.\n");
			if (alt_up_sd_card_is_FAT16()) {
				printf("FAT16 file system detected.\n");
			}
			else {
				printf("Unknown file system.\n");
			}
			connected = 1;
		}
		else if ((connected == 1) && (alt_up_sd_card_is_Present() == false))
		{
			printf("Card disconnected.\n");
			connected = 0;
		}
	}
	return connected;
}

int SDCard::fopen(char* file, bool create)
{
	handler = alt_up_sd_card_fopen(file, create);
	return handler;
}

int SDCard::fclose(void)
{
	if (handler != -1) {
		alt_up_sd_card_fclose(handler);
		handler = -1;
	}
	return 0;
}

int SDCard::fwrite(char *bytes, int size)
{
	int written = 0;
	for (int i = 0; i < size; i++)
	{
		if (alt_up_sd_card_write(handler, *bytes) == false)
			printf("SD write unsuccessful\n");
		else
			written++;
		bytes++;
	}
	return written;
}

int SDCard::writeAsText(char *bytes, int size)
{
	int i = 0;
	char text[10];

	for (i = 0; i < size; i++)
	{
		sprintf(text, "%d\n", bytes[i]);
		fwrite(text, strlen(text));
	}
	return i;
}

int SDCard::fread(char *bytes, int size)
{
	int number = 0;
	while ( (*bytes = alt_up_sd_card_read(handler)) != -1 && number < size)
	{
		number++;
		bytes++;
	}
	return number;
}

int SDCard::writeBmpImg(char *img, int width, int height)
{
	int written = -1;
	if (handler != -1)
	{
		BMPFileHeader FileHeader;
		BMPInfoHeader InfoHeader;

		//init headers
		FileHeader._bm_signature = 0x4D42;
		FileHeader._bm_file_size = 54 + 3 * width * height;
		FileHeader._bm_reserved = 0;
		FileHeader._bm_bitmap_data = 0x36;

		InfoHeader._bm_bitmap_size = 0;
		InfoHeader._bm_color_depth = 24; // 24
		InfoHeader._bm_compressed = 0;
		InfoHeader._bm_hor_resolution = 0;
		InfoHeader._bm_image_height = height;
		InfoHeader._bm_image_width = width;
		InfoHeader._bm_info_header_size = 40;
		InfoHeader._bm_num_colors_used = 0;
		InfoHeader._bm_num_important_colors = 0;
		InfoHeader._bm_num_of_planes = 1;
		InfoHeader._bm_ver_resolution = 0;

		fwrite((char *)&FileHeader, (int)sizeof(BMPFileHeader));
		fwrite((char *)&InfoHeader, (int)sizeof(BMPInfoHeader));

	  	written = 0;
		int row, col;
		for (row = 0; row < height; row++)
		{
			for (col = 0; col < width; col++)
			{
				char pixel = *img;	// read pixel
				// Write pixel 3 times
				alt_up_sd_card_write(handler, pixel);
				alt_up_sd_card_write(handler, pixel);
				if (alt_up_sd_card_write(handler, pixel) == false)
					printf("SD image write unsuccessful\n");
				else
					written++;
				img++; // next pixel
			}
		}

		// Close file
		fclose();
		printf("SD image write success!\n");
	}
	return written;
}

int SDCard::fclose(short int handler, char text[STR_LEN])
{
	int x = 0;
	if (handler != -1)
		alt_up_sd_card_fclose(handler);
	else
	{
		printf("File: %s",text);
		printf(" did not close properly\n");
		x = 1;
	}
	return x;
}

int SDCard::write(short int handler, char text[STR_LEN], char write_ascii)
{
	/* writing operations*/
	int err_close=0;
	if(list(list_handler, 1, text) == 0)
	{
		printf("File location does not exist, creating a new file\n");
		handler = alt_up_sd_card_fopen(text, true);
	}
	else if ( list(list_handler, 1 , text) == 1 )
	{
		handler = alt_up_sd_card_fopen(text, false);
	}
	while ((alt_up_sd_card_read(handler)) != -1){}

	if (alt_up_sd_card_write(handler, write_ascii) == false )
		printf("write unsuccessful\n");

	err_close = fclose(handler,text);
	if (err_close == 1)
		printf("SD_write operation unsuccessful...\n");
	else
		printf("SD_write operation success!\n");

	return 0;
}

int SDCard::compare_strings(char A[STR_LEN], char B[STR_LEN])
{
	int match =0 ;
	int mismatch =0;
	int x = 0;
	for(x = 0; x <=STR_LEN; x++)
	{
		if (B[x] == 46) break;
		if(x>0) if(match != 1) mismatch = 1;
		if(A[x] == B[x]) match = 1;
		else match = 0;
	}
	if(mismatch == 1) match =0;
	return match;
}

int SDCard::list(short int handler,int check, char text[STR_LEN])
{
	int int_set=0;
	handler = alt_up_sd_card_find_first("", buffer_name);
	if(check == 0)
	{
		printf("%s \n", buffer_name);
		while ((handler = alt_up_sd_card_find_next(buffer_name)) != -1) printf("%s \n", buffer_name);
		/* BEWARE!! if you accidently close alt_up_sd_card_fclose(-1), this will lock your sd card
		 * card and bring it into limbo if you try to access it.
		 */

		handler = alt_up_sd_card_find_first("", buffer_name);
		fclose(handler,text);
	}
	else if (check ==1 )
	{
		if(compare_strings(buffer_name , text))
		{
			int_set = 1;
			//printf("match found \n");
		}
		//else int_set = 0;
		//printf("%s %s\n",text, buffer_name);
		while ((handler = alt_up_sd_card_find_next(buffer_name)) != -1)
		{
			if(compare_strings(buffer_name , text))
			{
				int_set = 1;
				//printf("match found \n");
			}
			//else int_set =0;
			//printf("%s %s\n",text, buffer_name);
		}
		//printf("%s \n", buffer_name);
		/* BEWARE!! if you accidently close alt_up_sd_card_fclose(-1), this will lock your sd card
		 * card and bring it into limbo if you try to access it.
		 */
		//sd_fclose(handler,text);

		//if (int_set == 1) x = 1;
		//printf("int_set: %d\n",int_set);
	}

	return int_set;
}
