package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

	"cms_sidecar_backend/internal/db"
	"cms_sidecar_backend/internal/handlers"
)

func main() {
	// 1. Initialize Router
	router := gin.New()
	router.Use(gin.Recovery())

	// CORS: Allow All for Sidecar (localhost)
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowCredentials = true
	config.AddAllowHeaders("Authorization", "Content-Type")
	router.Use(cors.New(config))

	// 2. Determine Database Path
	// In production sidecar: standard location or local directory
	exePath, err := os.Executable()
	if err != nil {
		exePath = "."
	}
	exeDir := filepath.Dir(exePath)

	dbPath := os.Getenv("CMS_SQLITE_PATH")
	if dbPath == "" {
		// Default to a file next to the executable
		dbPath = filepath.Join(exeDir, "cms_data.db")
	}

	fmt.Printf("Initializing Database at: %s\n", dbPath)

	// 3. Connect Database
	database, err := db.Connect(dbPath)
	if err != nil {
		// Fallback for dev environment if sidecar path fails
		if dbPath == filepath.Join(exeDir, "cms_data.db") {
			dbPath = "cms_data.db" // Try purely relative
			database, err = db.Connect(dbPath)
		}

		if err != nil {
			fmt.Fprintf(os.Stderr, "FATAL: Could not open database: %v\n", err)
			os.Exit(1)
		}
	}

	// 4. Initialize Handlers & Routes
	h := handlers.New(database)
	h.Register(router)

	// 5. Health Check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":   "online",
			"backend":  "go-sidecar",
			"mode":     "production",
			"database": dbPath,
		})
	})

	// 6. Start Server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("CMS Sidecar Backend listening on port %s\n", port)
	if err := router.Run(":" + port); err != nil {
		fmt.Fprintf(os.Stderr, "Server exited: %v\n", err)
		os.Exit(1)
	}
}
