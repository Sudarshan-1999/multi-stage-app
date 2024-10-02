# Stage 1: Build the Go app
FROM golang:1.20-alpine AS builder

# Set environment variables
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Create and set the working directory
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN go build -o myapp .

# Stage 2: Run the Go app
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built Go binary from the previous stage
COPY --from=builder /app/myapp .

# Expose the port that the Go app runs on
EXPOSE 8080

# Command to run the Go app
CMD ["./myapp"]
