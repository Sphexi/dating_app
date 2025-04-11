FROM --platform=$TARGETPLATFORM golang:1.22 AS build

# Set destination for COPY
WORKDIR /app
COPY . app

# Pull dependencies and build

RUN cd app && \
    go get -u github.com/gorilla/sessions && \
    go get -u github.com/lib/pq && \
    go get -u github.com/swaggo/http-swagger && \
    go get -u golang.org/x/crypto/bcrypt
    swag init && \
    go mod tidy && \
    go run main.go