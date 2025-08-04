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

;; ✅ UPDATED: Added the '=>' operator for match arms.
"=>" @operator
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

;; A simple regex can't distinguish types from constants reliably,
;; but this captures ALL_CAPS constants.
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]+$"))

;; Capture PascalCase identifiers as types.
((identifier) @type
  (#match? @type "^[A-Z][a-zA-Z\\d]*$"))

;; ====================
;; DEFINITIONS & EXPRESSIONS (Context-specific)
;; ====================

; Definitions
(function_definition name: (identifier) @function)
(method_signature name: (identifier) @function)
(parameter name: (identifier) @parameter)
(variable_declaration name: (identifier) @variable)
(type_definition name: (identifier) @type)
(enum_variant name: (identifier) @constructor)
(implementation type: (identifier) @type)
(implementation interface: (identifier) @interface)
(field_declaration name: (identifier) @property)
(struct_field name: (identifier) @property)
(path_expression module: (_) @namespace)

; ✅ UPDATED: More specific pattern highlighting.
; For a pattern like `MyModule::MyVariant(data)`
(destructuring_pattern
  type: (path_expression
    module: (identifier) @namespace
    member: (identifier) @constructor)
  name: (identifier) @variable)

; For a pattern like `MyEnum::Variant` (without data)
(match_arm
  pattern: (path_expression
    member: (identifier) @constructor))

; General property access rule.
(member_expression property: (identifier) @property)

; Call-specific rules to override the general property rule.
(call_expression function: (identifier) @function.call)
(call_expression
  function: (member_expression
    property: (identifier) @function.call))

; ✅ UPDATED: Removed old `lambda_expression` and added the new `anonymous_function_expression`.
(anonymous_function_expression) @function

(block) @block
(meta_block) @attribute

;; ====================
;; TYPES (Specific Nodes)
;; ====================

; Highlight the return type of a function signature.
(function_signature return_type: (_) @type)
(parameter type: (_) @type)
(variable_declaration type: (_) @type)
(field_declaration type: (_) @type)

(handler_type) @type
(generic_type name: (_) @type)
(function_type) @type
(never_type) @type.builtin

(type_parameters "<" @punctuation.bracket ">" @punctuation.bracket)
