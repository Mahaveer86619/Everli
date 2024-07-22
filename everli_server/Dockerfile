FROM golang:1.22-alpine

WORKDIR /app

COPY go.* ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o main main.go

CMD ["./main"]
