#include <unistd.h>
#include <limits.h>

#include <iostream>
#include <iomanip>
#include <random>
#include <array>

#include <mpi.h>
#include <cuda_runtime.h>

void find_cuda_devices(int rank) {

    int deviceCount = 0;
    cudaError_t error = cudaGetDeviceCount(&deviceCount);

    if (error != cudaSuccess) {
        std::cerr << "Error in cudaGetDeviceCount: " << cudaGetErrorString(error) << std::endl;
        exit(1);
    }

    for (int i = 0; i < deviceCount; ++i) {
        cudaDeviceProp deviceProp;
        error = cudaGetDeviceProperties(&deviceProp, i);

        if (error != cudaSuccess) {
            std::cerr << "Error in cudaGetDeviceProperties: " << cudaGetErrorString(error) << std::endl;
            exit(1);
        }

        std::cout << "rank=" << rank << " is using device=" << i << " name=" << deviceProp.name << " uuid=";

        for (int j = 0; j < 16; ++j) {
            std::cout << std::hex << std::setw(2) << std::setfill('0') << (deviceProp.uuid.bytes[j] & 0xFF);
        }

        std::cout << std::dec << std::endl;
    }

}

int main(int argc, char *argv[]) {
    char hostname[HOST_NAME_MAX];
    gethostname(hostname, HOST_NAME_MAX);

    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &size );

    std::cout << hostname << " is running rank=" << rank << "/" << size << std::endl;

    find_cuda_devices(rank);

    // generate a 'largeish' array of random numbers to broadcast to simulate real data.
    const size_t array_size = 2UL * 1024 * 1024 / sizeof(double);
    std::array<double, array_size> data;

    if (rank == 0) {
        std::uniform_real_distribution<double> distribution(0.0, 1.0);
        std::default_random_engine random_engine;

        for (size_t i = 0; i < array_size; ++i)
            data[i] = distribution(random_engine);
    }

    MPI_Bcast(data.data(), array_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    std::cout << rank << " received data" << std::endl;

    MPI_Finalize();
    return 0;
}