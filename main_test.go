package main

import (
	"strings"
	"testing"
)

func TestVersion(t *testing.T) {
	if !strings.HasPrefix(version(), "demo ") {
		t.Fatalf("unexpected version string: %s", version())
	}
}
