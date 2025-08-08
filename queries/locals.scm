;; Local variable scoping queries for Basalt
;; This file defines the scope of variables and functions

;; Function definitions introduce a new scope
(function_definition
  (function_head name: (identifier) @definition.function)
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
(type_declaration
  name: (identifier) @definition.type)

;; Enum variants introduce constructors
(union_variant
  name: (identifier) @definition.constructor)

;; Import paths introduce namespaces
(import_item (import_path) @definition.namespace)
(import_item alias: (identifier) @definition.namespace)

;; References to variables
(identifier) @reference 