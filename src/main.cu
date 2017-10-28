/* *
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */
#include <stdio.h>
#include <stdlib.h>

//#include "countlen.c"
#include "mltaln.h"

#include "countlen.h"
#include "replaceu.h"
#include "makedirectionlist.h"
#include "setdirection.h"

#include "testCuda.h"

//static const int WORK_SIZE = 256;
//
///**
// * This macro checks return value of the CUDA runtime call and exits
// * the application if the call failed.
// */
//#define CUDA_CHECK_RETURN(value) {											\
//	cudaError_t _m_cudaStat = value;										\
//	if (_m_cudaStat != cudaSuccess) {										\
//		fprintf(stderr, "Error %s at line %d in file %s\n",					\
//				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
//		exit(1);															\
//	} }
//
//__host__ __device__ unsigned int bitreverse(unsigned int number) {
//	number = ((0xf0f0f0f0 & number) >> 4) | ((0x0f0f0f0f & number) << 4);
//	number = ((0xcccccccc & number) >> 2) | ((0x33333333 & number) << 2);
//	number = ((0xaaaaaaaa & number) >> 1) | ((0x55555555 & number) << 1);
//	return number;
//}
//
///**
// * CUDA kernel function that reverses the order of bits in each element of the array.
// */
//__global__ void bitreverse(void *data) {
//	unsigned int *idata = (unsigned int*) data;
//	idata[threadIdx.x] = bitreverse(idata[threadIdx.x]);
//}

/**
 * Host function that prepares data array and passes it to the CUDA kernel.
 */
int main(void) {

	printf("MAFFT code, ya rab :) \n");

	countlen_main("./src/sample.fa"); //count sequences number, length and DNA or Protein
	printf("done countlen :D \n");

	replaceu_main(dorp, "./src/sample.fa"); //replace unusual characters with X or N based on P or D
	printf("done replace u :D \n");

	//inaccurate direction parameters
//	char* argv[] = {"-F", "-C", "0", "-m", "-I", "0", "-i", "./src/sample.fa", "-t", "0.00", "-r", "5000", "-o", "a"};
	//accurate direction parameters - what I prefer
	char* argv[] = {"-F", "-C", "0", "-m", "-I", "0", "-i", "./src/sample.fa", "-t", "0.00", "-r", "100", "-o", "a", "-d"};
//	freopen("./src/output.txt", "w", stdout);
	make_direction_list_main(15, argv); //make direction list
	fprintf(stderr, "done make direction list :D \n");

	char* argv2[] = {" ", "-d", "./src/direction.txt", "-i", "./src/sample.fa"};
	set_direction_main(5, argv2);
	fprintf(stderr, "done set direction list :D \n");

	main_cuda();

	return 0;
}


//#include <iostream.h>
//
//
//#define CUDA_CHECK_RETURN(value) {											\
//	cudaError_t _m_cudaStat = value;										\
//	if (_m_cudaStat != cudaSuccess) {										\
//		fprintf(stderr, "Error %s at line %d in file %s\n",					\
//				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
//		exit(1);															\
//	} }
//
//__global__ void add(int a, int b, int *c) {
//	*c = a + b;
//}
//
//int main(void) {
//	int c;
//	int *dev_c;
//
//	CUDA_CHECK_RETURN(cudaMalloc((void**) &dev_c, sizeof(int)));
//
//	add<<<1,1>>> (2, 7, dev_c);
//
//	CUDA_CHECK_RETURN(cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost));
//
//	printf("2 + 7 = %d\n", c);
//	cudaFree(dev_c);
//
//	cudaDeviceProp prop;
//	int count;
//
//	CUDA_CHECK_RETURN(cudaGetDeviceCount(&count));
//	for (int i = 0;  i < count; ++ i) {
//		CUDA_CHECK_RETURN(cudaGetDeviceProperties(&prop, i));
//
//		printf("------ general information for device %d ------ \n", i);
//		printf("Name: %s \n", prop.name);
//		printf("Compute capability: %d.%d \n", prop.major, prop.minor);
//		printf("Clock rate: %d \n", prop.clockRate);
//		printf("Device copy overlap: ");
//		if (prop.deviceOverlap) {
//			printf("Enabled \n");
//		} else {
//			printf("Disabled \n");
//		}
//		printf("Kernel execution timeout: ");
//		if (prop.kernelExecTimeoutEnabled) {
//			printf("Enabled \n");
//		} else {
//			printf("Disabled \n");
//		}
//		printf("----- Memory Information for device %d ----- \n", i);
//		printf("Total global mem: %ld \n", prop.totalGlobalMem);
//		printf("Total constant mem: %ld \n", prop.totalConstMem);
//		printf("Max mem pitch: %ld \n", prop.memPitch);
//		printf("Texture alignment: %ld \n", prop.textureAlignment);
//
//		printf("----- MP Information for device %d ----- \n", i);
//		printf("Multiprocessor count: %d \n", prop.multiProcessorCount);
//		printf("Shared mem per mp: %ld \n", prop.sharedMemPerBlock);
//		printf("Registers per mp: %d \n", prop.regsPerBlock);
//		printf("Threads per wrap: %d \n", prop.warpSize);
//		printf("Max threads per block: %d \n", prop.maxThreadsPerBlock);
//		printf("Max threads dimensions: (%d, %d, %d) \n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
//		printf("Max grid dimensions: (%d, %d, %d) \n", prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
//		printf("\n");
//
//		printf("----- Other info %d ----- \n", i);
//		printf("Texture pitch alignment: %d \n", prop.texturePitchAlignment);
//		printf("Kernel Execution Timeout Enabled: %d \n", prop.kernelExecTimeoutEnabled);
//		printf("Integrated: %d \n", prop.integrated);
//		printf("Can Map Host Memory: %d \n", prop.canMapHostMemory);
//		printf("Compute mode: %d \n", prop.computeMode);
//		printf("Max Texture 1D: %d \n", prop.maxTexture1D);
//		printf("Surface Alignment: %d \n", prop.surfaceAlignment);
//		printf("Concurrent Kernels: %d \n", prop.concurrentKernels);
//		printf("ECC Enabled: %d \n", prop.ECCEnabled);
//		printf("PCI Bus ID: %d \n", prop.pciBusID);
//		printf("PCI Device ID: %d \n", prop.pciDeviceID);
//		printf("TCC Driver: %d \n", prop.tccDriver);
//		printf("Async Engine Count: %d \n", prop.asyncEngineCount);
//		printf("Unified Addressing: %d \n", prop.unifiedAddressing);
//		printf("Memory Clock Rate: %d \n", prop.memoryClockRate);
//		printf("Global Memory BusWidth: %d \n", prop.memoryBusWidth);
//		printf("L2 Cache Size: %d \n", prop.l2CacheSize);
//		printf("Max Threads Per MultiProcessor: %d \n", prop.maxThreadsPerMultiProcessor);
//		printf("Stream Priorities Supported: %d \n", prop.streamPrioritiesSupported);
//		printf("Global L1 Cache Supported: %d \n", prop.globalL1CacheSupported);
//		printf("Local L1 Cache Supported: %d \n", prop.localL1CacheSupported);
//		printf("Shared Memory Per Multiprocessor: %d \n", prop.sharedMemPerMultiprocessor);
//		printf("Registers Per Multiprocessor: %d \n", prop.regsPerMultiprocessor);
//		printf("Managed Memory: %d \n", prop.managedMemory);
//		printf("Is Multi GPU Board: %d \n", prop.isMultiGpuBoard);
//		printf("Multi GPU Board Group ID: %d \n", prop.multiGpuBoardGroupID);
//
//	}
//
//	return 0;
//}

