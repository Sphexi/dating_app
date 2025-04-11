FROM --platform=$TARGETPLATFORM golang:1.22 AS build

# Set destination for COPY
WORKDIR /app
COPY . app

# Pull dependencies and build
cd app
RUN go get -u github.com/gorilla/sessions
RUN go get -u github.com/lib/pq
RUN go get -u github.com/swaggo/http-swagger
RUN go get -u golang.org/x/crypto/bcrypt

swag init
go mod tidy
go run main.go