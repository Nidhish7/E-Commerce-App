# -----------------------------------Stage:1 - Builder -----------------------------------

# Selecting a builder image
FROM golang:1.23.5 AS builder
# Setting up the workdir
WORKDIR /usr/src/app
# Copying the source code to the workdir
COPY main.go .
# Compile the Go binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o order-service main.go && chmod +x order-service
# -----------------------------------Stage:2 - Image -----------------------------------

# Selecting the base image
FROM alpine:latest
# Setting up the workdir
WORKDIR /usr/src/app
# Copying everything from the builder image
COPY --from=builder /usr/src/app/order-service .
# Expose port
EXPOSE 5003
# Define the Entrypoint
ENTRYPOINT ["./order-service"]
