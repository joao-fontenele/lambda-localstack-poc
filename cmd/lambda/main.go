package main

import (
	"context"
	"errors"
	"net/http"
	"strconv"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambda/messages"
)

type req struct {
	Message string `json:"message"`
}

type res struct {
	Message string `json:"message"`
}

func translateToAWSLambdaError(err error) error {
	if err == nil {
		return nil
	}

	return messages.InvokeResponse_Error{
		Message: err.Error(),
		Type:    strconv.Itoa(http.StatusInternalServerError),
	}
}

func handle(ctx context.Context, r req) (res, error) {
	var err error
	if r.Message == "shit" {
		err = errors.New("shit happens")
	}

	resp := res{Message: "success yay!"}

	if r.Message == "lol" {
		resp = res{Message: "Loooooool"}
	}

	return resp, translateToAWSLambdaError(err)
}

func main() {
	lambda.Start(handle)
}
