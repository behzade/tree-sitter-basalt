/**
 * @file Basalt Language
 * @author Behzad
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

const PREC = {
  assign: -1,
  with: 1,
  lambda: 2,
  or: 3,
  and: 4,
  equality: 5,
  comparison: 6,
  term: 7,
  factor: 8,
  unary: 9,
  return: 10,
  call: 11,
  path: 12,
  member: 13,
  pattern: 14,
  struct_literal: 15,
  function_signature: 16,
  function_type: 17,
};

const numeric_types = [
  "u8",
  "u16",
  "u32",
  "u64",
  "i8",
  "i16",
  "i32",
  "i64",
  "f32",
  "f64",
];

const primitive_types = numeric_types.concat(["bool", "char", "str"]);

const sep1 = (rule, sep) => seq(rule, repeat(seq(sep, rule)));

module.exports = grammar({
  name: "basalt",
  extras: ($) => [$.comment, /\s/],
  supertypes: ($) => [
    $._statement,
    $._declaration,
    $._expression,
    $._type,
    $._pattern,
  ],
  conflicts: ($) => [
    [$._expression, $._type],
    [$.type_declaration, $._type],
  ],
  word: ($) => $.identifier,

  rules: {
    source_file: ($) => repeat($._statement),

    _statement: ($) =>
      choice($._declaration, $.expression_statement, $.return_statement),

    expression_statement: ($) => seq($._expression, optional(";")),

    return_statement: ($) =>
      prec.right(PREC.return, seq("return", optional($._expression))),

    _declaration: ($) =>
      choice(
        $.import_declaration,
        $.type_declaration,
        $.interface_declaration,
        $.effect_declaration,
        $.handler_declaration,
        $.implementation,
        $.function_definition,
        $.variable_declaration,
      ),

    // Imports: import { path [as alias] ... }
    import_declaration: ($) =>
      seq("import", "{", repeat($.import_item), "}"),
    import_item: ($) =>
      seq($.import_path, optional(seq("as", field("alias", $.identifier)))),
    import_path: ($) => sep1($.identifier, "/"),

    // type Name = { fields } | V1(T) | V2(U) | Alias
    type_declaration: ($) =>
      seq(
        optional("pub"),
        "type",
        field("name", $.identifier),
        optional($.type_parameters_decl),
        "=",
        field("type", choice($.record_type, $.union_type, $._type)),
      ),

    // interface Name = { name: (params) -> Ret [with ...] ... }
    interface_declaration: ($) =>
      seq(
        optional("pub"),
        "interface",
        field("name", $.identifier),
        optional($.type_parameters_decl),
        "=",
        "{",
        optional(repeat($.function_signature)),
        "}",
      ),

    // effect Name[<T,...>] = { name: (params) -> Ret ... }
    effect_declaration: ($) =>
      seq(
        optional("pub"),
        "effect",
        field("name", $.identifier),
        optional($.type_parameters_decl),
        "=",
        "{",
        optional(repeat($.function_signature)),
        "}",
      ),

    // handler Name: Effect [with ...] [=] { fn defs }
    handler_declaration: ($) =>
      seq(
        optional("pub"),
        "handler",
        field("name", $.identifier),
        ":",
        field("effect", $._type),
        optional($.with_clause),
        optional("="),
        $.function_block,
      ),

    // impl Type [ : Interface ] = { fn defs }
    implementation: ($) =>
      seq(
        "impl",
        field("type", $.identifier),
        optional(seq(":", field("interface", $.identifier))),
        "=",
        $.function_block,
      ),

    function_block: ($) => seq("{", repeat($.function_definition), "}"),

    // let declarations (new syntax only)
    variable_declaration: ($) =>
      seq(
        "let",
        optional("mut"),
        field("name", $.identifier),
        optional(seq(":", field("type", $._type))),
        "=",
        field("value", $._expression),
      ),

    // Interface/effect member signatures (type-level)
    function_signature: ($) =>
      prec(
        PREC.function_signature,
        seq(field("name", $.identifier), ":", $.function_type),
      ),

    // Function definitions (value-level)
    function_definition: ($) =>
      seq($.function_head, field("body", $.block)),
    function_head: ($) =>
      seq(
        field("name", $.identifier),
        "(",
        optional(sep1($.parameter, ",")),
        ")",
        optional(seq("->", field("return_type", $._type))),
        optional($.with_clause),
      ),

    _expression: ($) =>
      choice(
        $.identifier,
        $._literal,
        $.path_expression,
        $.parenthesized_expression,
        $.binary_expression,
        $.call_expression,
        $.member_expression,
        $.block,
        $.struct_expression,
        $.if_expression,
        $.while_expression,
        $.match_expression,
        $.with_expression,
        $.with_block,
        $.perform_expression,
        $.meta_expression,
      ),

    parenthesized_expression: ($) => seq("(", $._expression, ")"),

    path_expression: ($) => prec(PREC.path, sep1($.identifier, "::")),

    binary_expression: ($) =>
      choice(
        // Assignment: mutation uses only <-
        prec.right(PREC.assign, seq($._expression, "<-", $._expression)),
        prec.left(PREC.term, seq($._expression, choice("+", "-"), $._expression)),
        prec.left(PREC.factor, seq($._expression, choice("*", "/"), $._expression)),
        prec.left(
          PREC.comparison,
          seq($._expression, choice(">", "<", ">=", "<="), $._expression),
        ),
        prec.left(PREC.equality, seq($._expression, choice("==", "!="), $._expression)),
      ),

    call_expression: ($) =>
      prec(PREC.call, seq(field("function", $._expression), field("arguments", $.arguments))),

    member_expression: ($) =>
      prec(PREC.member, seq(field("object", $._expression), ".", field("property", $.identifier))),

    block: ($) => prec(1, seq("{", repeat($._statement), optional($._expression), "}")),

    // Value-level record literals; optional leading type name (e.g., Person { ... })
    struct_expression: ($) =>
      prec(PREC.struct_literal, seq(optional(field("type", $._type)), "{", repeat($.struct_field), "}")),

    struct_field: ($) =>
      seq(field("name", $.identifier), ":", field("value", $._expression), optional(",")),

    // Type-level record type
    record_type: ($) =>
      seq("{", optional(repeat($.field_declaration)), "}"),
    field_declaration: ($) =>
      seq(field("name", $.identifier), ":", field("type", $._type), optional(",")),

    // Sum type: V1(T) | V2(U) | V3
    union_type: ($) => sep1($.union_variant, "|"),
    union_variant: ($) =>
      choice(
        // Prefer the payload form when '(' follows
        prec(1, seq(field("name", $.identifier), "(", field("data", $._type), ")")),
        prec(0, field("name", $.identifier)),
      ),

    if_expression: ($) =>
      prec.right(
        seq(
          "if",
          field("condition", $._expression),
          field("consequence", $.block),
          optional(seq("else", field("alternative", choice($.block, $.if_expression)))),
        ),
      ),

    while_expression: ($) => seq("while", field("condition", $._expression), field("body", $.block)),

    // match expr { arms }  OR  match expr | pat -> expr ...
    match_expression: ($) =>
      choice(
        // Braced form
        prec.left(1,
          seq(
            "match",
            $._expression,
            "{",
            optional(repeat($.match_arm_braced)),
            "}",
          ),
        ),
        // Pipe form
        prec.right(2, seq("match", $._expression, repeat1($.match_arm_pipe))),
      ),
    match_arm_braced: ($) =>
      prec(2, seq(field("pattern", $._pattern), "->", field("body", choice($.block, $._expression)), optional(","))),
    match_arm_pipe: ($) =>
      prec(2, seq("|", field("pattern", $._pattern), "->", field("body", $._expression))),

    // Call-site with expression: callee with {Handlers} or with block
    with_expression: ($) =>
      prec.left(
        PREC.with,
        seq(
          field("callee", $._expression),
          "with",
          field("handler", choice($.block, seq("{", sep1($.identifier, ","), "}"))),
        ),
      ),
    with_block: ($) =>
      seq(
        "with",
        field("handler", seq("{", sep1($.identifier, ","), "}")),
        field("body", $.block),
      ),

    perform_expression: ($) => seq("perform", $._expression),

    // meta as block or prefix to expression
    meta_expression: ($) =>
      prec.left(PREC.unary + 1, seq("meta", choice($.block, $._expression))),

    _pattern: ($) => choice($.identifier, $._literal, $.destructuring_pattern),

    destructuring_pattern: ($) =>
      prec(PREC.pattern, seq(field("type", $.path_expression), "(", field("name", $.identifier), ")")),

    _type: ($) =>
      choice(
        $.generic_type,
        $.function_type,
        $.never_type,
        $.handler_type,
        $.primitive_type,
        $.identifier,
        $.path_expression,
        $.record_type,
        $.union_type,
      ),

    primitive_type: ($) => alias(choice(...primitive_types), $.primitive_type),

    handler_type: ($) =>
      prec.right(1, seq("handler", field("effect", $._type), optional($.with_clause))),

    generic_type: ($) =>
      prec.right(
        PREC.call,
        seq(field("name", choice($.identifier, $.path_expression)), $.type_parameters),
      ),

    // For type declarations (e.g., type Name<T> = ...)
    type_parameters_decl: ($) => seq("<", sep1($.identifier, ","), ">"),

    type_parameters: ($) => seq("<", sep1($._type, ","), ">"),

    function_type: ($) =>
      prec.left(
        PREC.function_type,
        seq(
          seq("(", optional(sep1($.parameter, ",")), ")"),
          "->",
          $._type,
          optional($.with_clause),
        ),
      ),

    never_type: ($) => "!",

    parameter: ($) =>
      choice($.self_parameter, seq(field("name", $.identifier), ":", field("type", $._type))),
    self_parameter: ($) => seq(optional("mut"), alias("self", $.self)),

    arguments: ($) => seq("(", optional(sep1($._expression, ",")), ")"),

    with_clause: ($) =>
      prec(1, seq("with", choice($._type, seq("{", sep1($._type, ","), "}")))),

    _literal: ($) => choice($.integer_literal, $.string_literal),
    integer_literal: ($) => /\d+/,
    string_literal: ($) => /"([^"\\]|\\.)*"/,
    identifier: ($) => /[a-zA-Z_][a-zA-Z0-9_]*/,
    comment: ($) => token(seq("//", /.*/)),
  },
});
