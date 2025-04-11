# Stage 1: Build the Go binary
FROM --platform=$TARGETPLATFORM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# Stage 2: Create a small final image
FROM gcr.io/distroless/static:nonroot

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]