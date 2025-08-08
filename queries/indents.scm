;; Indentation queries for Basalt language
;; This file defines how indentation should work for different constructs

;; Block statements should indent their contents
(block) @indent

;; Function definitions should indent their body
(function_definition
  body: (_) @indent)

;; If expressions should indent their consequence and alternative
(if_expression
  consequence: (_) @indent
  alternative: (_) @indent)

;; While expressions should indent their body
(while_expression
  body: (_) @indent)

;; Match expressions should indent their arms
(match_expression) @indent

;; Struct definitions should indent their fields
(type_declaration) @indent

;; Interface definitions should indent their methods
(interface_declaration) @indent

;; Effect definitions should indent their methods
(effect_declaration) @indent

;; Enum definitions should indent their variants
(union_type) @indent

;; Implementation blocks should indent their functions
(implementation) @indent

;; Meta blocks should indent their contents
(meta_expression) @indent

;; With expressions should indent their handler
(with_expression
  handler: (_) @indent)

;; Dedent on closing braces
"}" @outdent 