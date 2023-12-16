/*
	Updated to 0.3.7 by P3ti
*/
#pragma once
#include <string>
char *DumpMem(unsigned char *pAddr, int len);
extern unsigned char encrBuffer[4092];
void kyretardizeDatagram(unsigned char* buf, int len, int port, int unk);
std::string& unKyretardizeDatagram(unsigned char* buf, int len, int port, std::string& decrBuf);
std::string& kyretardizeDatagram_v2(unsigned char* buf, int len, int port, std::string& encrBuf);