package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"strings"

	resp "github.com/Mahaveer86619/Everli/pkg/Response"
	services "github.com/Mahaveer86619/Everli/pkg/Services"
)

func SendBasicEmailHandler(w http.ResponseWriter, r *http.Request) {
	var reqBody services.BasicEmailRequestBody
	err := json.NewDecoder(r.Body).Decode(&reqBody)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	to := strings.Split(reqBody.To, ",")

	err = services.SendBasicEmail(to, reqBody.Subject, reqBody.Body)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusInternalServerError)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(nil)
	successResponse.SetMessage("Email sent successfully")
	successResponse.JSON(w)
}

func SendBasicHTMLEmailHandler(w http.ResponseWriter, r *http.Request) {
	var reqBody services.BasicEmailRequestBody
	err := json.NewDecoder(r.Body).Decode(&reqBody)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	to := strings.Split(reqBody.To, ",")

	err = services.SendBasicHTMLEmail(to, reqBody.Subject, reqBody.Body)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusInternalServerError)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(nil)
	successResponse.SetMessage("Email sent successfully")
	successResponse.JSON(w)
}

func SendTemplateEmailHandler(w http.ResponseWriter, r *http.Request) {
	var reqBody services.TemplateEmailRequestBody
	err := json.NewDecoder(r.Body).Decode(&reqBody)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	to := strings.Split(reqBody.To, ",")

	fmt.Println("./templates/" + reqBody.Template + ".html")

	temp, err := template.ParseFiles("everli_server/pkg/Handlers/templates/forgot_password.html")
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusInternalServerError)
		failureResponse.SetMessage("failed to parse template => " + err.Error())
		failureResponse.JSON(w)
		return
	}

	var renderedTemplate bytes.Buffer
	if err = temp.Execute(&renderedTemplate, reqBody.Vars); err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusInternalServerError)
		failureResponse.SetMessage("failed to execute template => " + err.Error())
		failureResponse.JSON(w)
		return
	}

	err = services.SendBasicHTMLEmail(to, reqBody.Subject, renderedTemplate.String())
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusInternalServerError)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(nil)
	successResponse.SetMessage("Email sent successfully")
	successResponse.JSON(w)
}
