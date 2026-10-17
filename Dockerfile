# The C library and its C++ wrapper, as released (src-rs/corvus-json-schema-capi in Corvus.JsonSchema). Its version is
# this tag, which Dependabot keeps up to date.
FROM ghcr.io/corvus-dotnet/corvus-json-schema-c:0.1.4 AS corvus

FROM alpine:3.24 AS build
RUN apk add --no-cache cmake g++ make nlohmann-json
COPY --from=corvus /corvus-json-schema/linux-musl /opt/corvus-json-schema
COPY CMakeLists.txt bowtie_corvus_json_schema.cpp /src/
RUN cmake -S /src -B /build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/corvus-json-schema \
 && cmake --build /build --parallel 4

FROM alpine:3.24
RUN apk add --no-cache libstdc++ libgcc
COPY --from=build /build/bowtie_corvus_json_schema /usr/local/bin/
CMD ["bowtie_corvus_json_schema"]
