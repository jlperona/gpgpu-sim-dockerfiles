# gpgpu-sim-dockerfiles

See [this Medium post](https://medium.com/@jlperona/gpgpu-sim-and-machine-learning-workloads-152563e6703f) for more information.

## Pannotia

You can use `Pannotia` to make sure you built GPGPU-Sim correctly.
Below are the instructions to test `pagerank` in Pannotia:

~~~~
hg clone http://gem5-gpu.cs.wisc.edu/repo/benchmarks/pannotia
cd pannotia/pagerank
make
~~~~

If you want to make the test take a shorter amount of time, change `#define ITER` in `pagerank.cu` to 1.
Next, you need to make symlinks to the [GPU configuration files](https://github.com/gpgpu-sim/gpgpu-sim_distribution/tree/dev/configs).
Pick the appropriate GPU, then:

~~~~
ln -s gpgpu-sim_distribution/configs/<your gpu>/config_fermi_islip.icnt
ln -s gpgpu-sim_distribution/configs/<your gpu>/gpgpusim.config
ln -s gpgpu-sim_distribution/configs/<your gpu>/gpuwattch_<your gpu>.xml
~~~~

Make sure you `source gpgpu-sim_distribution/setup_environment` before attempting to run the workload.

Using [coAuthorsDBLP.graph](https://github.com/pannotia/pannotia/blob/master/dataset/pagerank/coAuthorsDBLP.graph) as an example, use the following to run pagerank:

~~~~
./pagerank coAuthorsDBLP.graph 1
~~~~

## ubuntu1404.dockerfile

You can find this container on Docker Hub, under the name [jlperona/gpgpu-sim-build](https://hub.docker.com/r/jlperona/gpgpu-sim-build/).
This Dockerfile and container will build and run GPGPU-Sim as is, but has a very outdated version of CUDA installed (3.2.14).

## cuda6514.dockerfile

You can find this container on Docker Hub, under the name [jlperona/gpgpu-sim-build-update](https://hub.docker.com/r/jlperona/gpgpu-sim-build-update/).
This Dockerfile will build GPGPU-Sim, but programs will not use GPGPU-Sim.
Instead, they attempt to use the system CUDA installation.
I have not been able to figure out why.
