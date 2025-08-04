;; ====================
;; IDENTIFIERS
;; ====================

(identifier) @variable

; Constants: ALL_CAPS
((identifier) @constant
 (#match? @constant "^[A-Z][A-Z\\d_]+$"))

; Type-like: UpperCamelCase
((identifier) @type)
  (#match? @type "^[A-Z][a-zA-Z\\d]*$")

;; ====================
;; DEFINITIONS
;; ====================

(function_definition name: (identifier) @function)
(method_signature name: (identifier) @method)
(parameter name: (identifier) @parameter)
(variable_declaration name: (identifier) @variable)

(type_definition name: (identifier) @type)
(enum_variant name: (identifier) @constructor)
(field_declaration name: (identifier) @property)
(struct_field name: (identifier) @property)
(implementation type: (identifier) @type)
(implementation interface: (identifier) @interface)

;; ====================
;; EXPRESSIONS
;; ====================

(call_expression function: (_) @function.call)
(member_expression property: (identifier) @property)
(path_expression module: (_) @namespace
                 member: (identifier) @property)

(lambda_expression) @function
(perform_expression) @keyword
(with_expression) @keyword

(block) @block
(meta_block) @attribute

;; ====================
;; TYPES
;; ====================

(handler_type) @type
(generic_type name: (_) @type)
(function_type) @type
(never_type) @type.builtin
(type_parameters "<" @punctuation.bracket ">" @punctuation.bracket)

;; ====================
;; LITERALS
;; ====================

(string_literal) @string
(integer_literal) @number

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
;; COMMENTS
;; ====================

(comment) @comment
((comment) @comment.documentation
 (#match? @comment.documentation "^///"))

;; ====================
;; PUNCTUATION & OPERATORS
;; ====================

"(" @punctuation.bracket
")" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
"<" @punctuation.bracket
">" @punctuation.bracket
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
