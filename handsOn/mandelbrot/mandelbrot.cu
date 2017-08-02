
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define MXITER 1000
#define NPOINTS 2000

typedef struct {
  
  double r;
  double i;
  
}d_complex;

// return 1 if c is outside the mandelbrot set
// return 0 if c is inside the mandelbrot set

// TASK 1: make this a device function 
int testpoint(d_complex c){
  
  d_complex z;
  
  int iter;
  double temp;
  
  z = c;
  
  for(iter=0; iter<MXITER; iter++){
    
    temp = (z.r*z.r) - (z.i*z.i) + c.r;
    
    z.i = z.r*z.i*2. + c.i;
    z.r = temp;
    
    if((z.r*z.r+z.i*z.i)>4.0){
      return 1;
    }
  }
  
  return 0;
  
}


// TASK 2: make this a kernel that processes 
// (i,j) \in   [blockIdx.x*blockDim.x,(blockIdx.x+1)*blockDim.x) 
//           x [blockIdx.y*blockDim.y,(blockIdx.y+1)*blockDim.y) 
//  and sums up the number of outside pixels in each block

// TASK 2a: annotate this to indicate it is a kernel and change return type to void
int  mandeloutside(){

  int i,j;
  double eps = 1e-5;

  d_complex c;

  int numoutside = 0;

  // TASK 2b: replace loop structures with (i,j) defined from blockIdx, blockDim, threadIdx
  for(i=0;i<NPOINTS;i++){
    for(j=0;j<NPOINTS;j++){
      c.r = -2. + 2.5*(double)(i)/(double)(NPOINTS)+eps;
      c.i =       1.125*(double)(j)/(double)(NPOINTS)+eps;

      // TASK 2c: replace this with a partial sum reduction of numoutside in thread block
      numoutside += testpoint(c);
    }
  }
  // TASK 2d: remove this
  return numoutside;
}

int main(int argc, char **argv){

  // TASK 3a: define dim3 variables for the grid size and thread-block size
  
  // TASK 3b: use cudaMalloc to create a DEVICE array that has one entry for each thread-block
  int *c_outsideCounts;

  // TASK 3c: replace this with a kernel call
  double numoutside = mandeloutside();
  
  // TASK 3d: allocate a HOST array to receive the contents of the c_outsideCounts array
  int *h_outsideCounts;

  // TASK 3e: use cudaMemcpy to copy the contents of the entries of c_outsideCounts to h_outsideCounts
  
  // TASK 3f: sum up the outsideCounts 
  int nummoutside = 0;

  double area = 2.*2.5*1.125*(NPOINTS*NPOINTS-numoutside)/(NPOINTS*NPOINTS);

  printf("area = %g\n", area);

  return 0;
}  
