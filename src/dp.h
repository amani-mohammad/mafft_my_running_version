/*
 * dp.h
 *
 *  Created on: Oct 23, 2017
 *      Author: mahmoud
 */

#ifndef DP_H_
#define DP_H_

#ifdef enablemultithread
#define TLS __thread
#else
#define TLS
#endif
//Thread-local storage (TLS) is a mechanism by which variables are allocated such that there is one instance of the variable per extant thread
extern TLS int commonAlloc1;
extern TLS int commonAlloc2;
extern TLS int **commonIP;
extern TLS int **commonJP;

#endif /* DP_H_ */
