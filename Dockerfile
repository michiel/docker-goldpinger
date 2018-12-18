FROM golang:1.11-alpine as builder
RUN apk add --update git make curl bash
RUN go get github.com/bloomberg/goldpinger/cmd/goldpinger
WORKDIR /go/src/github.com/bloomberg/goldpinger
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN make vendor
RUN make bin/goldpinger

FROM scratch
COPY --from=builder /go/src/github.com/bloomberg/goldpinger/bin/goldpinger /goldpinger
ENTRYPOINT ["/goldpinger", "--static-file-path", "/static"]

