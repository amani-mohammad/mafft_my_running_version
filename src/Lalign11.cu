/* *
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */

// I think this file contains methods for local alignment and matrices allocation
#include "mltaln.h"
#include "dp.h"

#define DEBUG 0
#define DEBUG2 0
#define XXXXXXX    0
#define USE_PENALTY_EX  1


static TLS int localstop; // 060910 //what is TLS? and what does it mean?

#if 1 //i think this method fills match array with values from mtx based on chars from s2, but first char is from s1
static void match_calc_mtx( double **mtx, double *match, char **s1, char **s2, int i1, int lgth2 )
{
	char *seq2 = s2[0];
	double *doubleptr = mtx[(unsigned char)s1[0][i1]];

	while( lgth2-- )
		*match++ = doubleptr[(unsigned char)*seq2++];
}
#else
static void match_calc( double *match, char **s1, char **s2, int i1, int lgth2 )
{
	int j;

	for( j=0; j<lgth2; j++ )
		match[j] = amino_dis[(*s1)[i1]][(*s2)[j]];
}
#endif

//This methods finds the matchings between seq1 and seq2 and returns the score of matching them.
//It is similar to L__align11 with some small differences. It is simpler and doesn't contain warp
double L__align11_noalign( double **n_dynamicmtx, char **seq1, char **seq2 ) //n_dynamicmtx is weight matrix
// warp mitaiou
{
//	int k;
	int i, j;
	int lasti, lastj;                      /* outgap == 0 -> lgth1, outgap == 1 -> lgth1+1 */
	int lgth1, lgth2;
//	int resultlen;
	double wm = 0.0;   /* int ?????? */
	double g;
	double *currentw, *previousw;
#if 1
	double *wtmp;
//	int *ijppt;
	double *mjpt, *prept, *curpt;
//	int *mpjpt;
#endif
	static TLS double mi, *m;
//	static TLS int **ijp;
//	static TLS int mpi, *mp;
	static TLS double *w1, *w2;
	static TLS double *match;
	static TLS double *initverticalw;    /* kufuu sureba iranai */
	static TLS double *lastverticalw;    /* kufuu sureba iranai */
//	static TLS char **mseq1;
//	static TLS char **mseq2;
//	static TLS char **mseq;
//	static TLS int **intwork;
//	static TLS double **doublework;
	static TLS int orlgth1 = 0, orlgth2 = 0;
	static TLS double **amino_dynamicmtx = NULL; // ??
	double maxwm;
//	int endali = 0, endalj = 0; // by D.Mathog, a guess
//	int endali, endalj;
	double localthr = -offset; //offset value is set in constants.c
	double localthr2 = -offset;
//	double localthr = 100;
//	double localthr2 = 100;
	double fpenalty = (double)penalty; //penalty is defined in defs.h and set in constants.c
	double fpenalty_ex = (double)penalty_ex; //penalty_ex is defined in defs.h and set in constants.c

	if( seq1 == NULL ) //if first sequence is null, free allocated memory and return 0
	{
		if( orlgth1 > 0 && orlgth2 > 0 ) //how we check their value > 0 and it is set to 0 and not changed between setting and checking ?!!
		{
			orlgth1 = 0;
			orlgth2 = 0;
//			free( mseq1 );
//			free( mseq2 );
			FreeFloatVec( w1 );
			FreeFloatVec( w2 );
			FreeFloatVec( match );
			FreeFloatVec( initverticalw );
			FreeFloatVec( lastverticalw );

			FreeFloatVec( m );
//			FreeIntVec( mp );

//			FreeCharMtx( mseq );
			if( amino_dynamicmtx ) FreeDoubleMtx( amino_dynamicmtx ); amino_dynamicmtx = NULL;

		}
		return( 0.0 );
	}


//	if( orlgth1 == 0 )
//	{
//		mseq1 = AllocateCharMtx( njob, 0 );
//		mseq2 = AllocateCharMtx( njob, 0 );
//	}


	lgth1 = strlen( seq1[0] );
	lgth2 = strlen( seq2[0] );

	if( lgth1 > orlgth1 || lgth2 > orlgth2 )
	{
		int ll1, ll2;

		if( orlgth1 > 0 && orlgth2 > 0 )
		{
			FreeFloatVec( w1 );
			FreeFloatVec( w2 );
			FreeFloatVec( match );
			FreeFloatVec( initverticalw );
			FreeFloatVec( lastverticalw );

			FreeFloatVec( m );
//			FreeIntVec( mp );

//			FreeCharMtx( mseq );



//			FreeFloatMtx( doublework );
//			FreeIntMtx( intwork );
			if( amino_dynamicmtx ) FreeDoubleMtx( amino_dynamicmtx ); amino_dynamicmtx = NULL;
		}

		ll1 = MAX( (int)(1.3*lgth1), orlgth1 ) + 100;
		ll2 = MAX( (int)(1.3*lgth2), orlgth2 ) + 100;

#if DEBUG
		fprintf( stderr, "\ntrying to allocate (%d+%d)xn matrices ... ", ll1, ll2 );
#endif

		w1 = AllocateFloatVec( ll2+2 );
		w2 = AllocateFloatVec( ll2+2 );
		match = AllocateFloatVec( ll2+2 );

		initverticalw = AllocateFloatVec( ll1+2 );
		lastverticalw = AllocateFloatVec( ll1+2 );

		m = AllocateFloatVec( ll2+2 );
//		mp = AllocateIntVec( ll2+2 );

//		mseq = AllocateCharMtx( njob, ll1+ll2 );


//		doublework = AllocateFloatMtx( nalphabets, MAX( ll1, ll2 )+2 );
//		intwork = AllocateIntMtx( nalphabets, MAX( ll1, ll2 )+2 );

#if DEBUG
		fprintf( stderr, "succeeded\n" );
#endif
		amino_dynamicmtx = AllocateDoubleMtx( 0x80, 0x80 ); //128 decimal
		orlgth1 = ll1 - 100;
		orlgth2 = ll2 - 100;
	}

    for( i=0; i<nalphabets; i++) for( j=0; j<nalphabets; j++ )
		amino_dynamicmtx[(int)amino[i]][(int)amino[j]] = (double)n_dynamicmtx[i][j];
    //amino is defined in defs.h.



//	mseq1[0] = mseq[0];
//	mseq2[0] = mseq[1];


//	if( orlgth1 > commonAlloc1 || orlgth2 > commonAlloc2 )
//	{
//		int ll1, ll2;
//
//		if( commonAlloc1 && commonAlloc2 )
//		{
//			FreeIntMtx( commonIP );
//		}
//
//		ll1 = MAX( orlgth1, commonAlloc1 );
//		ll2 = MAX( orlgth2, commonAlloc2 );

#if DEBUG
//		fprintf( stderr, "\n\ntrying to allocate %dx%d matrices ... ", ll1+1, ll2+1 );
#endif

//		commonIP = AllocateIntMtx( ll1+10, ll2+10 );

#if DEBUG
//		fprintf( stderr, "succeeded\n\n" );
#endif

//		commonAlloc1 = ll1;
//		commonAlloc2 = ll2;
//	}
//	ijp = commonIP;


#if 0
	for( i=0; i<lgth1; i++ )
		fprintf( stderr, "ogcp1[%d]=%f\n", i, ogcp1[i] );
#endif

	currentw = w1;
	previousw = w2;

	//fills initverticalw array with numbers from amino_dynamicmtx based on seq1 and seq2 chars matching
	match_calc_mtx( amino_dynamicmtx, initverticalw, seq2, seq1, 0, lgth1 ); //first char from seq2 and others from seq1 //defined here.
	//fills currentw array with numbers from amino_dynamicmtx based on seq1 and seq2 chars matching
	match_calc_mtx( amino_dynamicmtx, currentw, seq1, seq2, 0, lgth2 ); //first char from seq1 and others from seq2


	lasti = lgth2+1;
	for( j=1; j<lasti; ++j )
	{
		m[j] = currentw[j-1];
//		mp[j] = 0;
#if 0
		if( m[j] < localthr ) m[j] = localthr2;
#endif
	}

	lastverticalw[0] = currentw[lgth2-1];

	lasti = lgth1+1;

#if 0
fprintf( stderr, "currentw = \n" );
for( i=0; i<lgth1+1; i++ )
{
	fprintf( stderr, "%5.2f ", currentw[i] );
}
fprintf( stderr, "\n" );
fprintf( stderr, "initverticalw = \n" );
for( i=0; i<lgth2+1; i++ )
{
	fprintf( stderr, "%5.2f ", initverticalw[i] );
}
fprintf( stderr, "\n" );
#endif
#if DEBUG2
	fprintf( stderr, "\n" );
	fprintf( stderr, "       " );
	for( j=0; j<lgth2; j++ )
		fprintf( stderr, "%c     ", seq2[0][j] );
	fprintf( stderr, "\n" );
#endif

	localstop = lgth1+lgth2+1;
	maxwm = -999999999.9;
#if DEBUG2
	fprintf( stderr, "\n" );
	fprintf( stderr, "%c   ", seq1[0][0] );

	for( j=0; j<lgth2+1; j++ )
		fprintf( stderr, "%5.0f ", currentw[j] );
	fprintf( stderr, "\n" );
#endif

	for( i=1; i<lasti; i++ )
	{
		wtmp = previousw; //swap previousw and currentw
		previousw = currentw;
		currentw = wtmp;

		previousw[0] = initverticalw[i-1];

		//fills currentw array with numbers from amino_dynamicmtx based on seq1 and seq2 chars matching
		match_calc_mtx( amino_dynamicmtx, currentw, seq1, seq2, i, lgth2 ); //defined here
#if DEBUG2
		fprintf( stderr, "%c   ", seq1[0][i] );
		fprintf( stderr, "%5.0f ", currentw[0] );
#endif

#if XXXXXXX
fprintf( stderr, "\n" );
fprintf( stderr, "i=%d\n", i );
fprintf( stderr, "currentw = \n" );
for( j=0; j<lgth2; j++ )
{
	fprintf( stderr, "%5.2f ", currentw[j] );
}
fprintf( stderr, "\n" );
#endif
#if XXXXXXX
fprintf( stderr, "\n" );
fprintf( stderr, "i=%d\n", i );
fprintf( stderr, "currentw = \n" );
for( j=0; j<lgth2; j++ )
{
	fprintf( stderr, "%5.2f ", currentw[j] );
}
fprintf( stderr, "\n" );
#endif
		currentw[0] = initverticalw[i];

		mi = previousw[0];
//		mpi = 0;

#if 0
		if( mi < localthr ) mi = localthr2;
#endif

//		ijppt = ijp[i] + 1;
		mjpt = m + 1;
		prept = previousw;
		curpt = currentw + 1;
//		mpjpt = mp + 1;
		lastj = lgth2+1;
		for( j=1; j<lastj; j++ )
		{
			wm = *prept;
//			*ijppt = 0;

#if 0
			fprintf( stderr, "%5.0f->", wm );
#endif
#if 0
			fprintf( stderr, "%5.0f?", g );
#endif
			if( (g=mi+fpenalty) > wm )
			{
				wm = g;
//				*ijppt = -( j - mpi );
			}
			if( *prept > mi )
			{
				mi = *prept;
//				mpi = j-1;
			}

#if USE_PENALTY_EX
			mi += fpenalty_ex;
#endif

#if 0
			fprintf( stderr, "%5.0f?", g );
#endif
			if( (g=*mjpt+fpenalty) > wm )
			{
				wm = g;
//				*ijppt = +( i - *mpjpt );
			}
			if( *prept > *mjpt )
			{
				*mjpt = *prept;
//				*mpjpt = i-1;
			}
#if USE_PENALTY_EX
			*mjpt += fpenalty_ex;
#endif

			if( maxwm < wm )
			{
				maxwm = wm;
//				endali = i;
//				endalj = j;
			}
#if 1
			if( wm < localthr )
			{
//				fprintf( stderr, "stop i=%d, j=%d, curpt=%f\n", i, j, *curpt );
//				*ijppt = localstop;
				wm = localthr2;
			}
#endif
#if 0
			fprintf( stderr, "%5.0f ", *curpt );
#endif
#if DEBUG2
			fprintf( stderr, "%5.0f ", wm );
//			fprintf( stderr, "%c-%c *ijppt = %d, localstop = %d\n", seq1[0][i], seq2[0][j], *ijppt, localstop );
#endif

			*curpt++ += wm;
//			ijppt++;
			mjpt++;
			prept++;
//			mpjpt++;
		}
#if DEBUG2
		fprintf( stderr, "\n" );
#endif

		lastverticalw[i] = currentw[lgth2-1];
	}


#if 0
	fprintf( stderr, "maxwm = %f\n", maxwm );
	fprintf( stderr, "endali = %d\n", endali );
	fprintf( stderr, "endalj = %d\n", endalj );
#endif


#if 0 // IRUKAMO!!!!
	if( ijp[endali][endalj] == localstop )
	{
		strcpy( seq1[0], "" );
		strcpy( seq2[0], "" );
		*off1pt = *off2pt = 0;
		fprintf( stderr, "maxwm <- 0.0 \n" );
		return( 0.0 );
	}
#else
	if( maxwm < localthr )
	{
		fprintf( stderr, "maxwm <- 0.0 \n" );
		return( 0.0 );
	}
#endif

//	Ltracking( currentw, lastverticalw, seq1, seq2, mseq1, mseq2, ijp, off1pt, off2pt, endali, endalj );


//	resultlen = strlen( mseq1[0] );
//	if( alloclen < resultlen || resultlen > N )
//	{
//		fprintf( stderr, "alloclen=%d, resultlen=%d, N=%d\n", alloclen, resultlen, N );
//		ErrorExit( "LENGTH OVER!\n" );
//	}


//	strcpy( seq1[0], mseq1[0] );
//	strcpy( seq2[0], mseq2[0] );

#if 0
	fprintf( stderr, "wm=%f\n", wm );
	fprintf( stderr, ">\n%s\n", mseq1[0] );
	fprintf( stderr, ">\n%s\n", mseq2[0] );

	fprintf( stderr, "maxwm = %f\n", maxwm );
	fprintf( stderr, "   wm = %f\n",    wm );
#endif

	return( maxwm );
}

