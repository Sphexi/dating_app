FROM --platform=$TARGETPLATFORM golang:1.22 AS build

# Set destination for COPY
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
# Pull dependencies and build
#RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping && \
#    go get -u github.com/gorilla/sessions && \
#    go get -u github.com/lib/pq && \
#    go get -u github.com/swaggo/http-swagger && \
#    go get -u golang.org/x/crypto/bcrypt
#    go mod tidy && \
#    go run main.go


# Temp commenting out below, it isn't working rn trying something fresh and new
#RUN CGO_ENABLED=0 GOOS=linux go build -o /dating-app
#EXPOSE 8080
#CMD ["/dating-app"]

RUN go run main.go