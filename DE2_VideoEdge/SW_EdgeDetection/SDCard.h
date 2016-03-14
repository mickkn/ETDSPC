/*
 * SDCard.h
 *
 *  Created on: 12/05/2013
 *      Author: kbe
 */

#ifndef SDCARD_H_
#define SDCARD_H_

#define bool bool
#include <altera_up_sd_card_avalon_interface.h>
#define STR_LEN 20

class SDCard
{
private:
	alt_up_sd_card_dev *device_reference;
	int connected;
	short int handler;
	short int list_handler;
	char buffer_name[STR_LEN];

public:
	SDCard();

	bool isConnected(void);
    int init(void);
	int fopen(char* file, bool create);
	int fwrite(char *bytes, int size);
	int fread(char *bytes, int size);
	int fclose(void);
	int writeBmpImg(char* img, int width, int height);
	int writeAsText(char *bytes, int size);

	// Below methods currently not used - only kept for inspiration
	int write(short int handler, char text[STR_LEN], char write_ascii);
	int list(short int handler,int check, char text[STR_LEN]);

private:
	int fclose(short int handler, char text[STR_LEN]);
	int compare_strings(char A[STR_LEN], char B[STR_LEN]);

};


#endif /* SDCARD_H_ */
