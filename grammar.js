/**
 * @file Basalt Language
 * @author Behzad Ehsani <ehsani.eof@gmail.com>
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
  ],
  word: ($) => $.identifier,

  rules: {
    source_file: ($) => repeat($._statement),

    _statement: ($) =>
      choice($._declaration, $.expression_statement, $.return_statement),

    expression_statement: ($) => prec(-1, seq($._expression, optional(";"))),

    return_statement: ($) =>
      prec.right(PREC.return, seq("return", optional($._expression))),

    _declaration: ($) =>
      choice(
        $.import_declaration,
        $.type_definition,
        $.implementation,
        $.function_definition,
        $.variable_declaration,
      ),

    import_declaration: ($) => seq("import", "{", repeat($.import_path), "}"),
    import_path: ($) => sep1($.identifier, "/"),

    type_definition: ($) =>
      seq(
        optional("pub"),
        field("name", $.identifier),
        ":",
        field(
          "type",
          choice(
            $.struct_definition,
            $.interface_definition,
            $.enum_definition,
            $.effect_definition,
            $.handler_definition,
          ),
        ),
      ),
    handler_definition: ($) =>
      seq(
        "handler",
        field("effect", $._type),
        optional($.with_clause),
        $.function_block,
      ),

    struct_definition: ($) =>
      seq("struct", "{", optional(repeat($.field_declaration)), "}"),
    interface_definition: ($) =>
      seq("interface", "{", optional(repeat($.function_signature)), "}"),
    effect_definition: ($) =>
      seq(
        "effect",
        optional($.type_parameters),
        "{",
        optional(repeat($.function_signature)),
        "}",
      ),

    field_declaration: ($) =>
      seq(
        field("name", $.identifier),
        ":",
        field("type", $._type),
        optional(","),
      ),

    enum_definition: ($) =>
      seq(
        "enum",
        "{",
        optional(repeat(seq($.enum_variant, optional(",")))),
        "}",
      ),
    enum_variant: ($) =>
      seq(
        field("name", $.identifier),
        optional(seq("(", field("data", $._type), ")")),
      ),

    function_block: ($) => seq("{", repeat($.function_definition), "}"),

    implementation: ($) =>
      seq(
        field("type", $.identifier),
        ":",
        "impl",
        field("interface", $.identifier),
        $.function_block,
      ),

    variable_declaration: ($) =>
      choice(
        seq(
          optional("mut"),
          field("name", $.identifier),
          seq(":", field("type", $._type)),
          "=",
          field("value", $._expression),
        ),
        seq(
          optional("mut"),
          field("name", $.identifier),
          ":=",
          field("value", $._expression),
        ),
      ),

    function_signature: ($) =>
      prec(
        PREC.function_signature,
        seq(field("name", $.identifier), ":", $.function_type),
      ),

    function_definition: ($) =>
      seq($.function_signature, field("body", $.block)),

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
        $.perform_expression,
        $.meta_block,
      ),

    parenthesized_expression: ($) => seq("(", $._expression, ")"),

    path_expression: ($) => prec(PREC.path, sep1($.identifier, "::")),

    binary_expression: ($) =>
      choice(
        prec.right(
          PREC.assign,
          seq($._expression, choice("=", "+=", "-="), $._expression),
        ),
        prec.left(
          PREC.term,
          seq($._expression, choice("+", "-"), $._expression),
        ),
        prec.left(
          PREC.factor,
          seq($._expression, choice("*", "/"), $._expression),
        ),
        prec.left(
          PREC.comparison,
          seq($._expression, choice(">", "<", ">=", "<="), $._expression),
        ),
        prec.left(
          PREC.equality,
          seq($._expression, choice("==", "!="), $._expression),
        ),
      ),

    call_expression: ($) =>
      prec(
        PREC.call,
        seq(field("function", $._expression), field("arguments", $.arguments)),
      ),

    member_expression: ($) =>
      prec(
        PREC.member,
        seq(
          field("object", $._expression),
          ".",
          field("property", $.identifier),
        ),
      ),

    block: ($) =>
      prec(1, seq("{", repeat($._statement), optional($._expression), "}")),

    struct_expression: ($) =>
      prec(
        PREC.struct_literal,
        seq(optional(field("type", $._type)), "{", repeat($.struct_field), "}"),
      ),

    struct_field: ($) =>
      seq(
        field("name", $.identifier),
        ":",
        field("value", $._expression),
        optional(","),
      ),

    if_expression: ($) =>
      prec.right(
        seq(
          "if",
          field("condition", $._expression),
          field("consequence", $.block),
          optional(
            seq("else", field("alternative", choice($.block, $.if_expression))),
          ),
        ),
      ),

    while_expression: ($) =>
      seq("while", field("condition", $._expression), field("body", $.block)),
    match_expression: ($) =>
      seq("match", $._expression, "{", optional(repeat($.match_arm)), "}"),
    match_arm: ($) =>
      seq(field("pattern", $._pattern), "=>", $._expression, optional(",")),

    with_expression: ($) =>
      prec.left(
        PREC.with,
        seq(
          field("callee", $._expression),
          "with",
          field(
            "handler",
            choice($.block, seq("{", sep1($.identifier, ","), "}")),
          ),
        ),
      ),

    perform_expression: ($) => seq("perform", $._expression),

    meta_block: ($) => seq("meta", $.block),

    _pattern: ($) => choice($.identifier, $._literal, $.destructuring_pattern),

    destructuring_pattern: ($) =>
      prec(
        PREC.pattern,
        seq(
          field("type", $.path_expression),
          "(",
          field("name", $.identifier),
          ")",
        ),
      ),

    _type: ($) =>
      choice(
        $.generic_type,
        $.function_type,
        $.never_type,
        $.handler_type,
        $.primitive_type,
        $.identifier,
        $.path_expression,
      ),

    primitive_type: ($) => alias(choice(...primitive_types), $.primitive_type),

    handler_type: ($) =>
      prec.right(
        1,
        seq("handler", field("effect", $._type), optional($.with_clause)),
      ),

    generic_type: ($) =>
      prec.right(
        PREC.call,
        seq(
          field("name", choice($.identifier, $.path_expression)),
          $.type_parameters,
        ),
      ),
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
      seq(field("name", $.identifier), ":", field("type", $._type)),
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
