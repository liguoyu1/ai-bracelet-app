# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app/backend
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/ .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server .

# Runtime
FROM alpine:3.19
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/server .
COPY backend/database/migrations ./database/migrations
RUN mkdir -p /data/uploads
EXPOSE 8080
CMD ["./server"]
