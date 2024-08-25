package pkg

import (
	"database/sql"
	"fmt"
	"net/http"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	middleware "github.com/Mahaveer86619/Everli/pkg/Middleware"
	"github.com/google/uuid"
	"github.com/dgrijalva/jwt-go"
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

type RefreshingToken struct {
	TokenKey string `json:"tokenKey"`
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
		TokenKey: newToken,
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
