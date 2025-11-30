# ==================================================
# SYSC 4001 - Assignment 3 Part 1
# Makefile for EP, RR, and EP+RR schedulers
# ==================================================

# Compiler
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra

# Output directories
BIN_DIR = bin
OUT_DIR = output_files

# Source files
EP_SRC     = interrupts_student1_student2_EP.cpp
RR_SRC     = interrupts_student1_student2_RR.cpp
EPRR_SRC   = interrupts_student1_student2_EP_RR.cpp

# Executables
EP_EXE     = $(BIN_DIR)/interrupts_EP
RR_EXE     = $(BIN_DIR)/interrupts_RR
EPRR_EXE   = $(BIN_DIR)/interrupts_EP_RR

# Default target
all: setup $(EP_EXE) $(RR_EXE) $(EPRR_EXE)
	@echo "Build complete."

# Create folders if missing
setup:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(OUT_DIR)

# Build each executable
$(EP_EXE): $(EP_SRC) interrupts_student1_student2.hpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(RR_EXE): $(RR_SRC) interrupts_student1_student2.hpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(EPRR_EXE): $(EPRR_SRC) interrupts_student1_student2.hpp
	$(CXX) $(CXXFLAGS) $< -o $@

# Clean compiled files
clean:
	rm -rf $(BIN_DIR)

.PHONY: all clean setup
