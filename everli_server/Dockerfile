# # Stage 1: Build the Go application
# FROM golang:1.22-alpine AS builder
# WORKDIR /app

# COPY go.mod go.sum ./
# RUN go mod download

# COPY . .
# RUN go build -o main main.go

# # Stage 2: Create the final image with PostgreSQL
# FROM postgres:latest
# WORKDIR /app

# COPY --from=builder /app/main .

# # Environment variables
# ENV APP_ENV production
# ENV POSTGRES_PASSWORD V3H5v5nNw5ysks0
# ENV POSTGRES_USER everli_server
# ENV POSTGRES_DB everli
# ENV POSTGRES_HOST db
# ENV POSTGRES_PORT 5432

# # Command to start the application
# CMD ["./main"]

FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o main main.go

CMD ["./main"]