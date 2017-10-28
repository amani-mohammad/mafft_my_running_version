/*
 * DNA.h
 *
 *  Created on: Oct 23, 2017
 *      Author: mahmoud
 */

#ifndef DNA_H_
#define DNA_H_

//I think this file contains the definitions of matrices, vectors and variables used for DNA alignment scoring
#define DEFAULTGOP_N -1530
#define DEFAULTGEP_N  0
#define DEFAULTOFS_N -369
#define DEFAULTPAMN  200

#define DEFAULTRNAGOP_N -1530
#define DEFAULTRNAGEP_N 0
#define DEFAULTRNATHR_N 0

//  -h 0.11150 -> all positive

double ribosum4[4][4] =
{
//   a       g       c       t
{    2.22,  -1.46,  -1.86,  -1.39, }, // a
{   -1.46,   1.03,  -2.48,  -1.74, }, // g
{   -1.86,  -2.48,   1.16,  -1.05, }, // c
{   -1.39,  -1.74,  -1.05,   1.65, }, // t
};

double ribosum16[16][16] =
{
//   aa      ag      ac      at      ga      gg      gc      gt      ca      cg      cc      ct      ta      tg      tc      tt
{   -2.49,  -8.24,  -7.04,  -4.32,  -6.86,  -8.39,  -5.03,  -5.84,  -8.84,  -4.68, -14.37, -12.64,  -4.01,  -6.16, -11.32,  -9.05, }, // aa
{   -8.24,  -0.80,  -8.89,  -5.13,  -8.61,  -5.38,  -5.77,  -6.60, -10.41,  -4.57, -14.53, -10.14,  -5.43,  -5.94,  -8.87, -11.07, }, // ag
{   -7.04,  -8.89,  -2.11,  -2.04,  -9.73, -11.05,  -3.81,  -4.72,  -9.37,  -5.86,  -9.08, -10.45,  -5.33,  -6.93,  -8.67,  -7.83, }, // ac
{   -4.32,  -5.13,  -2.04,   4.49,  -5.33,  -5.61,   2.70,   0.59,  -5.56,   1.67,  -6.71,  -5.17,   1.61,  -0.51,  -4.81,  -2.98, }, // at
{   -6.86,  -8.61,  -9.73,  -5.33,  -1.05,  -8.67,  -4.88,  -6.10,  -7.98,  -6.00, -12.43,  -7.71,  -5.85,  -7.55,  -6.63, -11.54, }, // ga
{   -8.39,  -5.38, -11.05,  -5.61,  -8.67,  -1.98,  -4.13,  -5.77, -11.36,  -4.66, -12.58, -13.69,  -5.75,  -4.27, -12.01, -10.79, }, // gg
{   -5.03,  -5.77,  -3.81,   2.70,  -4.88,  -4.13,   5.62,   1.21,  -5.95,   2.11,  -3.70,  -5.84,   1.60,  -0.08,  -4.49,  -3.90, }, // gc
{   -5.84,  -6.60,  -4.72,   0.59,  -6.10,  -5.77,   1.21,   3.47,  -7.93,  -0.27,  -7.88,  -5.61,  -0.57,  -2.09,  -5.30,  -4.45, }, // gt
{   -8.84, -10.41,  -9.37,  -5.56,  -7.98, -11.36,  -5.95,  -7.93,  -5.13,  -3.57, -10.45,  -8.49,  -2.42,  -5.63,  -7.08,  -8.39, }, // ca
{   -4.68,  -4.57,  -5.86,   1.67,  -6.00,  -4.66,   2.11,  -0.27,  -3.57,   5.36,  -5.71,  -4.96,   2.75,   1.32,  -4.91,  -3.67, }, // cg
{  -14.37, -14.53,  -9.08,  -6.71, -12.43, -12.58,  -3.70,  -7.88, -10.45,  -5.71,  -3.59,  -5.77,  -6.88,  -8.41,  -7.40,  -5.41, }, // cc
{  -12.64, -10.14, -10.45,  -5.17,  -7.71, -13.69,  -5.84,  -5.61,  -8.49,  -4.96,  -5.77,  -2.28,  -4.72,  -7.36,  -3.83,  -5.21, }, // ct
{   -4.01,  -5.43,  -5.33,   1.61,  -5.85,  -5.75,   1.60,  -0.57,  -2.42,   2.75,  -6.88,  -4.72,   4.97,   1.14,  -2.98,  -3.39, }, // ta
{   -6.16,  -5.94,  -6.93,  -0.51,  -7.55,  -4.27,  -0.08,  -2.09,  -5.63,   1.32,  -8.41,  -7.36,   1.14,   3.36,  -4.76,  -4.28, }, // tg
{  -11.32,  -8.87,  -8.67,  -4.81,  -6.63, -12.01,  -4.49,  -5.30,  -7.08,  -4.91,  -7.40,  -3.83,  -2.98,  -4.76,  -3.21,  -5.97, }, // tc
{   -9.05, -11.07,  -7.83,  -2.98, -11.54, -10.79,  -3.90,  -4.45,  -8.39,  -3.67,  -5.41,  -5.21,  -3.39,  -4.28,  -5.97,  -0.02, }, // tt
};

int locpenaltyn = -1750;
char locaminon[] = "agctuAGCTUnNbdhkmnrsvwyx-O";
char locgrpn[] =
{
	0, 1, 2, 3, 3, 0, 1, 2, 3, 3,
	4, 4, 5, 5, 5, 5, 5, 5, 5, 5,
	5, 5, 5, 5, 5, 5
};
int exgpn = +00;
int locn_disn[26][26] =
/* u ha constants.c no nakade shori */
/* 0 - 4 dake yomareru.             */
        {
		{
  1000,   600,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
   600,  1000,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,  1000,   600,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,   600,  1000,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,   500,   500,     0,     0,     0,   500,   500,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,  -500,
		},

		{
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0, -500,
		},

		{
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0, -500,
		},

		{
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0, -500,
		},

		{
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0, -500,
		},

		{
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,
		},

		{
 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
 -500, -500, -500, -500,    0,  500,
		},
     };


#endif /* DNA_H_ */