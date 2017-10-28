/* *
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */

//tree methods and i think after group alignment tree construction
#include "mltaln.h"
#include "io.h"

//check sequence characters and report error if unusual character is found
char seqcheck( char **seq )
{
	int i, len;
	char **seqbk = seq;
	while( *seq )
	{
		len = strlen( *seq );
		for( i=0; i<len; i++ )
		{
			if( amino_n[(int)(*seq)[i]] == -1 ) //this character is not found in amino_n characters array
			{

				reporterr(       "========================================================================= \n" );
				reporterr(       "========================================================================= \n" );
				reporterr(       "=== \n" );
				reporterr(       "=== Alphabet '%c' is unknown.\n", (*seq)[i] );
				reporterr(       "=== Please check site %d in sequence %d.\n", i+1, (int)(seq-seqbk+1) );
				reporterr(       "=== \n" );
				reporterr(       "=== To make an alignment having unusual characters (U, @, #, etc), try\n" );
				reporterr(       "=== %% mafft --anysymbol input > output\n" );
				reporterr(       "=== \n" );
				reporterr(       "========================================================================= \n" );
				reporterr(       "========================================================================= \n" );
				return( (int)(*seq)[i] );
			}
		}
		seq++;
	}
	return( 0 );
}

//copy 'seq' chars to 'aseq' without gaps chars
void gappick0( char *aseq, char *seq )
{
	for( ; *seq != 0; seq++ )
	{
		if( *seq != '-' )
			*aseq++ = *seq;
	}
	*aseq = 0;

}
