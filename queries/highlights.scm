;; Keywords and Operators
[
  "import"
  "pub"
  "if"
  "else"
  "while"
  "match"
  "with"
  "perform"
  "meta"
  "handler"
  "impl"
  "mut"
] @keyword

[
  "struct"
  "interface"
  "enum"
  "effect"
] @tag

[
  "="
  ":="
  "+="
  "-="
  "+"
  "-"
  "*"
  "/"
  ">"
  "<"
  ">="
  "<="
  "=="
  "!="
  "->"
  "=>"
] @operator


;;; Punctuation
[ "{" "}" "(" ")" ] @punctuation.bracket
[ "," ";" ":" ] @punctuation.delimiter
[ "." "::" ] @punctuation.delimiter


;;; Literals and Comments
(comment) @comment
(string_literal) @string
(integer_literal) @number


;;; Types
(type_definition name: (identifier) @type)
(variable_declaration type: (_) @type)
(field_declaration type: (_) @type)
(parameter type: (_) @type)
(function_signature return_type: (_) @type)
(enum_variant data: (_) @type)
(generic_type name: (_) @type)
(type_parameters (_)) @type

;;; Built-in types
(never_type) @type.builtin
((identifier) @_id
  (#any-of? @_id "i32" "str")) @type.builtin


;;; Functions
(function_definition
  name: (identifier) @function)

(call_expression
  function: (identifier) @function)
(call_expression
  function: (path_expression
    member: (identifier) @function))
(call_expression
  function: (member_expression
    property: (identifier) @function))


;;; Constructors
(struct_expression
  type: (_) @constructor)

(enum_variant
  name: (identifier) @constructor)

(destructuring_pattern
  type: (_) @constructor)


;;; Properties, Parameters, and Variables
(member_expression
  property: (identifier) @property)

(struct_field
  name: (identifier) @property)

(path_expression
  module: (identifier) @namespace)

(variable_declaration
  name: (identifier) @variable)

(destructuring_pattern
  name: (identifier) @variable)

(parameter
  name: (identifier) @variable.parameter)

(lambda_expression
  (identifier) @variable.parameter)


;;; Fallback for any remaining identifier
(identifier) @variable


