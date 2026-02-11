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

	// Note: glebarez/sqlite creates the file if missing, so checking existence is good but not strictly required for driver.
	// However, if we want to ensure we don't accidentally create empty DBs in wrong places, keep check or loosen it.
	// Let's keep the check for now as main.go handles creation.

	if _, err := os.Stat(absPath); err != nil {
		// If file doesn't exist, we can try to create it or let GORM handle it.
		// But main.go logic relies on existing file? Let's assume it exists.
		return nil, fmt.Errorf("sqlite file not found at %q: %w", absPath, err)
	}

	db, err := gorm.Open(sqlite.Open(absPath), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to open sqlite database: %w", err)
	}

	return db, nil
}
