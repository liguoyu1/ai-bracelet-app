package handlers

import (
	"encoding/json"
	"net/http"
)

type apiResponse struct {
	Success bool        `json:"success"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
	Total   int         `json:"total,omitempty"`
}

func writeJSON(w http.ResponseWriter, status int, v interface{}) {
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}

func success(w http.ResponseWriter, data interface{}) {
	writeJSON(w, http.StatusOK, apiResponse{Success: true, Data: data})
}

func created(w http.ResponseWriter, data interface{}) {
	writeJSON(w, http.StatusCreated, apiResponse{Success: true, Data: data})
}

func fail(w http.ResponseWriter, status int, msg string) {
	writeJSON(w, status, apiResponse{Success: false, Error: msg})
}

func decode(r *http.Request, v interface{}) error {
	defer r.Body.Close()
	return json.NewDecoder(r.Body).Decode(v)
}

func queryParam(r *http.Request, key, fallback string) string {
	if v := r.URL.Query().Get(key); v != "" {
		return v
	}
	return fallback
}

// localize overrides name/description on a struct with i18n<string> fields
// if a matching translation exists for the given lang.
func localize(obj map[string]interface{}, lang string) {
	if lang == "" || lang == "en" {
		return
	}
	i18n, ok := obj["i18n"].(map[string]interface{})
	if !ok {
		return
	}
	trans, ok := i18n[lang].(map[string]interface{})
	if !ok {
		return
	}
	for _, key := range []string{"name", "description", "material"} {
		if v, ok := trans[key].(string); ok && v != "" {
			obj[key] = v
		}
	}
	// Remove raw i18n from response to keep payload clean
	delete(obj, "i18n")
}

// structToMap marshals any struct to map[string]interface{} via JSON round-trip.
func structToMap(v interface{}) map[string]interface{} {
	data, _ := json.Marshal(v)
	var m map[string]interface{}
	json.Unmarshal(data, &m)
	return m
}
