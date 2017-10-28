/*
 * io.h
 *
 *  Created on: Oct 22, 2017
 *      Author: mahmoud
 */

#ifndef IO_H_
#define IO_H_

char creverse( char f );
void sreverse( char *r, char *s );

void getnumlen_nogap_countn( FILE *fp, int *nlenminpt, double *nfreq );
void getnumlen( FILE *fp );
void getnumlen_casepreserve( FILE *fp, int *nlenminpt );
void readData_pointer_casepreserve( FILE *fp, char **name, int *nlen, char **seq );

void readData_pointer( FILE *fp, char **name, int *nlen, char **seq );

void readsubalignmentstable( int nseq, int **table, int *preservegaps, int *nsubpt, int *maxmempt );

void initSignalSM( void );

void initFiles( void );
void closeFiles( void );

void ErrorExit( char *message );

double *loadaamtx( void );

int myatoi( char *in );
void reporterr( const char *str, ... );


#endif /* IO_H_ */
