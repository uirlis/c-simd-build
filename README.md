# c-simd-build
An sample build system for c applications targeting WASM and crun.

Based on https://wasmedge.org/book/en/write_wasm/c/simd.html

## notes
This project already assumes you have a recent(=> 4.2) [podman installed](https://podman.io/getting-started/installation) on a fedora flavoured distro.

The build for the WASM container relies on [base.Dockerfile](./base.Dockerfile) which has been pushed to an [external repo](quay.io/uirlis/base-c-build).

See the [main Dockerfile](./Dockerfile) for details on the specific steps.

# build a wasm compatible crun

```bash
# Install dependancies for Fedora based distros
dnf install -y git python3 which redhat-lsb-core systemd-devel yajl-devel libseccomp-devel pkg-config libgcrypt-devel \
    glibc-static python3-libmount libtool libcap-devel

# Install the wasmedge libraries
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -p /usr/local --version=0.11.2

# Clone and build crun
git clone --depth 1 --recursive https://github.com/containers/crun.git
cd /crun
./autogen.sh
./configure --with-wasmedge --enable-embedded-yajl
make

# Overwrite the default crun installed with podman
export crun_loc=$(which crun)
sudo mv ${crun_loc} ${crun_loc}.backup
sudo mv crun ${crun_loc} 
```

## build the c file in the container
```
podman build -t c-simd-wasm .
```

## run

```
podman play kube pod.yaml
```

## view logs
```
podman logs c-simd-pod-container
...
16 16
  ���3�;���;�3����  P4
16 16
  ���3�;���;�3����  P4
...
```