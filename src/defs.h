/*
 * defs.h
 *
 *  Created on: Oct 21, 2017
 *      Author: mahmoud
 */

#ifndef DEFS_H_
#define DEFS_H_

#include "mltaln.h"

//int TLS commonAlloc1 = 0; // what is TLS ?
//int TLS commonAlloc2 = 0;
//int TLS **commonIP = NULL;
//int TLS **commonJP = NULL;
//int nthread = 1;
//int randomseed = 0;
//int parallelizationstrategy = BAATARI1;
extern int TLS commonAlloc1; // what is TLS ?
extern int TLS commonAlloc2;
extern int TLS **commonIP;
extern int TLS **commonJP;
extern int nthread;
extern int randomseed;
extern int parallelizationstrategy;

extern char modelname[500];
extern int njob, nlenmax;
extern int amino_n[0x100]; //256 chars
extern char amino_grp[0x100]; //256 chars
//int amino_dis[0x100][0x100];
extern int **amino_dis;
extern double **n_disLN;
//double amino_dis_consweight_multi[0x100][0x100];
extern double **amino_dis_consweight_multi;
extern int **n_dis;
extern int **n_disFFT;
extern double **n_dis_consweight_multi;
extern unsigned char amino[0x100]; //256 chars
extern double polarity[0x100]; //256 chars
extern double volume[0x100]; //256 chars
extern int ribosumdis[37][37];

extern int ppid;
extern double thrinter;
extern double fastathreshold;
extern int pslocal, ppslocal;
extern int constraint;
extern int divpairscore;
extern int fmodel; // 1-> fmodel 0->default -1->raw
extern int nblosum; // 45, 50, 62, 80
extern int kobetsubunkatsu; //kobetsubunkatsu = individual division
extern int bunkatsu;
extern int dorp; // arguments de shitei suruto, tbfast -> pairlocalalign no yobidashi de futsugou
extern int niter;
extern int contin;
extern int calledByXced;
extern int devide;
extern int scmtd;
extern int weight;
extern int utree;
extern int tbutree;
extern int refine;
extern int check;
extern double cut;
extern int cooling;
extern int trywarp;
extern int penalty, ppenalty, penaltyLN;
extern int penalty_dist, ppenalty_dist;
extern int RNApenalty, RNAppenalty;
extern int RNApenalty_ex, RNAppenalty_ex;
extern int penalty_ex, ppenalty_ex, penalty_exLN;
extern int penalty_EX, ppenalty_EX;
extern int penalty_OP, ppenalty_OP;
extern int penalty_shift, ppenalty_shift;
extern double penalty_shift_factor;
extern int RNAthr, RNApthr;
extern int offset, poffset, offsetLN, offsetFFT;
extern int scoremtx;
extern int TMorJTT;
extern char use_fft;
extern char force_fft;
extern int nevermemsave;
extern int fftscore;
extern int fftWinSize; //may be means fft window size
extern int fftThreshold;
extern int fftRepeatStop;
extern int fftNoAnchStop;
extern int divWinSize;
extern int divThreshold;
extern int disp;
extern int outgap;
extern char alg;
extern int cnst;
extern int mix;
extern int tbitr;
extern int tbweight;
extern int tbrweight;
extern int disopt;
extern int pamN;
extern int checkC;
extern double geta2;
extern int treemethod;
extern int kimuraR;
extern char *swopt;
extern int fftkeika;
extern int score_check;
extern int makedistmtx;
extern char *inputfile;
extern char *addfile;
extern int addprofile;
extern int rnakozo;
extern char rnaprediction;
extern int scoreout;
extern int spscoreout;
extern int outnumber;
extern int legacygapcost;
extern double minimumweight;
extern int nwildcard;

extern char *signalSM;
extern FILE *prep_g;
extern FILE *trap_g;
extern char **seq_g;
extern char **res_g;

extern double consweight_multi;
extern double consweight_rna;
extern char RNAscoremtx;

extern char TLS *newgapstr;

extern int nalphabets;
extern int nscoredalphabets;

extern double specificityconsideration;
extern int ndistclass;
extern int maxdistclass;

extern int gmsg;

extern double sueff_global;

extern double lenfaca, lenfacb, lenfacc, lenfacd;
extern int maxl, tsize;

void initglobalvariables();

#endif /* DEFS_H_ */
