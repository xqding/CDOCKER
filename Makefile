HOME=/home/xqding
OpenMM_INSTALL_DIR=$(HOME)/apps/openmmDev
CUFFTDIR="-I/export/apps/CUDA/7.5"

LIB_DIR=-L$(OpenMM_INSTALL_DIR)/lib -L$(CUFFTDIR)/lib -L$(CUFFTDIR)/lib64 -L$(HOME)/local/lib
INCLUDE_DIR=-I$(OpenMM_INSTALL_DIR)/include -I$(CUFFTDIR)/include -I./include -I$(HOME)/local/include/openbabel-2.0 -I$(HOME)/apps/Eigen2
LIBS= -lOpenMM -lopenbabel -lcufft -lm
CFLAGS=-g 
CC = nvcc -std=c++11 -arch=sm_20

BUILD = ./build
SOURCE = ./src

#programs = $(BUILD)/main $(BUILD)/cpuNaive $(BUILD)/TranRotaSearch $(BUILD)/TranRotaConfSearch $(BUILD)/test
programs = $(BUILD)/TranRotaConfSearchNoMini $(BUILD)/TranRotaConfSearchGrid $(BUILD)/TranRotaConfSearchProt $(BUILD)/test 
#programs = $(BUILD)/test
objects = $(BUILD)/ReadCrd.o $(BUILD)/ReadGrids.o $(BUILD)/ReadQuaternions.o $(BUILD)/Rotate.o $(BUILD)/QuaternionMultiply.o $(BUILD)/FillLigandGrid.o $(BUILD)/GetMinCoors.o $(BUILD)/GetNonbondedParameters.o $(BUILD)/GetIdxOfAtomsForVdwRadius.o $(BUILD)/GeneDiverseConformations.o $(BUILD)/GetMaxCoors.o $(BUILD)/kernel.o $(BUILD)/QuaternionUniformSampling.o $(BUILD)/FilterQuaternions.o $(BUILD)/AddGridForcesToOpenMMSystem.o $(BUILD)/GeneRandomConformations.o $(BUILD)/AddCustomNonbondedForceToOpenMMSystem.o $(BUILD)/RemoveNonbondedForceBetweenMasslessParticles.o $(BUILD)/CalcRMSD.o


all: $(programs) copy test

$(BUILD)/%.o: $(SOURCE)/%.cpp
	$(CC) $(CFLAGS) $(INCLUDE_DIR) -c $< -o $@

$(BUILD)/%.o: $(SOURCE)/%.cu
	$(CC) $(CFLAGS) $(INCLUDE_DIR) -c $< -o $@

$(programs): %: %.o $(objects)
	$(CC) $(LIB_DIR) $(LIBS) $(objects) $< -o $@

.PHONY: clean copy
clean:
	rm -rf $(objects) $(programs) $(BUILD)/main.o *~
copy:
	cp $(programs) ./test/
