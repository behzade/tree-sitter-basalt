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
(variable_declaration name: (identifier) @variable)
(type_definition name: (identifier) @type)
(enum_variant name: (identifier) @constructor)
(implementation type: (identifier) @type)
(implementation interface: (identifier) @interface)
(field_declaration name: (identifier) @property)
(struct_field name: (identifier) @property)

; General property access rule. This comes first.
(member_expression property: (identifier) @property)

; Call-specific rules. These come AFTER the general property rule to override it.
(call_expression
  function: (member_expression
    property: (identifier) @function.call))

(block) @block
(meta_block) @attribute

;; ====================
;; TYPES (Specific Nodes)
;; ====================

(handler_type) @type
(generic_type name: (_) @type)
(function_type) @type
(never_type) @type.builtin

(type_parameters "<" @punctuation.bracket ">" @punctuation.bracket)
