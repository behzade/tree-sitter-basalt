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
(match_expression
  body: (_) @indent)

;; Struct definitions should indent their fields
(struct_definition) @indent

;; Interface definitions should indent their methods
(interface_definition) @indent

;; Effect definitions should indent their methods
(effect_definition) @indent

;; Enum definitions should indent their variants
(enum_definition) @indent

;; Implementation blocks should indent their functions
(implementation) @indent

;; Meta blocks should indent their contents
(meta_block) @indent

;; Lambda expressions should indent their body
(lambda_expression
  body: (_) @indent)

;; With expressions should indent their handler
(with_expression
  handler: (_) @indent)

;; Dedent on closing braces
"}" @outdent 