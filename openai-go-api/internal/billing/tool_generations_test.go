package billing

import "testing"

func TestMergeToolGenerationFeed(t *testing.T) {
	viewer := UserIdentity{AnonymousID: "anon-a"}
	mine := []toolGenerationDBRow{
		{ID: "m1", Title: "Mine 1", TikzCode: "\\begin{tikzpicture}\\end{tikzpicture}"},
	}
	public := []toolGenerationDBRow{
		{ID: "m1", Title: "Mine 1 dup"},
		{ID: "p1", Title: "Public 1", TikzCode: "\\begin{tikzpicture}\\end{tikzpicture}"},
		{ID: "p2", Title: "Public 2", UserID: strPtr("user-9"), TikzCode: "\\begin{tikzpicture}\\end{tikzpicture}"},
	}

	out := mergeToolGenerationFeed(mine, public, viewer, 10, 10)
	if len(out) != 3 {
		t.Fatalf("expected 3 items, got %d", len(out))
	}
	if !out[0].IsMine || out[0].AuthorLabel != "You" {
		t.Fatalf("first item should be mine: %+v", out[0])
	}
	if out[1].AuthorLabel != "Guest" {
		t.Fatalf("expected guest label, got %q", out[1].AuthorLabel)
	}
	if out[2].AuthorLabel != "Member" {
		t.Fatalf("expected member label, got %q", out[2].AuthorLabel)
	}
}

func TestGenerationBelongsToViewerLoggedIn(t *testing.T) {
	viewer := UserIdentity{UserID: "user-1"}
	row := toolGenerationDBRow{UserID: strPtr("user-1")}
	if !generationBelongsToViewer(row, viewer) {
		t.Fatal("expected logged-in match")
	}
}

func strPtr(s string) *string { return &s }
