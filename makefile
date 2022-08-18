a.out: main.o client1.o inv.o
	nvcc -arch=sm_86 -o $@ $^

main.o: main.cu client1.cu client1.cuh inv.cuh
	nvcc -arch=sm_86 -dc main.cu -o main.o

client1.o: client1.cu client1.cuh inv.cuh
	nvcc -arch=sm_86 -dc client1.cu -o client1.o

inv.o: inv.cu inv.cuh
	nvcc -arch=sm_86 -dc inv.cu -o inv.o

clean:
	rm *.o; rm a.out
