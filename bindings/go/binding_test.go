package tree_sitter_basalt_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_basalt "github.com/behzade/basalt/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_basalt.Language())
	if language == nil {
		t.Errorf("Error loading Basalt grammar")
	}
}
