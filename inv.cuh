// static __device__ __constant__ int inv = 0xffffffff;
// This compiles with warnings but fails to link, I think because it's static (aka per-file, aka different in different files)
// therefore the "fd" symbol in different compile units references a different copy of "inv", such that e.g. the symbol for
// client1<fd>(&a);
// in main.cu does not match the symbol for the definition of the
// template void client1<fd>(int* a);
// forced-instantiation in client1.cu.
// mcarilli:relocatable-constant-extern$ make
// nvcc -arch=sm_86 -dc main.cu -o main.o
// client1.cuh(3): warning #114-D: function "client1<T>(int *) [with T=fd]" was referenced but not defined
// 
// client1.cuh(3): warning #114-D: function "client1<T>(int *) [with T=fd]" was referenced but not defined
// 
// client1.cuh:3:25: warning: ‘void client1(int*) [with T = dispatch<((const int&)(& inv))>]’ used but never defined
//     3 | template<typename T> void client1(int* a);
//       |                         ^~~~~~~
// nvcc -arch=sm_86 -dc client1.cu -o client1.o
// nvcc -arch=sm_86 -dc inv.cu -o inv.o
// nvcc -arch=sm_86 -o a.out main.o client1.o inv.o
// /usr/bin/ld: main.o: in function `main':
// tmpxft_0002c508_00000000-6_main.cudafe1.cpp:(.text+0x3d): undefined reference to `void client1<dispatch<inv> >(int*)'
// collect2: error: ld returned 1 exit status
// make: *** [makefile:2: a.out] Error 1

extern __device__ __constant__ int inv; // this compiles

template <const int& np0> struct dispatch {
  static __device__ int get_np0() { return np0; }
};

typedef dispatch<inv> fd;
