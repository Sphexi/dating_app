FROM --platform=$TARGETPLATFORM golang:1.22 AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

# Build your app into a binary (call it whatever you want)
RUN CGO_ENABLED=0 GOOS=linux go build -o server

WORKDIR /app
COPY --from=build /app/server .

EXPOSE 8080
CMD ["./server"]