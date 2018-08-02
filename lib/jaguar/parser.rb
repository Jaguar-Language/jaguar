#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

require_relative "lexer"
require_relative "nodes"
require_relative "parse_error"

module Jaguar

class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 166)
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code)
    puts @tokens.inspect if show_tokens
    do_parse
  end

  def next_token
    @tokens.shift
  end

  def on_error(error_token_id, error_value, value_stack)
    raise ParseError.new(token_to_str(error_token_id), error_value, value_stack)
  end

...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    29,    16,    28,    66,    26,    27,    90,    25,    16,    18,
    19,    20,    21,    22,    23,    24,    29,    57,    28,    98,
    26,    27,    90,    25,    16,    18,    19,    20,    21,    22,
    23,    24,    57,    88,    64,    29,    17,    28,    62,    26,
    27,    15,    25,    17,    18,    19,    20,    21,    22,    23,
    24,    29,   105,    28,   125,    26,    27,    15,    25,    17,
    18,    19,    20,    21,    22,    23,    24,    57,    29,   102,
    28,   109,    26,    27,   107,    25,    15,    18,    19,    20,
    21,    22,    23,    24,    29,   102,    28,   122,    26,    27,
    96,    25,    15,    18,    19,    20,    21,    22,    23,    24,
   102,    29,   118,    28,    61,    26,    27,    60,    25,    15,
    18,    19,    20,    21,    22,    23,    24,    29,   105,    28,
   115,    26,    27,   112,    25,    15,    18,    19,    20,    21,
    22,    23,    24,   102,    29,   101,    28,    59,    26,    27,
    58,    25,    15,    18,    19,    20,    21,    22,    23,    24,
    29,   102,    28,   124,    26,    27,   116,    25,    15,    18,
    19,    20,    21,    22,    23,    24,    51,    29,    90,    28,
    30,    26,    27,    57,    25,    15,    18,    19,    20,    21,
    22,    23,    24,    29,    57,    28,    93,    26,    27,    92,
    25,    15,    18,    19,    20,    21,    22,    23,    24,   100,
    29,   nil,    28,   nil,    26,    27,   nil,    25,    15,    18,
    19,    20,    21,    22,    23,    24,    29,   nil,    28,   nil,
    26,    27,   nil,    25,    15,    18,    19,    20,    21,    22,
    23,    24,   nil,    29,   nil,    28,   nil,    26,    27,   nil,
    25,    15,    18,    19,    20,    21,    22,    23,    24,    29,
   nil,    28,   nil,    26,    27,   nil,    25,    15,    18,    19,
    20,    21,    22,    23,    24,   nil,    29,   nil,    28,   nil,
    26,    27,   nil,    25,    15,    18,    19,    20,    21,    22,
    23,    24,    29,   nil,    28,   nil,    26,    27,   nil,    25,
    15,    18,    19,    20,    21,    22,    23,    24,   nil,    29,
   nil,    28,   nil,    26,    27,   nil,    25,    15,    18,    19,
    20,    21,    22,    23,    24,    29,   nil,    28,   nil,    26,
    27,   nil,    25,    15,    18,    19,    20,    21,    22,    23,
    24,   nil,    29,   nil,    28,   nil,    26,    27,   nil,    25,
    15,    18,    19,    20,    21,    22,    23,    24,    29,   nil,
    28,   nil,    26,    27,   nil,    25,    15,    18,    19,    20,
    21,    22,    23,    24,   nil,    29,   nil,    28,   nil,    26,
    27,   nil,    25,    15,    18,    19,    20,    21,    22,    23,
    24,    29,   nil,    28,   nil,    26,    27,   nil,    25,    15,
    18,    19,    20,    21,    22,    23,    24,   nil,    29,   nil,
    28,   nil,    26,    27,   nil,    25,    15,    18,    19,    20,
    21,    22,    23,    24,    29,   nil,    28,   nil,    26,    27,
   nil,    25,    15,    18,    19,    20,    21,    22,    23,    24,
   nil,    29,   nil,    28,   nil,    26,    27,   nil,    25,    15,
    18,    19,    20,    21,    22,    23,    24,    29,   nil,    28,
   nil,    26,    27,   nil,    25,    15,    18,    19,    20,    21,
    22,    23,    24,    90,    29,   nil,    28,    57,    26,    27,
    57,    25,    15,    18,    19,    20,    21,    22,    23,    24,
    16,    32,    57,    45,    46,    41,    42,   nil,    15,   106,
   110,   105,    54,    56,    32,    53,    45,    46,    41,    42,
    49,    50,    47,    48,   nil,    15,   105,    32,   nil,    45,
    46,    41,    42,   nil,    32,    17,    45,    46,    41,    42,
    49,    50,    47,    48,    37,    38,    39,    40,    35,    36,
    43,    44,    34,    33,   nil,    57,   nil,    32,    84,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    33,    32,   nil,    45,
    46,    41,    42,    49,    50,    47,    48,    37,    38,    39,
    40,    35,    36,    43,    44,    34,    32,   nil,    45,    46,
    41,    42,    49,    50,    47,    48,    37,    38,    39,    40,
    35,    36,    43,    44,    32,   nil,    45,    46,    41,    42,
    49,    50,    47,    48,    37,    38,    39,    40,    35,    36,
    43,    44,    32,   nil,    45,    46,    41,    42,    49,    50,
    47,    48,    37,    38,    39,    40,    35,    36,    43,    44,
    32,   nil,    45,    46,    41,    42,    49,    50,    47,    48,
    37,    38,    39,    40,    32,   nil,    45,    46,    41,    42,
    49,    50,    47,    48,    37,    38,    39,    40,    32,   nil,
    45,    46,    41,    42,    49,    50,    47,    48,    32,   nil,
    45,    46,    41,    42,    49,    50,    47,    48,    32,   nil,
    45,    46,    41,    42,    49,    50,    47,    48,    32,   nil,
    45,    46,    41,    42,    49,    50,    32,   nil,    45,    46,
    41,    42,    49,    50,    32,   nil,   -71,   -71,   -71,   -71,
    32,   nil,   -71,   -71,   -71,   -71 ]

racc_action_check = [
    57,     2,    57,    32,    57,    57,    56,    57,    57,    57,
    57,    57,    57,    57,    57,    57,     0,   115,     0,    62,
     0,     0,    88,     0,     0,     0,     0,     0,     0,     0,
     0,     0,    62,    56,    30,   107,     2,   107,    28,   107,
   107,    57,   107,    57,   107,   107,   107,   107,   107,   107,
   107,    15,   119,    15,   119,    15,    15,     0,    15,     0,
    15,    15,    15,    15,    15,    15,    15,    61,   102,    94,
   102,    94,   102,   102,    92,   102,   107,   102,   102,   102,
   102,   102,   102,   102,   100,   113,   100,   113,   100,   100,
    61,   100,    15,   100,   100,   100,   100,   100,   100,   100,
   108,    35,   108,    35,    27,    35,    35,    26,    35,   102,
    35,    35,    35,    35,    35,    35,    35,    60,   103,    60,
   103,    60,    60,    98,    60,   100,    60,    60,    60,    60,
    60,    60,    60,    85,    44,    85,    44,    25,    44,    44,
    24,    44,    35,    44,    44,    44,    44,    44,    44,    44,
    47,   117,    47,   117,    47,    47,   105,    47,    60,    47,
    47,    47,    47,    47,    47,    47,     8,    48,   110,    48,
     1,    48,    48,   112,    48,    44,    48,    48,    48,    48,
    48,    48,    48,    49,   125,    49,    59,    49,    49,    58,
    49,    47,    49,    49,    49,    49,    49,    49,    49,    66,
    50,   nil,    50,   nil,    50,    50,   nil,    50,    48,    50,
    50,    50,    50,    50,    50,    50,    51,   nil,    51,   nil,
    51,    51,   nil,    51,    49,    51,    51,    51,    51,    51,
    51,    51,   nil,    53,   nil,    53,   nil,    53,    53,   nil,
    53,    50,    53,    53,    53,    53,    53,    53,    53,    54,
   nil,    54,   nil,    54,    54,   nil,    54,    51,    54,    54,
    54,    54,    54,    54,    54,   nil,    93,   nil,    93,   nil,
    93,    93,   nil,    93,    53,    93,    93,    93,    93,    93,
    93,    93,    29,   nil,    29,   nil,    29,    29,   nil,    29,
    54,    29,    29,    29,    29,    29,    29,    29,   nil,    31,
   nil,    31,   nil,    31,    31,   nil,    31,    93,    31,    31,
    31,    31,    31,    31,    31,    33,   nil,    33,   nil,    33,
    33,   nil,    33,    29,    33,    33,    33,    33,    33,    33,
    33,   nil,    34,   nil,    34,   nil,    34,    34,   nil,    34,
    31,    34,    34,    34,    34,    34,    34,    34,    36,   nil,
    36,   nil,    36,    36,   nil,    36,    33,    36,    36,    36,
    36,    36,    36,    36,   nil,    37,   nil,    37,   nil,    37,
    37,   nil,    37,    34,    37,    37,    37,    37,    37,    37,
    37,    38,   nil,    38,   nil,    38,    38,   nil,    38,    36,
    38,    38,    38,    38,    38,    38,    38,   nil,    39,   nil,
    39,   nil,    39,    39,   nil,    39,    37,    39,    39,    39,
    39,    39,    39,    39,    40,   nil,    40,   nil,    40,    40,
   nil,    40,    38,    40,    40,    40,    40,    40,    40,    40,
   nil,    41,   nil,    41,   nil,    41,    41,   nil,    41,    39,
    41,    41,    41,    41,    41,    41,    41,    42,   nil,    42,
   nil,    42,    42,   nil,    42,    40,    42,    42,    42,    42,
    42,    42,    42,    96,    43,   nil,    43,    89,    43,    43,
    23,    43,    41,    43,    43,    43,    43,    43,    43,    43,
    91,    82,   111,    82,    82,    82,    82,   nil,    42,    91,
    96,    89,    23,    23,    71,    23,    71,    71,    71,    71,
    71,    71,    71,    71,   nil,    43,   111,    81,   nil,    81,
    81,    81,    81,   nil,    52,    91,    52,    52,    52,    52,
    52,    52,    52,    52,    52,    52,    52,    52,    52,    52,
    52,    52,    52,    52,   nil,    63,   nil,    63,    52,    63,
    63,    63,    63,    63,    63,    63,    63,    63,    63,    63,
    63,    63,    63,    63,    63,    63,    63,    65,   nil,    65,
    65,    65,    65,    65,    65,    65,    65,    65,    65,    65,
    65,    65,    65,    65,    65,    65,    65,     3,   nil,     3,
     3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     3,    83,   nil,    83,
    83,    83,    83,    83,    83,    83,    83,    83,    83,    83,
    83,    83,    83,    83,    83,    83,    83,    86,   nil,    86,
    86,    86,    86,    86,    86,    86,    86,    86,    86,    86,
    86,    86,    86,    86,    86,    86,    86,    87,   nil,    87,
    87,    87,    87,    87,    87,    87,    87,    87,    87,    87,
    87,    87,    87,    87,    87,    87,    87,   114,   nil,   114,
   114,   114,   114,   114,   114,   114,   114,   114,   114,   114,
   114,   114,   114,   114,   114,   114,   114,    67,   nil,    67,
    67,    67,    67,    67,    67,    67,    67,    67,    67,    67,
    67,    67,    67,    67,    67,    67,    77,   nil,    77,    77,
    77,    77,    77,    77,    77,    77,    77,    77,    77,    77,
    77,    77,    77,    77,    78,   nil,    78,    78,    78,    78,
    78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
    78,    78,    68,   nil,    68,    68,    68,    68,    68,    68,
    68,    68,    68,    68,    68,    68,    68,    68,    68,    68,
    70,   nil,    70,    70,    70,    70,    70,    70,    70,    70,
    70,    70,    70,    70,    69,   nil,    69,    69,    69,    69,
    69,    69,    69,    69,    69,    69,    69,    69,    72,   nil,
    72,    72,    72,    72,    72,    72,    72,    72,    73,   nil,
    73,    73,    73,    73,    73,    73,    73,    73,    74,   nil,
    74,    74,    74,    74,    74,    74,    74,    74,    80,   nil,
    80,    80,    80,    80,    80,    80,    79,   nil,    79,    79,
    79,    79,    79,    79,    76,   nil,    76,    76,    76,    76,
    75,   nil,    75,    75,    75,    75 ]

racc_action_pointer = [
    14,   170,    -9,   557,   nil,   nil,   nil,   nil,   126,   nil,
   nil,   nil,   nil,   nil,   nil,    49,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   452,   120,   120,    64,    88,    21,   280,
    34,   297,   -13,   313,   330,    99,   346,   363,   379,   396,
   412,   429,   445,   462,   132,   nil,   nil,   148,   165,   181,
   198,   214,   494,   231,   247,   nil,   -10,    -2,   173,   143,
   115,    49,    14,   517,   nil,   537,   156,   657,   712,   744,
   730,   474,   758,   768,   778,   810,   804,   676,   694,   796,
   788,   487,   461,   577,   nil,    91,   597,   617,     6,   449,
   nil,   470,    31,   264,    27,   nil,   447,   nil,   106,   nil,
    82,   nil,    66,    76,   nil,   140,   nil,    33,    58,   nil,
   152,   464,   155,    43,   637,    -1,   nil,   109,   nil,    10,
   nil,   nil,   nil,   nil,   nil,   166,   nil ]

racc_action_default = [
    -1,   -71,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -14,   -15,   -16,   -71,   -18,   -19,   -20,   -21,
   -22,   -23,   -24,   -25,   -52,   -71,   -71,   -71,   -71,   -71,
   -71,    -5,   -71,   -71,   -71,   -71,   -71,   -71,   -71,   -71,
   -71,   -71,   -71,   -71,   -71,   -46,   -47,   -71,   -71,   -71,
   -71,   -71,   -71,   -31,   -71,   -58,   -64,   -71,   -71,   -55,
   -31,   -71,   -71,   -71,   127,    -4,   -29,   -34,   -35,   -36,
   -37,   -38,   -39,   -40,   -41,   -42,   -43,   -44,   -45,   -48,
   -49,   -50,   -51,   -54,   -17,   -71,   -32,   -53,   -64,   -71,
   -65,   -71,   -27,   -31,   -71,   -61,   -64,   -67,   -71,   -69,
   -31,   -26,   -71,   -71,   -60,   -71,   -70,   -31,   -71,   -57,
   -64,   -71,   -71,   -71,   -33,   -71,   -66,   -71,   -56,   -71,
   -63,   -68,   -30,   -59,   -28,   -71,   -62 ]

racc_goto_table = [
     3,    31,     1,   nil,     2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    89,   nil,    52,    85,   nil,   nil,   nil,
    55,   nil,   nil,    94,   nil,   nil,   nil,   nil,   nil,    63,
   nil,    65,   nil,    67,    68,    69,    70,    71,    72,    73,
    74,    75,    76,    77,    78,   103,   nil,    79,    80,    81,
    82,    83,   nil,   111,    87,   nil,   108,     3,    95,    97,
    99,    91,   nil,   113,   nil,   nil,   nil,   119,   nil,   nil,
   117,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   104,   nil,   nil,   nil,
    31,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   114,   nil,   nil,   nil,   nil,   nil,   120,   121,
   nil,   nil,   123,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   126 ]

racc_goto_check = [
     3,     4,     1,   nil,     2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    17,   nil,     3,    15,   nil,   nil,   nil,
    16,   nil,   nil,    15,   nil,   nil,   nil,   nil,   nil,     3,
   nil,     3,   nil,     3,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     3,    17,   nil,     3,     3,     3,
     3,     3,   nil,    17,     3,   nil,    15,     3,    16,    16,
    16,     2,   nil,    15,   nil,   nil,   nil,    17,   nil,   nil,
    15,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    16,   nil,   nil,   nil,
     4,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     3,   nil,   nil,   nil,   nil,   nil,    16,    16,
   nil,   nil,    16,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    16 ]

racc_goto_pointer = [
   nil,     2,     4,     0,    -1,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   -37,    -3,   -43 ]

racc_goto_default = [
   nil,   nil,   nil,    86,     4,     5,     6,     7,     8,     9,
    10,    11,    12,    13,    14,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 47, :_reduce_1,
  1, 47, :_reduce_2,
  1, 48, :_reduce_3,
  3, 48, :_reduce_4,
  2, 48, :_reduce_5,
  1, 48, :_reduce_6,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  1, 49, :_reduce_none,
  3, 49, :_reduce_17,
  1, 50, :_reduce_none,
  1, 50, :_reduce_none,
  1, 51, :_reduce_20,
  1, 51, :_reduce_21,
  1, 51, :_reduce_22,
  1, 51, :_reduce_23,
  1, 51, :_reduce_24,
  1, 52, :_reduce_25,
  4, 52, :_reduce_26,
  3, 52, :_reduce_27,
  6, 52, :_reduce_28,
  3, 52, :_reduce_29,
  6, 52, :_reduce_30,
  0, 61, :_reduce_31,
  1, 61, :_reduce_32,
  3, 61, :_reduce_33,
  3, 53, :_reduce_34,
  3, 53, :_reduce_35,
  3, 53, :_reduce_36,
  3, 53, :_reduce_37,
  3, 53, :_reduce_38,
  3, 53, :_reduce_39,
  3, 53, :_reduce_40,
  3, 53, :_reduce_41,
  3, 53, :_reduce_42,
  3, 53, :_reduce_43,
  3, 53, :_reduce_44,
  3, 53, :_reduce_45,
  2, 53, :_reduce_46,
  2, 53, :_reduce_47,
  3, 53, :_reduce_48,
  3, 53, :_reduce_49,
  3, 53, :_reduce_50,
  3, 53, :_reduce_51,
  1, 54, :_reduce_52,
  3, 55, :_reduce_53,
  3, 55, :_reduce_54,
  2, 58, :_reduce_55,
  5, 58, :_reduce_56,
  4, 56, :_reduce_57,
  2, 57, :_reduce_58,
  6, 57, :_reduce_59,
  4, 57, :_reduce_60,
  3, 57, :_reduce_61,
  7, 57, :_reduce_62,
  5, 57, :_reduce_63,
  0, 63, :_reduce_64,
  1, 63, :_reduce_65,
  3, 63, :_reduce_66,
  3, 59, :_reduce_67,
  5, 59, :_reduce_68,
  3, 60, :_reduce_69,
  3, 62, :_reduce_70 ]

racc_reduce_n = 71

racc_shift_n = 127

racc_token_table = {
  false => 0,
  :error => 1,
  :IF => 2,
  :ELSE => 3,
  :CLASS => 4,
  :EXTENDS => 5,
  :SUPER => 6,
  :STATIC => 7,
  :THIS => 8,
  :NEW => 9,
  :NEWLINE => 10,
  :NUMBER => 11,
  :STRING => 12,
  :TRUE => 13,
  :FALSE => 14,
  :NULL => 15,
  :IDENTIFIER => 16,
  :CONSTANT => 17,
  :INDENT => 18,
  :DEDENT => 19,
  "." => 20,
  "!" => 21,
  "++" => 22,
  "--" => 23,
  "+=" => 24,
  "-=" => 25,
  "*" => 26,
  "/" => 27,
  "+" => 28,
  "-" => 29,
  ">" => 30,
  ">=" => 31,
  "<" => 32,
  "<=" => 33,
  "==" => 34,
  "!=" => 35,
  "*=" => 36,
  "/=" => 37,
  "&&" => 38,
  "||" => 39,
  "=" => 40,
  ":" => 41,
  "," => 42,
  "(" => 43,
  ")" => 44,
  ";" => 45 }

racc_nt_base = 46

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "IF",
  "ELSE",
  "CLASS",
  "EXTENDS",
  "SUPER",
  "STATIC",
  "THIS",
  "NEW",
  "NEWLINE",
  "NUMBER",
  "STRING",
  "TRUE",
  "FALSE",
  "NULL",
  "IDENTIFIER",
  "CONSTANT",
  "INDENT",
  "DEDENT",
  "\".\"",
  "\"!\"",
  "\"++\"",
  "\"--\"",
  "\"+=\"",
  "\"-=\"",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\">\"",
  "\">=\"",
  "\"<\"",
  "\"<=\"",
  "\"==\"",
  "\"!=\"",
  "\"*=\"",
  "\"/=\"",
  "\"&&\"",
  "\"||\"",
  "\"=\"",
  "\":\"",
  "\",\"",
  "\"(\"",
  "\")\"",
  "\";\"",
  "$start",
  "Root",
  "Expressions",
  "Expression",
  "Terminator",
  "Literal",
  "Call",
  "Operator",
  "Constant",
  "Assign",
  "Super",
  "FunctionDeclaration",
  "New",
  "Class",
  "If",
  "ArgList",
  "Block",
  "ParamList" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 31)
  def _reduce_1(val, _values, result)
     result = Nodes.new([]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 32)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 36)
  def _reduce_3(val, _values, result)
     result = Nodes.new(val) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 37)
  def _reduce_4(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 38)
  def _reduce_5(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 39)
  def _reduce_6(val, _values, result)
     result = Nodes.new([]) 
    result
  end
.,.,

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

# reduce 15 omitted

# reduce 16 omitted

module_eval(<<'.,.,', 'grammar.y', 53)
  def _reduce_17(val, _values, result)
     result = val[1] 
    result
  end
.,.,

# reduce 18 omitted

# reduce 19 omitted

module_eval(<<'.,.,', 'grammar.y', 62)
  def _reduce_20(val, _values, result)
     result = NumberNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 63)
  def _reduce_21(val, _values, result)
     result = StringNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 64)
  def _reduce_22(val, _values, result)
     result = TrueNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 65)
  def _reduce_23(val, _values, result)
     result = FalseNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 66)
  def _reduce_24(val, _values, result)
     result = NullNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 70)
  def _reduce_25(val, _values, result)
     result = CallNode.new(nil, val[0], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 71)
  def _reduce_26(val, _values, result)
     result = CallNode.new(nil, val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 72)
  def _reduce_27(val, _values, result)
     result = StaticCallNode.new(val[0], val[2], [])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 74)
  def _reduce_28(val, _values, result)
     result = StaticCallNode.new(val[0], val[2], val[4]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 75)
  def _reduce_29(val, _values, result)
     result = CallNode.new(val[0], val[2], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 77)
  def _reduce_30(val, _values, result)
     result = CallNode.new(val[0], val[2], val[4]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 81)
  def _reduce_31(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 82)
  def _reduce_32(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 83)
  def _reduce_33(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 87)
  def _reduce_34(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 88)
  def _reduce_35(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 89)
  def _reduce_36(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 90)
  def _reduce_37(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 91)
  def _reduce_38(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 92)
  def _reduce_39(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 93)
  def _reduce_40(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 94)
  def _reduce_41(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 95)
  def _reduce_42(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 96)
  def _reduce_43(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 97)
  def _reduce_44(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 98)
  def _reduce_45(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 99)
  def _reduce_46(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 100)
  def _reduce_47(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 101)
  def _reduce_48(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 102)
  def _reduce_49(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 103)
  def _reduce_50(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 104)
  def _reduce_51(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 108)
  def _reduce_52(val, _values, result)
     result = GetConstantNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 112)
  def _reduce_53(val, _values, result)
     result = SetLocalNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 113)
  def _reduce_54(val, _values, result)
     result = SetConstantNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 117)
  def _reduce_55(val, _values, result)
     result = NewNode.new(val[1], nil) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 118)
  def _reduce_56(val, _values, result)
     result = NewNode.new(val[1], val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 122)
  def _reduce_57(val, _values, result)
     result = SuperNode.new(val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 126)
  def _reduce_58(val, _values, result)
     result = DefNode.new(val[0], [], val[1], false) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 128)
  def _reduce_59(val, _values, result)
     result = DefNode.new(val[0], val[3], val[5], false) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 129)
  def _reduce_60(val, _values, result)
     result = DefNode.new(val[0], val[2], val[3], false) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 130)
  def _reduce_61(val, _values, result)
     result = DefNode.new(val[1], [], val[2], true) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 132)
  def _reduce_62(val, _values, result)
     result = DefNode.new(val[1], val[4], val[6], true) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 133)
  def _reduce_63(val, _values, result)
     result = DefNode.new(val[1], val[3], val[4], true) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 137)
  def _reduce_64(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 138)
  def _reduce_65(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 139)
  def _reduce_66(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 143)
  def _reduce_67(val, _values, result)
     result = ClassNode.new(val[1], val[2], nil) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 144)
  def _reduce_68(val, _values, result)
     result = ClassNode.new(val[1], val[4], val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 148)
  def _reduce_69(val, _values, result)
     result = IfNode.new(val[1], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 152)
  def _reduce_70(val, _values, result)
     result = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end
