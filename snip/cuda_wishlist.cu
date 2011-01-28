

// Test if CUDA will propagate compile-time constants
// through function arguments.
__global__ void f(const int n){
	float array[n];
}
int main(int argc, char **argv) 
{
	dim3 gridSize(1,1,1);
	dim3 blockSize(1,1);
	const int n=3;
	f<<<gridSize,blockSize>>>(n);
}
/*
nvcc foo.cu -o foo -lcuda -I../util -I../../util -I../../../util -I../../../util -arch=sm_20 -DBLAS_IMPLEMENTATION_MKL -I/usr/local/intel/mkl//include -L/usr/local/intel/mkl//lib/em64t -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread --profile -Xptxas -v
foo.cu(6): error: constant value is not known

1 error detected in the compilation of "/tmp/tmpxft_00000915_00000000-4_foo.cpp1.ii".
make: *** [foo] Error 2
*/
