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
"perform" @keyword
"with" @keyword
"impl" @keyword
"pub" @keyword.modifier
"mut" @keyword.modifier
"import" @keyword
"enum" @keyword
"struct" @keyword
"interface" @keyword
"effect" @keyword
"meta" @keyword
"handler" @keyword

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

"::" @operator
":=" @operator
"=" @operator
"+=" @operator
"-=" @operator
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
(parameter (self) @variable.builtin)
(variable_declaration name: (identifier) @variable)
(type_definition name: (identifier) @type)
(enum_variant name: (identifier) @constructor)
(implementation type: (identifier) @type)
(implementation interface: (identifier) @interface)
(field_declaration name: (identifier) @property)
(struct_field name: (identifier) @property)

; Function definitions and signatures
(function_signature name: (identifier) @function)
(function_definition) @function
(function_block) @function

; Import paths
(import_path) @namespace

; General property access rule. This comes first.
(member_expression property: (identifier) @property)

; Call-specific rules. These come AFTER the general property rule to override it.
(call_expression
  function: (member_expression
    property: (identifier) @function.call))

; Path-based function calls (like std::fmt::println)
(call_expression
  function: (path_expression (identifier) @function.call))

; Expression highlighting
(parenthesized_expression) @expression
(path_expression) @expression
(binary_expression) @expression
(struct_expression) @expression
(if_expression) @expression
(while_expression) @expression
(match_expression) @expression
(with_expression) @expression
(perform_expression) @expression

; Pattern highlighting
(destructuring_pattern) @pattern
(match_arm) @pattern

; Block highlighting
(block) @block
(meta_block) @attribute

; Definition highlighting
(struct_definition) @type
(interface_definition) @type
(effect_definition) @type
(enum_definition) @type
(handler_definition) @type

;; ====================
;; TYPES (Specific Nodes)
;; ====================

(handler_type) @type
(generic_type name: (_) @type)
(function_type) @type
(never_type) @type.builtin
(primitive_type) @type.builtin

(type_parameters "<" @punctuation.bracket ">" @punctuation.bracket)

; Arguments and clauses
(arguments) @expression
(with_clause) @expression
