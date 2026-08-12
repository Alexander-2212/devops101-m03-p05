package main

import (
	"fmt"
	"net/http"
	"os"
	"runtime"
)

func version() string {
	return fmt.Sprintf("demo %s/%s", runtime.GOOS, runtime.GOARCH)
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, version())
	})

	addr := ":8080"
	fmt.Fprintf(os.Stdout, "%s listening on %s\n", version(), addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
