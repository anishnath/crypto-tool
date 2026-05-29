package billing

import (
	"context"
	"encoding/json"
	"fmt"
)

// Exec runs a D1 statement (insert/update/delete).
func (s *D1Store) Exec(ctx context.Context, sql string, params ...interface{}) error {
	_, err := s.exec(ctx, sql, params...)
	return err
}

// QueryRows returns the first result set as a slice of column maps.
func (s *D1Store) QueryRows(ctx context.Context, sql string, params ...interface{}) ([]map[string]interface{}, error) {
	raw, err := s.exec(ctx, sql, params...)
	if err != nil {
		return nil, err
	}
	var parsed d1RowsEnvelope
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return nil, err
	}
	if len(parsed.Result) == 0 {
		return nil, nil
	}
	return parsed.Result[0].Results, nil
}

// Exists returns true when the query returns at least one row.
func (s *D1Store) Exists(ctx context.Context, sql string, params ...interface{}) (bool, error) {
	rows, err := s.QueryRows(ctx, sql, params...)
	if err != nil {
		return false, err
	}
	return len(rows) > 0, nil
}

// D1FromStore returns the concrete D1 store or an error if billing is disabled.
func D1FromStore(store Store) (*D1Store, error) {
	d1, ok := store.(*D1Store)
	if !ok || d1 == nil {
		return nil, fmt.Errorf("D1 billing store is not configured")
	}
	return d1, nil
}

type d1RowsEnvelope struct {
	Result []struct {
		Results []map[string]interface{} `json:"results"`
	} `json:"result"`
}
