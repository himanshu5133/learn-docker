##
## Build
##

FROM golang:1.23-alpine AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY *.go ./

RUN go build -o /my-go-app

# Run the tests in the container
FROM build AS run-test-stage
RUN go test -v ./...

##
## Deploy
##

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /my-go-app /my-go-app

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/my-go-app"]