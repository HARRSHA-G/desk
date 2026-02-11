package db

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/glebarez/sqlite"
	"gorm.io/gorm"
)

// Connect opens the SQLite database located at path and returns a gorm.DB instance.
func Connect(path string) (*gorm.DB, error) {
	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil, fmt.Errorf("could not resolve sqlite path %q: %w", path, err)
	}

	if _, err := os.Stat(absPath); err != nil {
		return nil, fmt.Errorf("sqlite file not found at %q: %w", absPath, err)
	}

	db, err := gorm.Open(sqlite.Open(absPath), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to open sqlite database: %w", err)
	}

	return db, nil
}
