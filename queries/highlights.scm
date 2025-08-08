;; ====================
;; COMMENTS
;; ====================

(comment) @comment
((comment) @comment.documentation
 (#match? @comment.documentation "^///"))

;; ====================
;; KEYWORDS
;; ====================

"return" @keyword.control
"if" @keyword.control
"else" @keyword.control
"match" @keyword.control
"while" @keyword.control
"fn" @keyword
"perform" @keyword
"with" @keyword
"impl" @keyword
"pub" @keyword.modifier
"mut" @keyword.modifier
"import" @keyword
"type" @keyword
"interface" @keyword
"effect" @keyword
"meta" @keyword
"handler" @keyword
"let" @keyword
"as" @keyword

;; ====================
;; LITERALS
;; ====================

(string_literal) @string
(integer_literal) @number

;; ====================
;; PUNCTUATION & OPERATORS (General)
;; ====================

"(" @punctuation.bracket
")" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
"," @punctuation.delimiter
":" @punctuation.delimiter
"." @punctuation.delimiter
";" @punctuation.delimiter

"|" @operator
"->" @operator
"=" @operator
":=" @operator
"<-" @operator
"+" @operator
"-" @operator
"*" @operator
"/" @operator
"==" @operator
"!=" @operator
">=" @operator
"<=" @operator
">" @operator
"<" @operator

;; ====================
;; IDENTIFIERS (Generic, Regex-based)
;; ====================

(identifier) @variable

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z\\d_]+$"))

((identifier) @type
  (#match? @type "^[A-Z][a-zA-Z\\d]*$"))

;; ====================
;; DEFINITIONS & EXPRESSIONS (Context-specific)
;; ====================

; Definitions
(parameter name: (identifier) @parameter)
(self_parameter (self) @variable.builtin)
(variable_declaration name: (identifier) @variable)
(type_declaration name: (identifier) @type)
(union_variant name: (identifier) @constructor)
(implementation type: (identifier) @type)
(implementation interface: (identifier) @interface)
(field_declaration name: (identifier) @property)
(struct_field name: (identifier) @property)

; Function definitions and signatures
(function_signature name: (identifier) @function)
(function_definition name: (identifier) @function)

; Import paths
(import_path) @namespace
(import_item alias: (identifier) @namespace)

; General property access rule. This comes first.
(member_expression property: (identifier) @property)

; Call-specific rules. These come AFTER the general property rule to override it.
(call_expression
  function: (member_expression
    property: (identifier) @function.call))
(call_expression
  function: (identifier) @function.call)

; Expression highlighting
(parenthesized_expression) @expression
(binary_expression) @expression
(struct_expression) @expression
(if_expression) @expression
(while_expression) @expression
(match_expression) @expression
(with_block) @expression
(with_expression) @expression
(perform_expression) @expression

; Pattern highlighting
(destructuring_pattern) @pattern
(match_arm_braced) @pattern
(match_arm_pipe) @pattern

; Block highlighting
(block) @block
(meta_expression) @attribute

; Definition highlighting
(type_declaration) @type
(interface_declaration) @type
(effect_declaration) @type
(handler_declaration) @type

;; ====================
;; TYPES (Specific Nodes)
;; ====================

(handler_type) @type
(generic_type name: (_) @type)
(function_type) @type
(never_type) @type.builtin
(primitive_type) @type.builtin
(record_type) @type
(union_type) @type

(type_parameters "<" @punctuation.bracket ">" @punctuation.bracket)
(type_parameters_decl "<" @punctuation.bracket ">" @punctuation.bracket)

; Arguments and clauses
(arguments) @expression
(with_clause) @expression
