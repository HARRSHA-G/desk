package main

import (
	"fmt"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/db"
	"github.com/quickgeo/cms-official-go/internal/handlers"
)

func main() {
	router := gin.New()
	router.Use(gin.Recovery())
	router.Use(cors.Default())

	dbPath := os.Getenv("CMS_SQLITE_PATH")
	if dbPath == "" {
		dbPath = "../backend/db.sqlite3"
	}

	database, err := db.Connect(dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not open database: %v\n", err)
		os.Exit(1)
	}

	h := handlers.New(database)
	h.Register(router)

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"success": true, "message": "go backend is healthy"})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	if err := router.Run(":" + port); err != nil {
		fmt.Fprintf(os.Stderr, "server exited: %v\n", err)
		os.Exit(1)
	}
}
