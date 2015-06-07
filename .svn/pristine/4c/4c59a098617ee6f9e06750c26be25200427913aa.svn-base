	// Instantiate threads and thread attribute structures
	hthread_t threads[120];
	hthread_attr_t attr[120];
	unsigned int ee = 0;
	for(ee = 0; ee < 120; ee++) {
		hthread_attr_init(&attr[ee]);
		hthread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[120];
	/*************** Package 0 **********/
	// Initalize the size for this package
	package[0].sort_size = 64;
	package[0].crc_size = 2048;
	package[0].vector_size = 1024;
	
	/*************** Package 1 **********/
	// Initalize the size for this package
	package[1].sort_size = 1024;
	package[1].crc_size = 4095;
	package[1].vector_size = 1024;
	
	/*************** Package 2 **********/
	// Initalize the size for this package
	package[2].sort_size = 512;
	package[2].crc_size = 256;
	package[2].vector_size = 2048;
	
	/*************** Package 3 **********/
	// Initalize the size for this package
	package[3].sort_size = 2048;
	package[3].crc_size = 256;
	package[3].vector_size = 64;
	
	/*************** Package 4 **********/
	// Initalize the size for this package
	package[4].sort_size = 128;
	package[4].crc_size = 1024;
	package[4].vector_size = 1024;
	
	/*************** Package 5 **********/
	// Initalize the size for this package
	package[5].sort_size = 1024;
	package[5].crc_size = 64;
	package[5].vector_size = 1024;
	
	/*************** Package 6 **********/
	// Initalize the size for this package
	package[6].sort_size = 128;
	package[6].crc_size = 4095;
	package[6].vector_size = 512;
	
	/*************** Package 7 **********/
	// Initalize the size for this package
	package[7].sort_size = 4095;
	package[7].crc_size = 128;
	package[7].vector_size = 64;
	
	/*************** Package 8 **********/
	// Initalize the size for this package
	package[8].sort_size = 4095;
	package[8].crc_size = 64;
	package[8].vector_size = 256;
	
	/*************** Package 9 **********/
	// Initalize the size for this package
	package[9].sort_size = 2048;
	package[9].crc_size = 2048;
	package[9].vector_size = 64;
	
	/*************** Package 10 **********/
	// Initalize the size for this package
	package[10].sort_size = 4095;
	package[10].crc_size = 1024;
	package[10].vector_size = 4095;
	
	/*************** Package 11 **********/
	// Initalize the size for this package
	package[11].sort_size = 256;
	package[11].crc_size = 2048;
	package[11].vector_size = 128;
	
	/*************** Package 12 **********/
	// Initalize the size for this package
	package[12].sort_size = 64;
	package[12].crc_size = 128;
	package[12].vector_size = 256;
	
	/*************** Package 13 **********/
	// Initalize the size for this package
	package[13].sort_size = 128;
	package[13].crc_size = 256;
	package[13].vector_size = 256;
	
	/*************** Package 14 **********/
	// Initalize the size for this package
	package[14].sort_size = 128;
	package[14].crc_size = 256;
	package[14].vector_size = 512;
	
	/*************** Package 15 **********/
	// Initalize the size for this package
	package[15].sort_size = 512;
	package[15].crc_size = 2048;
	package[15].vector_size = 64;
	
	/*************** Package 16 **********/
	// Initalize the size for this package
	package[16].sort_size = 1024;
	package[16].crc_size = 2048;
	package[16].vector_size = 1024;
	
	/*************** Package 17 **********/
	// Initalize the size for this package
	package[17].sort_size = 4095;
	package[17].crc_size = 128;
	package[17].vector_size = 1024;
	
	/*************** Package 18 **********/
	// Initalize the size for this package
	package[18].sort_size = 1024;
	package[18].crc_size = 2048;
	package[18].vector_size = 256;
	
	/*************** Package 19 **********/
	// Initalize the size for this package
	package[19].sort_size = 2048;
	package[19].crc_size = 1024;
	package[19].vector_size = 4095;
	
	/*************** Package 20 **********/
	// Initalize the size for this package
	package[20].sort_size = 1024;
	package[20].crc_size = 64;
	package[20].vector_size = 4095;
	
	/*************** Package 21 **********/
	// Initalize the size for this package
	package[21].sort_size = 64;
	package[21].crc_size = 64;
	package[21].vector_size = 4095;
	
	/*************** Package 22 **********/
	// Initalize the size for this package
	package[22].sort_size = 512;
	package[22].crc_size = 1024;
	package[22].vector_size = 256;
	
	/*************** Package 23 **********/
	// Initalize the size for this package
	package[23].sort_size = 1024;
	package[23].crc_size = 512;
	package[23].vector_size = 1024;
	
	/*************** Package 24 **********/
	// Initalize the size for this package
	package[24].sort_size = 128;
	package[24].crc_size = 4095;
	package[24].vector_size = 2048;
	
	/*************** Package 25 **********/
	// Initalize the size for this package
	package[25].sort_size = 256;
	package[25].crc_size = 64;
	package[25].vector_size = 64;
	
	/*************** Package 26 **********/
	// Initalize the size for this package
	package[26].sort_size = 256;
	package[26].crc_size = 64;
	package[26].vector_size = 2048;
	
	/*************** Package 27 **********/
	// Initalize the size for this package
	package[27].sort_size = 1024;
	package[27].crc_size = 512;
	package[27].vector_size = 1024;
	
	/*************** Package 28 **********/
	// Initalize the size for this package
	package[28].sort_size = 512;
	package[28].crc_size = 1024;
	package[28].vector_size = 128;
	
	/*************** Package 29 **********/
	// Initalize the size for this package
	package[29].sort_size = 64;
	package[29].crc_size = 256;
	package[29].vector_size = 64;
	
	/*************** Package 30 **********/
	// Initalize the size for this package
	package[30].sort_size = 4095;
	package[30].crc_size = 4095;
	package[30].vector_size = 128;
	
	/*************** Package 31 **********/
	// Initalize the size for this package
	package[31].sort_size = 512;
	package[31].crc_size = 128;
	package[31].vector_size = 256;
	
	/*************** Package 32 **********/
	// Initalize the size for this package
	package[32].sort_size = 64;
	package[32].crc_size = 256;
	package[32].vector_size = 512;
	
	/*************** Package 33 **********/
	// Initalize the size for this package
	package[33].sort_size = 128;
	package[33].crc_size = 256;
	package[33].vector_size = 128;
	
	/*************** Package 34 **********/
	// Initalize the size for this package
	package[34].sort_size = 512;
	package[34].crc_size = 256;
	package[34].vector_size = 1024;
	
	/*************** Package 35 **********/
	// Initalize the size for this package
	package[35].sort_size = 1024;
	package[35].crc_size = 512;
	package[35].vector_size = 4095;
	
	/*************** Package 36 **********/
	// Initalize the size for this package
	package[36].sort_size = 1024;
	package[36].crc_size = 1024;
	package[36].vector_size = 512;
	
	/*************** Package 37 **********/
	// Initalize the size for this package
	package[37].sort_size = 128;
	package[37].crc_size = 4095;
	package[37].vector_size = 128;
	
	/*************** Package 38 **********/
	// Initalize the size for this package
	package[38].sort_size = 2048;
	package[38].crc_size = 512;
	package[38].vector_size = 512;
	
	/*************** Package 39 **********/
	// Initalize the size for this package
	package[39].sort_size = 2048;
	package[39].crc_size = 512;
	package[39].vector_size = 4095;
	
	/*************** Package 40 **********/
	// Initalize the size for this package
	package[40].sort_size = 1024;
	package[40].crc_size = 64;
	package[40].vector_size = 512;
	
	/*************** Package 41 **********/
	// Initalize the size for this package
	package[41].sort_size = 64;
	package[41].crc_size = 512;
	package[41].vector_size = 512;
	
	/*************** Package 42 **********/
	// Initalize the size for this package
	package[42].sort_size = 2048;
	package[42].crc_size = 128;
	package[42].vector_size = 512;
	
	/*************** Package 43 **********/
	// Initalize the size for this package
	package[43].sort_size = 256;
	package[43].crc_size = 128;
	package[43].vector_size = 64;
	
	/*************** Package 44 **********/
	// Initalize the size for this package
	package[44].sort_size = 512;
	package[44].crc_size = 256;
	package[44].vector_size = 64;
	
	/*************** Package 45 **********/
	// Initalize the size for this package
	package[45].sort_size = 128;
	package[45].crc_size = 256;
	package[45].vector_size = 4095;
	
	/*************** Package 46 **********/
	// Initalize the size for this package
	package[46].sort_size = 256;
	package[46].crc_size = 64;
	package[46].vector_size = 512;
	
	/*************** Package 47 **********/
	// Initalize the size for this package
	package[47].sort_size = 256;
	package[47].crc_size = 4095;
	package[47].vector_size = 64;
	
	/*************** Package 48 **********/
	// Initalize the size for this package
	package[48].sort_size = 512;
	package[48].crc_size = 128;
	package[48].vector_size = 4095;
	
	/*************** Package 49 **********/
	// Initalize the size for this package
	package[49].sort_size = 4095;
	package[49].crc_size = 256;
	package[49].vector_size = 1024;
	
	/*************** Package 50 **********/
	// Initalize the size for this package
	package[50].sort_size = 512;
	package[50].crc_size = 4095;
	package[50].vector_size = 512;
	
	/*************** Package 51 **********/
	// Initalize the size for this package
	package[51].sort_size = 256;
	package[51].crc_size = 256;
	package[51].vector_size = 2048;
	
	/*************** Package 52 **********/
	// Initalize the size for this package
	package[52].sort_size = 1024;
	package[52].crc_size = 4095;
	package[52].vector_size = 512;
	
	/*************** Package 53 **********/
	// Initalize the size for this package
	package[53].sort_size = 256;
	package[53].crc_size = 2048;
	package[53].vector_size = 256;
	
	/*************** Package 54 **********/
	// Initalize the size for this package
	package[54].sort_size = 2048;
	package[54].crc_size = 256;
	package[54].vector_size = 1024;
	
	/*************** Package 55 **********/
	// Initalize the size for this package
	package[55].sort_size = 1024;
	package[55].crc_size = 64;
	package[55].vector_size = 2048;
	
	/*************** Package 56 **********/
	// Initalize the size for this package
	package[56].sort_size = 256;
	package[56].crc_size = 1024;
	package[56].vector_size = 4095;
	
	/*************** Package 57 **********/
	// Initalize the size for this package
	package[57].sort_size = 256;
	package[57].crc_size = 512;
	package[57].vector_size = 4095;
	
	/*************** Package 58 **********/
	// Initalize the size for this package
	package[58].sort_size = 4095;
	package[58].crc_size = 256;
	package[58].vector_size = 512;
	
	/*************** Package 59 **********/
	// Initalize the size for this package
	package[59].sort_size = 1024;
	package[59].crc_size = 256;
	package[59].vector_size = 4095;
	
	/*************** Package 60 **********/
	// Initalize the size for this package
	package[60].sort_size = 128;
	package[60].crc_size = 512;
	package[60].vector_size = 256;
	
	/*************** Package 61 **********/
	// Initalize the size for this package
	package[61].sort_size = 64;
	package[61].crc_size = 2048;
	package[61].vector_size = 256;
	
	/*************** Package 62 **********/
	// Initalize the size for this package
	package[62].sort_size = 256;
	package[62].crc_size = 512;
	package[62].vector_size = 64;
	
	/*************** Package 63 **********/
	// Initalize the size for this package
	package[63].sort_size = 128;
	package[63].crc_size = 512;
	package[63].vector_size = 512;
	
	/*************** Package 64 **********/
	// Initalize the size for this package
	package[64].sort_size = 256;
	package[64].crc_size = 2048;
	package[64].vector_size = 2048;
	
	/*************** Package 65 **********/
	// Initalize the size for this package
	package[65].sort_size = 64;
	package[65].crc_size = 128;
	package[65].vector_size = 64;
	
	/*************** Package 66 **********/
	// Initalize the size for this package
	package[66].sort_size = 512;
	package[66].crc_size = 4095;
	package[66].vector_size = 256;
	
	/*************** Package 67 **********/
	// Initalize the size for this package
	package[67].sort_size = 256;
	package[67].crc_size = 128;
	package[67].vector_size = 512;
	
	/*************** Package 68 **********/
	// Initalize the size for this package
	package[68].sort_size = 4095;
	package[68].crc_size = 1024;
	package[68].vector_size = 4095;
	
	/*************** Package 69 **********/
	// Initalize the size for this package
	package[69].sort_size = 128;
	package[69].crc_size = 128;
	package[69].vector_size = 4095;
	
	/*************** Package 70 **********/
	// Initalize the size for this package
	package[70].sort_size = 2048;
	package[70].crc_size = 2048;
	package[70].vector_size = 128;
	
	/*************** Package 71 **********/
	// Initalize the size for this package
	package[71].sort_size = 128;
	package[71].crc_size = 512;
	package[71].vector_size = 128;
	
	/*************** Package 72 **********/
	// Initalize the size for this package
	package[72].sort_size = 256;
	package[72].crc_size = 1024;
	package[72].vector_size = 128;
	
	/*************** Package 73 **********/
	// Initalize the size for this package
	package[73].sort_size = 4095;
	package[73].crc_size = 64;
	package[73].vector_size = 256;
	
	/*************** Package 74 **********/
	// Initalize the size for this package
	package[74].sort_size = 2048;
	package[74].crc_size = 1024;
	package[74].vector_size = 1024;
	
	/*************** Package 75 **********/
	// Initalize the size for this package
	package[75].sort_size = 1024;
	package[75].crc_size = 512;
	package[75].vector_size = 512;
	
	/*************** Package 76 **********/
	// Initalize the size for this package
	package[76].sort_size = 128;
	package[76].crc_size = 2048;
	package[76].vector_size = 2048;
	
	/*************** Package 77 **********/
	// Initalize the size for this package
	package[77].sort_size = 512;
	package[77].crc_size = 128;
	package[77].vector_size = 256;
	
	/*************** Package 78 **********/
	// Initalize the size for this package
	package[78].sort_size = 2048;
	package[78].crc_size = 2048;
	package[78].vector_size = 2048;
	
	/*************** Package 79 **********/
	// Initalize the size for this package
	package[79].sort_size = 256;
	package[79].crc_size = 4095;
	package[79].vector_size = 512;
	
	/*************** Package 80 **********/
	// Initalize the size for this package
	package[80].sort_size = 4095;
	package[80].crc_size = 2048;
	package[80].vector_size = 512;
	
	/*************** Package 81 **********/
	// Initalize the size for this package
	package[81].sort_size = 512;
	package[81].crc_size = 4095;
	package[81].vector_size = 64;
	
	/*************** Package 82 **********/
	// Initalize the size for this package
	package[82].sort_size = 512;
	package[82].crc_size = 64;
	package[82].vector_size = 2048;
	
	/*************** Package 83 **********/
	// Initalize the size for this package
	package[83].sort_size = 512;
	package[83].crc_size = 1024;
	package[83].vector_size = 512;
	
	/*************** Package 84 **********/
	// Initalize the size for this package
	package[84].sort_size = 64;
	package[84].crc_size = 512;
	package[84].vector_size = 128;
	
	/*************** Package 85 **********/
	// Initalize the size for this package
	package[85].sort_size = 512;
	package[85].crc_size = 256;
	package[85].vector_size = 128;
	
	/*************** Package 86 **********/
	// Initalize the size for this package
	package[86].sort_size = 256;
	package[86].crc_size = 1024;
	package[86].vector_size = 4095;
	
	/*************** Package 87 **********/
	// Initalize the size for this package
	package[87].sort_size = 2048;
	package[87].crc_size = 128;
	package[87].vector_size = 64;
	
	/*************** Package 88 **********/
	// Initalize the size for this package
	package[88].sort_size = 4095;
	package[88].crc_size = 1024;
	package[88].vector_size = 2048;
	
	/*************** Package 89 **********/
	// Initalize the size for this package
	package[89].sort_size = 4095;
	package[89].crc_size = 256;
	package[89].vector_size = 128;
	
	/*************** Package 90 **********/
	// Initalize the size for this package
	package[90].sort_size = 64;
	package[90].crc_size = 128;
	package[90].vector_size = 256;
	
	/*************** Package 91 **********/
	// Initalize the size for this package
	package[91].sort_size = 2048;
	package[91].crc_size = 2048;
	package[91].vector_size = 1024;
	
	/*************** Package 92 **********/
	// Initalize the size for this package
	package[92].sort_size = 512;
	package[92].crc_size = 2048;
	package[92].vector_size = 1024;
	
	/*************** Package 93 **********/
	// Initalize the size for this package
	package[93].sort_size = 128;
	package[93].crc_size = 1024;
	package[93].vector_size = 2048;
	
	/*************** Package 94 **********/
	// Initalize the size for this package
	package[94].sort_size = 64;
	package[94].crc_size = 1024;
	package[94].vector_size = 256;
	
	/*************** Package 95 **********/
	// Initalize the size for this package
	package[95].sort_size = 4095;
	package[95].crc_size = 128;
	package[95].vector_size = 256;
	
	/*************** Package 96 **********/
	// Initalize the size for this package
	package[96].sort_size = 256;
	package[96].crc_size = 512;
	package[96].vector_size = 2048;
	
	/*************** Package 97 **********/
	// Initalize the size for this package
	package[97].sort_size = 256;
	package[97].crc_size = 512;
	package[97].vector_size = 512;
	
	/*************** Package 98 **********/
	// Initalize the size for this package
	package[98].sort_size = 2048;
	package[98].crc_size = 64;
	package[98].vector_size = 256;
	
	/*************** Package 99 **********/
	// Initalize the size for this package
	package[99].sort_size = 4095;
	package[99].crc_size = 512;
	package[99].vector_size = 4095;
	
	/*************** Package 100 **********/
	// Initalize the size for this package
	package[100].sort_size = 2048;
	package[100].crc_size = 1024;
	package[100].vector_size = 512;
	
	/*************** Package 101 **********/
	// Initalize the size for this package
	package[101].sort_size = 128;
	package[101].crc_size = 2048;
	package[101].vector_size = 512;
	
	/*************** Package 102 **********/
	// Initalize the size for this package
	package[102].sort_size = 256;
	package[102].crc_size = 1024;
	package[102].vector_size = 4095;
	
	/*************** Package 103 **********/
	// Initalize the size for this package
	package[103].sort_size = 512;
	package[103].crc_size = 128;
	package[103].vector_size = 128;
	
	/*************** Package 104 **********/
	// Initalize the size for this package
	package[104].sort_size = 512;
	package[104].crc_size = 2048;
	package[104].vector_size = 1024;
	
	/*************** Package 105 **********/
	// Initalize the size for this package
	package[105].sort_size = 256;
	package[105].crc_size = 1024;
	package[105].vector_size = 128;
	
	/*************** Package 106 **********/
	// Initalize the size for this package
	package[106].sort_size = 512;
	package[106].crc_size = 512;
	package[106].vector_size = 4095;
	
	/*************** Package 107 **********/
	// Initalize the size for this package
	package[107].sort_size = 128;
	package[107].crc_size = 2048;
	package[107].vector_size = 1024;
	
	/*************** Package 108 **********/
	// Initalize the size for this package
	package[108].sort_size = 512;
	package[108].crc_size = 256;
	package[108].vector_size = 1024;
	
	/*************** Package 109 **********/
	// Initalize the size for this package
	package[109].sort_size = 128;
	package[109].crc_size = 4095;
	package[109].vector_size = 256;
	
	/*************** Package 110 **********/
	// Initalize the size for this package
	package[110].sort_size = 4095;
	package[110].crc_size = 4095;
	package[110].vector_size = 64;
	
	/*************** Package 111 **********/
	// Initalize the size for this package
	package[111].sort_size = 1024;
	package[111].crc_size = 2048;
	package[111].vector_size = 2048;
	
	/*************** Package 112 **********/
	// Initalize the size for this package
	package[112].sort_size = 2048;
	package[112].crc_size = 4095;
	package[112].vector_size = 128;
	
	/*************** Package 113 **********/
	// Initalize the size for this package
	package[113].sort_size = 128;
	package[113].crc_size = 4095;
	package[113].vector_size = 2048;
	
	/*************** Package 114 **********/
	// Initalize the size for this package
	package[114].sort_size = 256;
	package[114].crc_size = 1024;
	package[114].vector_size = 2048;
	
	/*************** Package 115 **********/
	// Initalize the size for this package
	package[115].sort_size = 256;
	package[115].crc_size = 512;
	package[115].vector_size = 2048;
	
	/*************** Package 116 **********/
	// Initalize the size for this package
	package[116].sort_size = 4095;
	package[116].crc_size = 2048;
	package[116].vector_size = 64;
	
	/*************** Package 117 **********/
	// Initalize the size for this package
	package[117].sort_size = 1024;
	package[117].crc_size = 2048;
	package[117].vector_size = 4095;
	
	/*************** Package 118 **********/
	// Initalize the size for this package
	package[118].sort_size = 512;
	package[118].crc_size = 1024;
	package[118].vector_size = 128;
	
	/*************** Package 119 **********/
	// Initalize the size for this package
	package[119].sort_size = 128;
	package[119].crc_size = 512;
	package[119].vector_size = 128;
	
	// Allocate memory
	unsigned int e = 0, k = 0;
	for ( k = 0; k < 120; k++) {
	    package[k].sort_data = (void *) malloc(sizeof(int) * package[k].sort_size);
	    package[k].crc_data = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].crc_data_check = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].dataA = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataB = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataC = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].sort_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].crc_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vector_valid = (Huint *) malloc(sizeof(Huint));
	
	    package[k].thread_type = (char *) malloc( 20 * sizeof(char));
	    package[k].thread_type = "Undefined";
	
	    // Check to see if we were able to allocate said memory
	    assert(package[k].sort_valid != NULL);
	    assert(package[k].crc_valid != NULL);
	    assert(package[k].vector_valid != NULL);
	
	    assert(package[k].sort_data != NULL);
	    assert(package[k].crc_data != NULL);
	    assert(package[k].dataA != NULL);
	    assert(package[k].dataB != NULL);
	    assert(package[k].dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package[k].sort_valid) = 0;
	    *(package[k].crc_valid) = 0;
	    *(package[k].vector_valid) = 0;
	
	    // Initialize the CRC data here
	    for (e = 0; e < package[k].crc_size; e++) { 
	        Hint * data = (Hint *) package[k].crc_data;
	        Hint * data_check = (Hint *) package[k].crc_data_check;
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data 
	    for (e = 0; e < package[k].vector_size; e++) {
	        Hint * dataA = package[k].dataA;
	        Hint * dataB = package[k].dataB;
	        Hint * dataC = package[k].dataC;
	        dataA[e] = rand() % 1000;
	        dataB[e] = rand() % 1000;
	        dataC[e] = 0;
	    }
	
	    // Initialize Sort Data 
	    for (e = 0; e < package[k].sort_size; e++) {
	        Hint * sort_data = (Hint *) package[k].sort_data;
	        sort_data[e] = package[k].sort_size - e;
	    }
	}
	

	printf("Starting Timer!\n");

	hthread_time_t start = hthread_time_get();

	while(get_num_free_slaves()<6)@@@package[0].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[0].sort_data, package[0].sort_size, package[0].sort_valid)@@@while(*(package[0].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 0,package[0].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[0].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[1].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[1].crc_data, package[1].crc_size, package[1].crc_valid)@@@while(*(package[1].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 1,package[1].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[1].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[2].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[2].sort_data, package[2].sort_size, package[2].sort_valid)@@@while(*(package[2].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 2,package[2].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[2].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[3].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[3].crc_data, package[3].crc_size, package[3].crc_valid)@@@while(*(package[3].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 3,package[3].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[3].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[4].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[4].sort_data, package[4].sort_size, package[4].sort_valid)@@@while(*(package[4].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 4,package[4].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[4].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[5].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[5].dataA, package[5].dataB, package[5].dataC, package[5].vector_size, package[5].vector_valid)@@@while(*(package[5].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 5,package[5].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[5].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[6].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[6].crc_data, package[6].crc_size, package[6].crc_valid)@@@while(*(package[6].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 6,package[6].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[6].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[7].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[7].crc_data, package[7].crc_size, package[7].crc_valid)@@@while(*(package[7].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 7,package[7].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[7].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[8].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[8].dataA, package[8].dataB, package[8].dataC, package[8].vector_size, package[8].vector_valid)@@@while(*(package[8].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 8,package[8].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[8].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[9].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[9].sort_data, package[9].sort_size, package[9].sort_valid)@@@while(*(package[9].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 9,package[9].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[9].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[10].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[10].sort_data, package[10].sort_size, package[10].sort_valid)@@@while(*(package[10].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 10,package[10].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[10].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[11].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[11].dataA, package[11].dataB, package[11].dataC, package[11].vector_size, package[11].vector_valid)@@@while(*(package[11].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 11,package[11].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[11].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[12].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[12].dataA, package[12].dataB, package[12].dataC, package[12].vector_size, package[12].vector_valid)@@@while(*(package[12].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 12,package[12].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[12].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[13].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[13].crc_data, package[13].crc_size, package[13].crc_valid)@@@while(*(package[13].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 13,package[13].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[13].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[14].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[14].crc_data, package[14].crc_size, package[14].crc_valid)@@@while(*(package[14].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 14,package[14].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[14].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[15].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[15].dataA, package[15].dataB, package[15].dataC, package[15].vector_size, package[15].vector_valid)@@@while(*(package[15].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 15,package[15].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[15].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[16].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[16].crc_data, package[16].crc_size, package[16].crc_valid)@@@while(*(package[16].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 16,package[16].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[16].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[17].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[17].crc_data, package[17].crc_size, package[17].crc_valid)@@@while(*(package[17].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 17,package[17].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[17].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[18].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[18].crc_data, package[18].crc_size, package[18].crc_valid)@@@while(*(package[18].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 18,package[18].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[18].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[19].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[19].sort_data, package[19].sort_size, package[19].sort_valid)@@@while(*(package[19].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 19,package[19].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[19].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[20].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[20].crc_data, package[20].crc_size, package[20].crc_valid)@@@while(*(package[20].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 20,package[20].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[20].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[21].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[21].crc_data, package[21].crc_size, package[21].crc_valid)@@@while(*(package[21].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 21,package[21].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[21].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[22].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[22].dataA, package[22].dataB, package[22].dataC, package[22].vector_size, package[22].vector_valid)@@@while(*(package[22].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 22,package[22].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[22].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[23].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[23].dataA, package[23].dataB, package[23].dataC, package[23].vector_size, package[23].vector_valid)@@@while(*(package[23].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 23,package[23].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[23].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[24].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[24].sort_data, package[24].sort_size, package[24].sort_valid)@@@while(*(package[24].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 24,package[24].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[24].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[25].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[25].crc_data, package[25].crc_size, package[25].crc_valid)@@@while(*(package[25].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 25,package[25].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[25].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[26].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[26].dataA, package[26].dataB, package[26].dataC, package[26].vector_size, package[26].vector_valid)@@@while(*(package[26].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 26,package[26].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[26].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[27].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[27].dataA, package[27].dataB, package[27].dataC, package[27].vector_size, package[27].vector_valid)@@@while(*(package[27].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 27,package[27].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[27].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[28].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[28].sort_data, package[28].sort_size, package[28].sort_valid)@@@while(*(package[28].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 28,package[28].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[28].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[29].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[29].crc_data, package[29].crc_size, package[29].crc_valid)@@@while(*(package[29].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 29,package[29].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[29].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[30].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[30].sort_data, package[30].sort_size, package[30].sort_valid)@@@while(*(package[30].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 30,package[30].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[30].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[31].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[31].dataA, package[31].dataB, package[31].dataC, package[31].vector_size, package[31].vector_valid)@@@while(*(package[31].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 31,package[31].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[31].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[32].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[32].sort_data, package[32].sort_size, package[32].sort_valid)@@@while(*(package[32].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 32,package[32].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[32].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[33].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[33].sort_data, package[33].sort_size, package[33].sort_valid)@@@while(*(package[33].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 33,package[33].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[33].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[34].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[34].dataA, package[34].dataB, package[34].dataC, package[34].vector_size, package[34].vector_valid)@@@while(*(package[34].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 34,package[34].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[34].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[35].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[35].crc_data, package[35].crc_size, package[35].crc_valid)@@@while(*(package[35].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 35,package[35].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[35].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[36].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[36].dataA, package[36].dataB, package[36].dataC, package[36].vector_size, package[36].vector_valid)@@@while(*(package[36].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 36,package[36].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[36].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[37].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[37].dataA, package[37].dataB, package[37].dataC, package[37].vector_size, package[37].vector_valid)@@@while(*(package[37].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 37,package[37].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[37].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[38].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[38].sort_data, package[38].sort_size, package[38].sort_valid)@@@while(*(package[38].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 38,package[38].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[38].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[39].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[39].dataA, package[39].dataB, package[39].dataC, package[39].vector_size, package[39].vector_valid)@@@while(*(package[39].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 39,package[39].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[39].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[40].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[40].dataA, package[40].dataB, package[40].dataC, package[40].vector_size, package[40].vector_valid)@@@while(*(package[40].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 40,package[40].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[40].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[41].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[41].crc_data, package[41].crc_size, package[41].crc_valid)@@@while(*(package[41].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 41,package[41].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[41].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[42].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[42].crc_data, package[42].crc_size, package[42].crc_valid)@@@while(*(package[42].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 42,package[42].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[42].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[43].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[43].dataA, package[43].dataB, package[43].dataC, package[43].vector_size, package[43].vector_valid)@@@while(*(package[43].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 43,package[43].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[43].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[44].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[44].dataA, package[44].dataB, package[44].dataC, package[44].vector_size, package[44].vector_valid)@@@while(*(package[44].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 44,package[44].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[44].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[45].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[45].dataA, package[45].dataB, package[45].dataC, package[45].vector_size, package[45].vector_valid)@@@while(*(package[45].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 45,package[45].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[45].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[46].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[46].sort_data, package[46].sort_size, package[46].sort_valid)@@@while(*(package[46].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 46,package[46].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[46].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[47].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[47].crc_data, package[47].crc_size, package[47].crc_valid)@@@while(*(package[47].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 47,package[47].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[47].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[48].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[48].sort_data, package[48].sort_size, package[48].sort_valid)@@@while(*(package[48].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 48,package[48].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[48].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[49].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[49].dataA, package[49].dataB, package[49].dataC, package[49].vector_size, package[49].vector_valid)@@@while(*(package[49].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 49,package[49].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[49].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[50].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[50].sort_data, package[50].sort_size, package[50].sort_valid)@@@while(*(package[50].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 50,package[50].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[50].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[51].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[51].crc_data, package[51].crc_size, package[51].crc_valid)@@@while(*(package[51].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 51,package[51].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[51].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[52].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[52].dataA, package[52].dataB, package[52].dataC, package[52].vector_size, package[52].vector_valid)@@@while(*(package[52].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 52,package[52].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[52].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[53].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[53].crc_data, package[53].crc_size, package[53].crc_valid)@@@while(*(package[53].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 53,package[53].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[53].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[54].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[54].sort_data, package[54].sort_size, package[54].sort_valid)@@@while(*(package[54].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 54,package[54].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[54].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[55].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[55].crc_data, package[55].crc_size, package[55].crc_valid)@@@while(*(package[55].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 55,package[55].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[55].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[56].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[56].dataA, package[56].dataB, package[56].dataC, package[56].vector_size, package[56].vector_valid)@@@while(*(package[56].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 56,package[56].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[56].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[57].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[57].dataA, package[57].dataB, package[57].dataC, package[57].vector_size, package[57].vector_valid)@@@while(*(package[57].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 57,package[57].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[57].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[58].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[58].crc_data, package[58].crc_size, package[58].crc_valid)@@@while(*(package[58].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 58,package[58].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[58].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[59].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[59].sort_data, package[59].sort_size, package[59].sort_valid)@@@while(*(package[59].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 59,package[59].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[59].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[60].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[60].sort_data, package[60].sort_size, package[60].sort_valid)@@@while(*(package[60].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 60,package[60].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[60].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[61].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[61].crc_data, package[61].crc_size, package[61].crc_valid)@@@while(*(package[61].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 61,package[61].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[61].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[62].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[62].dataA, package[62].dataB, package[62].dataC, package[62].vector_size, package[62].vector_valid)@@@while(*(package[62].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 62,package[62].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[62].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[63].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[63].dataA, package[63].dataB, package[63].dataC, package[63].vector_size, package[63].vector_valid)@@@while(*(package[63].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 63,package[63].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[63].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[64].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[64].sort_data, package[64].sort_size, package[64].sort_valid)@@@while(*(package[64].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 64,package[64].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[64].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[65].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[65].dataA, package[65].dataB, package[65].dataC, package[65].vector_size, package[65].vector_valid)@@@while(*(package[65].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 65,package[65].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[65].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[66].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[66].crc_data, package[66].crc_size, package[66].crc_valid)@@@while(*(package[66].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 66,package[66].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[66].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[67].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[67].dataA, package[67].dataB, package[67].dataC, package[67].vector_size, package[67].vector_valid)@@@while(*(package[67].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 67,package[67].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[67].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[68].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[68].dataA, package[68].dataB, package[68].dataC, package[68].vector_size, package[68].vector_valid)@@@while(*(package[68].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 68,package[68].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[68].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[69].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[69].crc_data, package[69].crc_size, package[69].crc_valid)@@@while(*(package[69].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 69,package[69].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[69].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[70].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[70].crc_data, package[70].crc_size, package[70].crc_valid)@@@while(*(package[70].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 70,package[70].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[70].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[71].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[71].sort_data, package[71].sort_size, package[71].sort_valid)@@@while(*(package[71].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 71,package[71].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[71].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[72].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[72].crc_data, package[72].crc_size, package[72].crc_valid)@@@while(*(package[72].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 72,package[72].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[72].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[73].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[73].sort_data, package[73].sort_size, package[73].sort_valid)@@@while(*(package[73].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 73,package[73].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[73].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[74].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[74].sort_data, package[74].sort_size, package[74].sort_valid)@@@while(*(package[74].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 74,package[74].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[74].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[75].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[75].dataA, package[75].dataB, package[75].dataC, package[75].vector_size, package[75].vector_valid)@@@while(*(package[75].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 75,package[75].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[75].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[76].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[76].sort_data, package[76].sort_size, package[76].sort_valid)@@@while(*(package[76].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 76,package[76].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[76].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[77].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[77].crc_data, package[77].crc_size, package[77].crc_valid)@@@while(*(package[77].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 77,package[77].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[77].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[78].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[78].sort_data, package[78].sort_size, package[78].sort_valid)@@@while(*(package[78].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 78,package[78].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[78].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[79].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[79].crc_data, package[79].crc_size, package[79].crc_valid)@@@while(*(package[79].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 79,package[79].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[79].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[80].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[80].dataA, package[80].dataB, package[80].dataC, package[80].vector_size, package[80].vector_valid)@@@while(*(package[80].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 80,package[80].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[80].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[81].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[81].sort_data, package[81].sort_size, package[81].sort_valid)@@@while(*(package[81].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 81,package[81].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[81].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[82].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[82].sort_data, package[82].sort_size, package[82].sort_valid)@@@while(*(package[82].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 82,package[82].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[82].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[83].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[83].crc_data, package[83].crc_size, package[83].crc_valid)@@@while(*(package[83].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 83,package[83].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[83].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[84].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[84].dataA, package[84].dataB, package[84].dataC, package[84].vector_size, package[84].vector_valid)@@@while(*(package[84].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 84,package[84].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[84].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[85].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[85].crc_data, package[85].crc_size, package[85].crc_valid)@@@while(*(package[85].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 85,package[85].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[85].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[86].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[86].dataA, package[86].dataB, package[86].dataC, package[86].vector_size, package[86].vector_valid)@@@while(*(package[86].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 86,package[86].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[86].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[87].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[87].dataA, package[87].dataB, package[87].dataC, package[87].vector_size, package[87].vector_valid)@@@while(*(package[87].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 87,package[87].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[87].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[88].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[88].sort_data, package[88].sort_size, package[88].sort_valid)@@@while(*(package[88].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 88,package[88].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[88].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[89].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[89].crc_data, package[89].crc_size, package[89].crc_valid)@@@while(*(package[89].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 89,package[89].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[89].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[90].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[90].dataA, package[90].dataB, package[90].dataC, package[90].vector_size, package[90].vector_valid)@@@while(*(package[90].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 90,package[90].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[90].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[91].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[91].sort_data, package[91].sort_size, package[91].sort_valid)@@@while(*(package[91].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 91,package[91].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[91].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[92].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[92].sort_data, package[92].sort_size, package[92].sort_valid)@@@while(*(package[92].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 92,package[92].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[92].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[93].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[93].sort_data, package[93].sort_size, package[93].sort_valid)@@@while(*(package[93].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 93,package[93].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[93].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[94].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[94].crc_data, package[94].crc_size, package[94].crc_valid)@@@while(*(package[94].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 94,package[94].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[94].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[95].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[95].crc_data, package[95].crc_size, package[95].crc_valid)@@@while(*(package[95].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 95,package[95].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[95].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[96].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[96].crc_data, package[96].crc_size, package[96].crc_valid)@@@while(*(package[96].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 96,package[96].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[96].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[97].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[97].dataA, package[97].dataB, package[97].dataC, package[97].vector_size, package[97].vector_valid)@@@while(*(package[97].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 97,package[97].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[97].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[98].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[98].sort_data, package[98].sort_size, package[98].sort_valid)@@@while(*(package[98].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 98,package[98].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[98].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[99].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[99].dataA, package[99].dataB, package[99].dataC, package[99].vector_size, package[99].vector_valid)@@@while(*(package[99].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 99,package[99].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[99].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[100].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[100].crc_data, package[100].crc_size, package[100].crc_valid)@@@while(*(package[100].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 100,package[100].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[100].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[101].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[101].sort_data, package[101].sort_size, package[101].sort_valid)@@@while(*(package[101].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 101,package[101].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[101].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[102].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[102].sort_data, package[102].sort_size, package[102].sort_valid)@@@while(*(package[102].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 102,package[102].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[102].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[103].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[103].dataA, package[103].dataB, package[103].dataC, package[103].vector_size, package[103].vector_valid)@@@while(*(package[103].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 103,package[103].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[103].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[104].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[104].dataA, package[104].dataB, package[104].dataC, package[104].vector_size, package[104].vector_valid)@@@while(*(package[104].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 104,package[104].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[104].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[105].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[105].sort_data, package[105].sort_size, package[105].sort_valid)@@@while(*(package[105].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 105,package[105].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[105].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[106].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[106].dataA, package[106].dataB, package[106].dataC, package[106].vector_size, package[106].vector_valid)@@@while(*(package[106].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 106,package[106].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[106].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[107].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[107].crc_data, package[107].crc_size, package[107].crc_valid)@@@while(*(package[107].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 107,package[107].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[107].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[108].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[108].sort_data, package[108].sort_size, package[108].sort_valid)@@@while(*(package[108].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 108,package[108].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[108].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[109].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[109].crc_data, package[109].crc_size, package[109].crc_valid)@@@while(*(package[109].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 109,package[109].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[109].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[110].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[110].crc_data, package[110].crc_size, package[110].crc_valid)@@@while(*(package[110].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 110,package[110].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[110].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[111].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[111].sort_data, package[111].sort_size, package[111].sort_valid)@@@while(*(package[111].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 111,package[111].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[111].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[112].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[112].sort_data, package[112].sort_size, package[112].sort_valid)@@@while(*(package[112].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 112,package[112].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[112].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[113].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[113].crc_data, package[113].crc_size, package[113].crc_valid)@@@while(*(package[113].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 113,package[113].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[113].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[114].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[114].sort_data, package[114].sort_size, package[114].sort_valid)@@@while(*(package[114].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 114,package[114].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[114].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[115].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[115].dataA, package[115].dataB, package[115].dataC, package[115].vector_size, package[115].vector_valid)@@@while(*(package[115].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 115,package[115].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[115].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[116].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[116].sort_data, package[116].sort_size, package[116].sort_valid)@@@while(*(package[116].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 116,package[116].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[116].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[117].thread_type ="Crc"@@@start1 = hthread_time_get()@@@host_crc(package[117].crc_data, package[117].crc_size, package[117].crc_valid)@@@while(*(package[117].crc_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], CRC , with %i size is done\n", 117,package[117].crc_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[117].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[118].thread_type ="sort"@@@start1 = hthread_time_get()@@@host_sort(package[118].sort_data, package[118].sort_size, package[118].sort_valid)@@@while(*(package[118].sort_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], sort , with %i size is done\n", 118,package[118].sort_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[118].exe_time=diff1@@@;
	while(get_num_free_slaves()<6)@@@package[119].thread_type ="vector"@@@start1 = hthread_time_get()@@@host_vector_add(package[119].dataA, package[119].dataB, package[119].dataC, package[119].vector_size, package[119].vector_valid)@@@while(*(package[119].vector_valid) !=1)@@@stop1 = hthread_time_get()@@@//printf("package[%i], vector , with %i size is done\n", 119,package[119].vector_size)@@@hthread_time_diff(diff1, stop1, start1)@@@package[119].exe_time=diff1@@@;

	while((thread_counter + (NUM_AVAILABLE_HETERO_CPUS - get_num_free_slaves()) ) > 0);

	hthread_time_t stop = hthread_time_get();

	int number_of_errors = 0;
	for (e = 0; e < 120; e++) {
	    // Check SORT for this package
	    if (*(package[e].sort_valid)) {
	        unsigned int b = 0;
	        Hint * sorted_list = package[e].sort_data;
	        for (b = 0; b < package[e].sort_size-1; b++) {
	            if (sorted_list[b] > sorted_list[b+1]) {
	                number_of_errors++;
	                printf("\tSORT: Package %u failed\n", e);
	                break;
	            }
	        }
	    }
	    
	    // Check CRC for this package
	    if (*(package[e].crc_valid)) {
	        unsigned int b = 0;
	        Hint * crc = (Hint *) package[e].crc_data;
	        Hint * crc_check = (Hint *) package[e].crc_data_check;
	
	        _crc((void *) crc_check, package[e].crc_size);
	
	        for (b = 0; b < package[e].crc_size; b++) {
	            if (crc[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check Vector for this package
	    if (*(package[e].vector_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vector_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVector: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	}
	
	printf("---------------------------\n");
	printf("\nNumber of Errors = %d\n\n", number_of_errors);
	
	 printf ("Pack   Exe time        crc    sort     vector  thread_type \n" );
		for (e=0; e <  120 ; e++) 
			printf (" %3i   %6.0f uS    %5d     %5d    %5d  %s \n", e, 1.0 *(package[e].exe_time)/100 ,*package[e].crc_valid*package[e].crc_size,
		*package[e].sort_valid*package[e].sort_size,*package[e].vector_valid*package[e].vector_size, package[e].thread_type);
	
	
	
	
	
	
	hthread_time_t diff;
	hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f ms\n", hthread_time_msec(diff));
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));
