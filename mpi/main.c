#include <iostream>
#include <mpi.h>
#include <unistd.h>
#include <limits.h>
#include <cstdlib>
#include <ctime>
#include <vector>

int main(int argc, char *argv[])
{
    char hostname[HOST_NAME_MAX];
    gethostname(hostname, HOST_NAME_MAX);

    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &size );

    std::cout << hostname << " is running rank=" << rank << "/" << size << std::endl;

    const size_t array_size = 2UL * 1024 * 1024 * 1024 / sizeof(double);  // 2GB
    std::vector<double> data;

    if (rank == 0)
    {
        data.resize(array_size);
        std::srand(static_cast<unsigned int>(std::time(nullptr)));
        for (size_t i = 0; i < array_size; ++i) {
            data[i] = static_cast<double>(std::rand()) / RAND_MAX;
        }
    }
    else
    {
        data.resize(array_size);
    }

    std::cout << rank << " initialized data." << std::endl;
    MPI_Barrier(MPI_COMM_WORLD);
    double start_time = MPI_Wtime();

    std::cout << rank << " pre-broadcast." << std::endl;
    MPI_Bcast(data.data(), array_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    std::cout << rank << " post-broadcast." << std::endl;

    double end_time = MPI_Wtime();
    MPI_Barrier(MPI_COMM_WORLD);

    if (rank == 0) {
        std::cout << "broadcast completed in " << end_time - start_time << " seconds.\n";
    }

    std::cout << hostname << " ended" << std::endl;

    MPI_Finalize();
    return 0;
}