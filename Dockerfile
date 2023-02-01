FROM quay.io/uirlis/base-c-build:latest as builder

WORKDIR /usr/src/app
COPY . .

# Build WASM Libraries
RUN emcc -g -Oz --llvm-lto 1 -s STANDALONE_WASM -s INITIAL_MEMORY=32MB -s MAXIMUM_MEMORY=4GB \
    -mmutable-globals \
    -mnontrapping-fptoint \
    -msign-ext \
    mandelbrot.c -o mandelbrot.wasm

#AOT Code
RUN wasmedgec mandelbrot.wasm mandelbrot-aot.wasm

RUN wasmedge mandelbrot-aot.wasm
FROM scratch

COPY --from=builder /usr/src/app/mandelbrot-aot.wasm /

# Run the web service on container startup.
CMD ["/mandelbrot-simd-out.wasm", "15"]