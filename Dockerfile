FROM quay.io/uirlis/base-c-build:latest as builder

WORKDIR /usr/src/app
COPY . .

# Build WASM Libraries
RUN emcc -g -Oz --llvm-lto 1 -s STANDALONE_WASM -s INITIAL_MEMORY=32MB -s MAXIMUM_MEMORY=4GB \
    -mmutable-globals \
    -mnontrapping-fptoint \
    -msign-ext \
    mandelbrot-simd.c -o mandelbrot-simd.wasm

#AOT Code
RUN wasmedgec mandelbrot-simd.wasm mandelbrot-simd-out.wasm

RUN wasmedge mandelbrot-simd-out.wasm
FROM scratch

COPY --from=builder /usr/src/app/mandelbrot-simd-out.wasm /

# Run the web service on container startup.
CMD ["/mandelbrot-simd-out.wasm", "15"]