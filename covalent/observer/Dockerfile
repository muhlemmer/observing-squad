FROM golang:1.15.7 as builder

ARG CONFIG_TAG
ARG NETWORK

ENV CONFIG_FOLDER_NAME=elrond-config-$NETWORK

RUN git clone https://github.com/ElrondNetwork/$CONFIG_FOLDER_NAME && cd $CONFIG_FOLDER_NAME && git checkout --force tags/$CONFIG_TAG

RUN cat /go/$CONFIG_FOLDER_NAME/binaryVersion > ./result
RUN git clone https://github.com/ElrondNetwork/elrond-go.git && cd elrond-go && git checkout --force $(cat /go/result)

#Build node binary
WORKDIR /go/elrond-go/
RUN GO111MODULE=on go mod vendor

WORKDIR /go/elrond-go/cmd/node
RUN go build -i -v -ldflags="-X main.appVersion=$(git -C /go/$CONFIG_FOLDER_NAME describe --tags --long --dirty)"

RUN cp /go/pkg/mod/github.com/!elrond!network/arwen-wasm-vm@$(cat /go/elrond-go/go.mod | grep arwen-wasm-vm | sed 's/.* //' | tail -n 1)/wasmer/libwasmer_linux_amd64.so /lib/libwasmer_linux_amd64.so

#Copy the right configs to the node folder
WORKDIR /go/$CONFIG_FOLDER_NAME/
RUN cp -r * /go/elrond-go/cmd/node/config/

# ===== SECOND STAGE ======
FROM ubuntu:18.04
COPY --from=builder "/go/elrond-go/cmd/node" "/go/elrond-go/cmd/node/"
COPY --from=builder "/lib/libwasmer_linux_amd64.so" "/lib/libwasmer_linux_amd64.so"

#Enable "Database Lookup Extensions"
WORKDIR /go/elrond-go/cmd/node/
RUN sed -i '/\[DbLookupExtensions\]/!b;n;c\\tEnabled = true' ./config/config.toml

EXPOSE 8080
ENTRYPOINT ["/go/elrond-go/cmd/node/node", "--log-save", "--log-level=*:DEBUG,core/dblookupext:WARN", "--log-logger-name", "--rest-api-interface=0.0.0.0:8080"]
