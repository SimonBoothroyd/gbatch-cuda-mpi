#include <iostream>
#include <cstdio>
#include <mpi.h>
#include <unistd.h>
#include <limits.h>

int main(int argc, char *argv[]){

  char hostname[HOST_NAME_MAX];
  gethostname(hostname, HOST_NAME_MAX);

  MPI_Init(&argc, &argv);

  int rank, comm_size;
  MPI_Comm_rank( MPI_COMM_WORLD, &rank );
  MPI_Comm_size( MPI_COMM_WORLD, &comm_size );

  std::cout << hostname << " is running rank=" << rank << "/" << comm_size << std::endl;

  MPI_Barrier( MPI_COMM_WORLD );

  std::cout << hostname << " passed the barrier" << std::endl;

  MPI_Finalize();
  return 0;
}