################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/JTT.cu \
../src/Lalign11.cu \
../src/blosum.cu \
../src/constants.cu \
../src/countlen.cu \
../src/defs.cu \
../src/fft.cu \
../src/io.cu \
../src/mafft-distance.cu \
../src/main.cu \
../src/makedirectionlist.cu \
../src/mltaln.cu \
../src/mltaln9.cu \
../src/mtxutl.cu \
../src/replaceu.cu \
../src/setdirection.cu \
../src/testCuda.cu 

CU_DEPS += \
./src/JTT.d \
./src/Lalign11.d \
./src/blosum.d \
./src/constants.d \
./src/countlen.d \
./src/defs.d \
./src/fft.d \
./src/io.d \
./src/mafft-distance.d \
./src/main.d \
./src/makedirectionlist.d \
./src/mltaln.d \
./src/mltaln9.d \
./src/mtxutl.d \
./src/replaceu.d \
./src/setdirection.d \
./src/testCuda.d 

OBJS += \
./src/JTT.o \
./src/Lalign11.o \
./src/blosum.o \
./src/constants.o \
./src/countlen.o \
./src/defs.o \
./src/fft.o \
./src/io.o \
./src/mafft-distance.o \
./src/main.o \
./src/makedirectionlist.o \
./src/mltaln.o \
./src/mltaln9.o \
./src/mtxutl.o \
./src/replaceu.o \
./src/setdirection.o \
./src/testCuda.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/Developer/NVIDIA/CUDA-6.5/bin/nvcc -G -g -O0 -gencode arch=compute_12,code=sm_12  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/Developer/NVIDIA/CUDA-6.5/bin/nvcc -G -g -O0 --compile --relocatable-device-code=false -gencode arch=compute_12,code=compute_12 -gencode arch=compute_12,code=sm_12  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


