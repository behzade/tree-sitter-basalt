;; Local variable scoping queries for Basalt
;; This file defines the scope of variables and functions

;; Function definitions introduce a new scope
(function_definition
  (function_signature
    name: (identifier) @definition.function)
  body: (_) @scope)

;; Variable declarations introduce variables in the current scope
(variable_declaration
  name: (identifier) @definition.var)

;; Parameters introduce variables in the function scope
(parameter
  name: (identifier) @definition.parameter)

;; Struct fields introduce properties
(struct_field
  name: (identifier) @definition.field)

;; Type definitions introduce types
(type_definition
  name: (identifier) @definition.type)

;; Enum variants introduce constructors
(enum_variant
  name: (identifier) @definition.constructor)

;; Import paths introduce namespaces
(import_declaration
  (import_path) @definition.namespace)

;; References to variables
(identifier) @reference 