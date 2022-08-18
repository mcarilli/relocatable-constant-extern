#include "client1.cuh"

template<typename FD>
__global__ void client1_kernel(int* a) {
  *a = FD::get_np0();
}

template<typename FD> void client1(int* a) {
  client1_kernel<FD><<<1, 1>>>(a);  
}

template void client1<fd>(int* a);
