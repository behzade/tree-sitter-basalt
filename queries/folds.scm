;; Code folding queries for Basalt
;; This file defines where code can be folded

;; Function definitions can be folded
(function_definition) @fold

;; Block statements can be folded
(block) @fold

;; If expressions can be folded
(if_expression) @fold

;; While expressions can be folded
(while_expression) @fold

;; Match expressions can be folded
(match_expression) @fold

;; Struct definitions can be folded
(struct_definition) @fold

;; Interface definitions can be folded
(interface_definition) @fold

;; Effect definitions can be folded
(effect_definition) @fold

;; Enum definitions can be folded
(enum_definition) @fold

;; Implementation blocks can be folded
(implementation) @fold

;; Meta blocks can be folded
(meta_block) @fold

;; Lambda expressions can be folded
(lambda_expression) @fold

;; With expressions can be folded
(with_expression) @fold 