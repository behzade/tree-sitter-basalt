;; Language injection queries for Basalt
;; This file defines where other languages might be injected

;; String literals could potentially contain other languages
;; (though Basalt doesn't have template literals like JavaScript)
(string_literal) @injection.content

;; Comments could potentially contain other languages
(comment) @injection.content 