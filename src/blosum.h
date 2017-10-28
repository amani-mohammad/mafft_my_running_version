/*
 * blosum.h
 *
 *  Created on: Oct 23, 2017
 *      Author: mahmoud
 */

#ifndef BLOSUM_H_
#define BLOSUM_H_

#define DEFAULTGOP_B -1530
#define DEFAULTGEP_B   -00
#define DEFAULTOFS_B  -123   /* +10 -- -50  teido ka ? */

void BLOSUMmtx( int n, double **matrix, double *freq, unsigned char *amino, char *amino_grp );

void extendedmtx( double **matrix, double *freq, unsigned char *amino, char *amino_grp );


#endif /* BLOSUM_H_ */
