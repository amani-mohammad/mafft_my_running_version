//moni Fri Oct 20, 11:21 pm

//this file is called first with input file as parameter. I think it calculates some statistics for input file

#include "mltaln.h"
//#include "io.c"
#include "io.h"

#define DEBUG 0

void countlen_arguments( int argc, char *argv[] )
{
    int c;

    while( --argc > 0 && (*++argv)[0] == '-' )
	{
        while ( (c = *++argv[0]) )
		{
            switch( c )
            {
				case 'i':
					inputfile = *++argv;
//					fprintf( stderr, "inputfile = %s\n", inputfile );
					--argc;
					goto nextoption;
                default:
                    fprintf( stderr, "illegal option %c\n", c );
                    argc = 0;
                    break;
            }
		}
		nextoption:
			;
	}
    if( argc != 0 )
    {
        fprintf( stderr, "options: Check source file !\n" );
        exit( 1 );
    }
}


//int countlen_main( int argc, char *argv[] )
int countlen_main( char * inputFilePath )
{
	FILE *infp;
	int nlenmin;
	double nfreq;

//	countlen_arguments( argc, argv );

	inputfile = inputFilePath;

	if( inputfile )
	{
		printf("input file \n");
		infp = fopen( inputfile, "r" );
		if( !infp )
		{
			fprintf( stderr, "Cannot open %s\n", inputfile );
			exit( 1 );
		}
	}
	else {
		printf("standard input \n");
		infp = stdin;
	}

	//dorp means dna or protein
	dorp = NOTSPECIFIED; //NOTSPECIFIED is a constant in mltaln.h and = 100009
	//this method is in io.c file
	//it reads input file and counts number of sequences in it, frequency of acgt chars, freq of n chars
	//and finds min and max lengths of sequences
	getnumlen_nogap_countn( infp, &nlenmin, &nfreq );

	fprintf( stdout, "%d x %d - %d %c nfreq=%f\n", njob, nlenmax, nlenmin, dorp, nfreq );

	fclose( infp );
	return( 0 );
}
