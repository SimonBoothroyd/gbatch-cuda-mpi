# Google Batch + CUDA + MPI

A test of running CUDA programs across multiple nodes on Google Batch using OpenMPI. 

Make the image:

```shell
make build TAG="<TAG>"
```

Edit `job.json` to have the correct `"<TAG>"`

Submit the job:

```shell
make submit PROJECT="<PROJECT>"
```