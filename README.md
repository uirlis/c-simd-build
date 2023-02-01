# c-simd-build
An sample build system for c applications targeting WASM and crun.

Based on https://wasmedge.org/book/en/write_wasm/c/simd.html

## notes

The build for the WASM container relies on [base.Dockerfile](./base.Dockerfile) which has been pushed to an [external repo](quay.io/uirlis/base-c-build).

See the [main Dockerfile](./Dockerfile) for details on the specific steps.

## build
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