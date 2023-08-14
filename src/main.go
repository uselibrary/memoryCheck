package main

import (
	"fmt"
	"time"
)

const (
	numCalculations = 2000000000 // Adjust this value based on your system's capabilities
	numMemoryOps    = 100000000  // Adjust this value based on your system's capabilities
)

func performCalculations() {
	for i := 0; i < numCalculations; i++ {
		_ = i * i
	}
}

func performMemoryOps() {
	data := make([]int, numMemoryOps)
	for i := 0; i < numMemoryOps; i++ {
		data[i] = i
	}
}

func main() {
	fmt.Println("Starting CPU and RAM performance test...")

	startTime := time.Now()

	// Perform calculations
	performCalculations()

	calculationTime := time.Since(startTime)
	fmt.Printf("Calculations took: %s\n", calculationTime)

	startTime = time.Now()

	// Perform memory operations
	performMemoryOps()

	memoryOpsTime := time.Since(startTime)
	fmt.Printf("Memory operations took: %s\n", memoryOpsTime)
}
