# Build gqlc in a stock Go builder container
FROM golang:1.12.1-alpine as builder


RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /qlcchain/oracle
RUN cd /qlcchain/oracle && make clean build

# Pull gqlc into a second stage deploy alpine container
FROM alpine:latest

COPY --from=builder /qlcchain/oracle/build/goracle .

EXPOSE 9738

ENTRYPOINT [ "/goracle" ]
