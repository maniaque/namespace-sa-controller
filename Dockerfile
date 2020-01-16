FROM golang:1.9

WORKDIR /go/src/github.com/maniaque/namespace-sa-controller

RUN useradd -u 10001 kube-operator

RUN go get github.com/Masterminds/glide

COPY glide.yaml .
COPY glide.lock .

RUN glide install

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -v -i -o bin/linux/namespace-sa-controller ./cmd

FROM scratch
MAINTAINER Maniaque <maniaque.ru@gmail.com>

COPY --from=0 /etc/passwd /etc/passwd

USER kube-operator

COPY --from=0 /go/src/github.com/maniaque/namespace-sa-controller/bin/linux/namespace-sa-controller .

ENTRYPOINT ["./namespace-sa-controller"]
