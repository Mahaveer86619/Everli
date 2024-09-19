package Implementations

import (
	"database/sql"
	"fmt"
	"math/rand"
	"net/http"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	middleware "github.com/Mahaveer86619/Everli/pkg/Middleware"
	services "github.com/Mahaveer86619/Everli/pkg/Services"

	"github.com/dgrijalva/jwt-go"
	"github.com/google/uuid"
)

type Credentials struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type CredentialsToReturn struct {
	ID              string `json:"id"`
	Username        string `json:"username"`
	Email           string `json:"email"`
	TokenKey        string `json:"tokenKey"`
	RefreshTokenKey string `json:"refreshTokenKey"`
}

type AuthenticatingUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RegisteringUser struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type ForgotPassword struct {
	ID    string `json:"id"`
	Email string `json:"email"`
	Code  string `json:"code"`
}

type SendPassResetCodeBody struct {
	Email string `json:"email"`
}

type CheckResetPassCodeBody struct {
	Code  string `json:"code"`
	Email string `json:"email"`
}

type ResetPassBody struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RefreshingToken struct {
	TokenKey        string `json:"tokenKey"`
	RefreshTokenKey string `json:"refreshTokenKey"`
}

func AuthenticateUser(user *AuthenticatingUser) (*CredentialsToReturn, int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT *
	  FROM auth
	  WHERE email = $1
	`

	var credentials Credentials

	// Search for user in database
	err := conn.QueryRow(
		search_query,
		user.Email,
	).Scan(
		&credentials.ID,
		&credentials.Username,
		&credentials.Email,
		&credentials.Password,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with email: %s", user.Email)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// User found, but password is wrong
	if credentials.Password != user.Password {
		return nil, http.StatusUnauthorized, fmt.Errorf("invalid password")
	}

	// Generate tokens
	token, err := middleware.GenerateToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating token: %w", err)
	}

	refreshToken, err := middleware.GenerateRefreshToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating refresh token: %w", err)
	}

	// Return credentials for successful authentication
	credsToReturn, err := genCredentialsToReturn(credentials, token, refreshToken)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return credsToReturn, http.StatusOK, nil
}

func RegisterUser(user *RegisteringUser) (*CredentialsToReturn, int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT *
	  FROM auth
	  WHERE email = $1
	`
	insert_query := `
		INSERT INTO auth (id, username, email, password)
		VALUES ($1, $2, $3, $4) RETURNING *
	`

	// If user already exists, return error
	var credentials Credentials
	credentials.ID = uuid.New().String()

	userNotFound := false
	err := conn.QueryRow(
		search_query,
		user.Email,
	).Scan(
		&credentials.ID,
		&credentials.Username,
		&credentials.Email,
		&credentials.Password,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			// User not found, so create user
			userNotFound = true
		} else {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}
	}

	// Create user
	if userNotFound {
		err := conn.QueryRow(
			insert_query,
			credentials.ID,
			user.Username,
			user.Email,
			user.Password,
		).Scan(
			&credentials.ID,
			&credentials.Username,
			&credentials.Email,
			&credentials.Password,
		)

		if err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error creating user: %w", err)
		}
	}

	// Generate tokens
	token, err := middleware.GenerateToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating token: %w", err)
	}

	refreshToken, err := middleware.GenerateRefreshToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating refresh token: %w", err)
	}

	// Return credentials for successful registration
	credsToReturn, err := genCredentialsToReturn(credentials, token, refreshToken)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return credsToReturn, http.StatusOK, nil
}

func SendPassResetCode(email string) (int, error) {
	conn := db.GetDBConnection()

	insert_query := `
		INSERT INTO forgot_password (id, email, code)
		VALUES ($1, $2, $3) RETURNING *
	`
	select_user_query := `
	  SELECT *
	  FROM auth
	  WHERE email = $1
	`

	var credentials Credentials

	// Search for user in database
	err := conn.QueryRow(
		select_user_query,
		email,
	).Scan(
		&credentials.ID,
		&credentials.Username,
		&credentials.Email,
		&credentials.Password,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("provided email is not registered: %s", email)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	var forgotPassword ForgotPassword
	forgotPassword.ID = uuid.New().String()
	forgotPassword.Email = email
	forgotPassword.Code = gen6DigitCode()

	err = conn.QueryRow(
		insert_query,
		forgotPassword.ID,
		forgotPassword.Email,
		forgotPassword.Code,
	).Scan(
		&forgotPassword.ID,
		&forgotPassword.Email,
		&forgotPassword.Code,
	)

	fmt.Println("Code: " + forgotPassword.Code)

	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error generating forgot password code: %w", err)
	}

	// Send email with forgot password code
	err = services.SendBasicHTMLEmail(
		[]string{email},
		"Reset your password",
		"<h1>Reset your password</h1><p>Please use the following code to reset your password:</p><p>"+forgotPassword.Code+"</p>",
	)

	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error sending email: %w", err)
	}

	return http.StatusOK, nil
}

func CheckResetPassCode(code string, email string) (string, int, error) {
	conn := db.GetDBConnection()

	select_query := `
	  SELECT *
	  FROM forgot_password
	  WHERE email = $1
	`
	del_query := "DELETE FROM forgot_password WHERE id = $1"

	var forgotPassword ForgotPassword

	// Search for forgot password in database
	if err := conn.QueryRow(
		select_query,
		email,
	).Scan(
		&forgotPassword.ID,
		&forgotPassword.Email,
		&forgotPassword.Code,
	); err != nil {
		if err == sql.ErrNoRows {
			return "", http.StatusNotFound, fmt.Errorf("forgot password row not found with email: %s", email)
		}
		return "", http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Delete forgot password row if code is correct
	if forgotPassword.Code != code {
		return "", http.StatusBadRequest, fmt.Errorf("invalid code")
	}

	_, err := conn.Exec(del_query, forgotPassword.ID)
	if err != nil {
		return "", http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	return forgotPassword.Code, http.StatusOK, nil
}

func ResetPassword(email string, password string) (int, error) {
	conn := db.GetDBConnection()

	query := `
	  UPDATE auth
	  SET password = $1
	  WHERE email = $2
	`

	_, err := conn.Exec(query, password, email)
	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("user not found with email: %s", email)
		}
		return http.StatusInternalServerError, fmt.Errorf("error updating password: %w", err)
	}

	return http.StatusOK, nil
}

func RefreshToken(refreshingToken *RefreshingToken) (*RefreshingToken, int, error) {
	claims := &middleware.Claims{}
	token, err := jwt.ParseWithClaims(refreshingToken.RefreshTokenKey, claims, func(token *jwt.Token) (interface{}, error) {
		return middleware.JwtKey, nil
	})

	if err != nil || !token.Valid {
		return nil, http.StatusUnauthorized, fmt.Errorf("invalid refresh token")
	}

	newToken, err := middleware.GenerateToken(claims.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error generating new token: %w", err)
	}

	newRefreshToken, err := middleware.GenerateRefreshToken(claims.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error generating new token: %w", err)
	}

	return &RefreshingToken{
		TokenKey:        newToken,
		RefreshTokenKey: newRefreshToken,
	}, http.StatusOK, nil
}

func genCredentialsToReturn(creds Credentials, token string, refresh_token string) (*CredentialsToReturn, error) {
	credsToReturn := &CredentialsToReturn{
		ID:       creds.ID,
		Username: creds.Username,
		Email:    creds.Email,
	}

	credsToReturn.TokenKey = token
	credsToReturn.RefreshTokenKey = refresh_token

	return credsToReturn, nil
}

func gen6DigitCode() string {
	return fmt.Sprint(rand.Intn(999999-100000) + 100000)
}
