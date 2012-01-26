
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy_hlw or yy_hlw, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define yy_hlwBISON 1

/* Bison version.  */
#define yy_hlwBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define yy_hlwSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define yy_hlwPURE 1

/* Push parsers.  */
#define yy_hlwPUSH 0

/* Pull parsers.  */
#define yy_hlwPULL 1

/* Using locations.  */
#define yy_hlwLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 37 "jsgf_parser.y"

#include <stdio.h>
#include <string.h>

#include <hash_table.h>
#include <ckd_alloc.h>
#include <err.h>

#include "jsgf_internal.h"
#include "jsgf_parser.h"
#include "jsgf_scanner.h"

void yy_hlwerror(yy_hlwscan_t lex, jsgf_t *jsgf, const char *s);



/* Line 189 of yacc.c  */
#line 90 "jsgf_parser.c"

/* Enabling traces.  */
#ifndef yy_hlwDEBUG
# define yy_hlwDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef yy_hlwERROR_VERBOSE
# undef yy_hlwERROR_VERBOSE
# define yy_hlwERROR_VERBOSE 1
#else
# define yy_hlwERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef yy_hlwTOKEN_TABLE
# define yy_hlwTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef yy_hlwTOKENTYPE
# define yy_hlwTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yy_hlwtokentype {
     HEADER = 258,
     GRAMMAR = 259,
     IMPORT = 260,
     PUBLIC = 261,
     TOKEN = 262,
     RULENAME = 263,
     TAG = 264,
     WEIGHT = 265
   };
#endif
/* Tokens.  */
#define HEADER 258
#define GRAMMAR 259
#define IMPORT 260
#define PUBLIC 261
#define TOKEN 262
#define RULENAME 263
#define TAG 264
#define WEIGHT 265




#if ! defined yy_hlwSTYPE && ! defined yy_hlwSTYPE_IS_DECLARED
typedef union yy_hlwSTYPE
{

/* Line 214 of yacc.c  */
#line 58 "jsgf_parser.y"

       char *name;
       float weight;
       jsgf_rule_t *rule;
       jsgf_rhs_t *rhs;
       jsgf_atom_t *atom;



/* Line 214 of yacc.c  */
#line 156 "jsgf_parser.c"
} yy_hlwSTYPE;
# define yy_hlwSTYPE_IS_TRIVIAL 1
# define yy_hlwstype yy_hlwSTYPE /* obsolescent; will be withdrawn */
# define yy_hlwSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 168 "jsgf_parser.c"

#ifdef short
# undef short
#endif

#ifdef yy_hlwTYPE_UINT8
typedef yy_hlwTYPE_UINT8 yy_hlwtype_uint8;
#else
typedef unsigned char yy_hlwtype_uint8;
#endif

#ifdef yy_hlwTYPE_INT8
typedef yy_hlwTYPE_INT8 yy_hlwtype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yy_hlwtype_int8;
#else
typedef short int yy_hlwtype_int8;
#endif

#ifdef yy_hlwTYPE_UINT16
typedef yy_hlwTYPE_UINT16 yy_hlwtype_uint16;
#else
typedef unsigned short int yy_hlwtype_uint16;
#endif

#ifdef yy_hlwTYPE_INT16
typedef yy_hlwTYPE_INT16 yy_hlwtype_int16;
#else
typedef short int yy_hlwtype_int16;
#endif

#ifndef yy_hlwSIZE_T
# ifdef __SIZE_TYPE__
#  define yy_hlwSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define yy_hlwSIZE_T size_t
# elif ! defined yy_hlwSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define yy_hlwSIZE_T size_t
# else
#  define yy_hlwSIZE_T unsigned int
# endif
#endif

#define yy_hlwSIZE_MAXIMUM ((yy_hlwSIZE_T) -1)

#ifndef yy_hlw_
# if yy_hlwENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define yy_hlw_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef yy_hlw_
#  define yy_hlw_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define yy_hlwUSE(e) ((void) (e))
#else
# define yy_hlwUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define yy_hlwID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
yy_hlwID (int yy_hlwi)
#else
static int
yy_hlwID (yy_hlwi)
    int yy_hlwi;
#endif
{
  return yy_hlwi;
}
#endif

#if ! defined yy_hlwoverflow || yy_hlwERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef yy_hlwSTACK_USE_ALLOCA
#  if yy_hlwSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define yy_hlwSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define yy_hlwSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define yy_hlwSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef yy_hlwSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define yy_hlwSTACK_FREE(Ptr) do { /* empty */; } while (yy_hlwID (0))
#  ifndef yy_hlwSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define yy_hlwSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define yy_hlwSTACK_ALLOC yy_hlwMALLOC
#  define yy_hlwSTACK_FREE yy_hlwFREE
#  ifndef yy_hlwSTACK_ALLOC_MAXIMUM
#   define yy_hlwSTACK_ALLOC_MAXIMUM yy_hlwSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined yy_hlwMALLOC || defined malloc) \
	     && (defined yy_hlwFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef yy_hlwMALLOC
#   define yy_hlwMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (yy_hlwSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef yy_hlwFREE
#   define yy_hlwFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yy_hlwoverflow || yy_hlwERROR_VERBOSE */


#if (! defined yy_hlwoverflow \
     && (! defined __cplusplus \
	 || (defined yy_hlwSTYPE_IS_TRIVIAL && yy_hlwSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yy_hlwalloc
{
  yy_hlwtype_int16 yy_hlwss_alloc;
  yy_hlwSTYPE yy_hlwvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define yy_hlwSTACK_GAP_MAXIMUM (sizeof (union yy_hlwalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define yy_hlwSTACK_BYTES(N) \
     ((N) * (sizeof (yy_hlwtype_int16) + sizeof (yy_hlwSTYPE)) \
      + yy_hlwSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef yy_hlwCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define yy_hlwCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define yy_hlwCOPY(To, From, Count)		\
      do					\
	{					\
	  yy_hlwSIZE_T yy_hlwi;				\
	  for (yy_hlwi = 0; yy_hlwi < (Count); yy_hlwi++)	\
	    (To)[yy_hlwi] = (From)[yy_hlwi];		\
	}					\
      while (yy_hlwID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables yy_hlwSIZE and yy_hlwSTACKSIZE give the old and new number of
   elements in the stack, and yy_hlwPTR gives the new location of the
   stack.  Advance yy_hlwPTR to a properly aligned location for the next
   stack.  */
# define yy_hlwSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	yy_hlwSIZE_T yy_hlwnewbytes;						\
	yy_hlwCOPY (&yy_hlwptr->Stack_alloc, Stack, yy_hlwsize);			\
	Stack = &yy_hlwptr->Stack_alloc;					\
	yy_hlwnewbytes = yy_hlwstacksize * sizeof (*Stack) + yy_hlwSTACK_GAP_MAXIMUM; \
	yy_hlwptr += yy_hlwnewbytes / sizeof (*yy_hlwptr);				\
      }									\
    while (yy_hlwID (0))

#endif

/* yy_hlwFINAL -- State number of the termination state.  */
#define yy_hlwFINAL  7
/* yy_hlwLAST -- Last index in yy_hlwTABLE.  */
#define yy_hlwLAST   54

/* yy_hlwNTOKENS -- Number of terminals.  */
#define yy_hlwNTOKENS  20
/* yy_hlwNNTS -- Number of nonterminals.  */
#define yy_hlwNNTS  16
/* yy_hlwNRULES -- Number of rules.  */
#define yy_hlwNRULES  33
/* yy_hlwNRULES -- Number of states.  */
#define yy_hlwNSTATES  58

/* yy_hlwTRANSLATE(yy_hlwLEX) -- Bison symbol number corresponding to yy_hlwLEX.  */
#define yy_hlwUNDEFTOK  2
#define yy_hlwMAXUTOK   265

#define yy_hlwTRANSLATE(yy_hlwX)						\
  ((unsigned int) (yy_hlwX) <= yy_hlwMAXUTOK ? yy_hlwtranslate[yy_hlwX] : yy_hlwUNDEFTOK)

/* yy_hlwTRANSLATE[yy_hlwLEX] -- Bison symbol number corresponding to yy_hlwLEX.  */
static const yy_hlwtype_uint8 yy_hlwtranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      14,    15,    18,    19,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    11,
       2,    12,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    16,     2,    17,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    13,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10
};

#if yy_hlwDEBUG
/* yy_hlwPRHS[yy_hlwN] -- Index of the first RHS symbol of rule number yy_hlwN in
   yy_hlwRHS.  */
static const yy_hlwtype_uint8 yy_hlwprhs[] =
{
       0,     0,     3,     5,     8,    12,    15,    18,    22,    27,
      33,    37,    39,    42,    46,    48,    51,    56,    62,    64,
      68,    70,    73,    75,    78,    80,    83,    87,    91,    93,
      95,    97,    99,   102
};

/* yy_hlwRHS -- A `-1'-separated list of the rules' RHS.  */
static const yy_hlwtype_int8 yy_hlwrhs[] =
{
      21,     0,    -1,    22,    -1,    22,    27,    -1,    22,    25,
      27,    -1,    23,    24,    -1,     3,    11,    -1,     3,     7,
      11,    -1,     3,     7,     7,    11,    -1,     3,     7,     7,
       7,    11,    -1,     4,     7,    11,    -1,    26,    -1,    25,
      26,    -1,     5,     8,    11,    -1,    28,    -1,    27,    28,
      -1,     8,    12,    29,    11,    -1,     6,     8,    12,    29,
      11,    -1,    30,    -1,    29,    13,    30,    -1,    31,    -1,
      30,    31,    -1,    32,    -1,    31,     9,    -1,    35,    -1,
      10,    35,    -1,    14,    29,    15,    -1,    16,    29,    17,
      -1,     7,    -1,     8,    -1,    33,    -1,    34,    -1,    35,
      18,    -1,    35,    19,    -1
};

/* yy_hlwRLINE[yy_hlwN] -- source line where rule number yy_hlwN was defined.  */
static const yy_hlwtype_uint8 yy_hlwrline[] =
{
       0,    75,    75,    76,    77,    80,    83,    84,    85,    86,
      90,    93,    94,    97,   100,   101,   104,   105,   108,   109,
     114,   116,   120,   121,   125,   126,   129,   132,   135,   136,
     137,   138,   139,   140
};
#endif

#if yy_hlwDEBUG || yy_hlwERROR_VERBOSE || yy_hlwTOKEN_TABLE
/* yy_hlwTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at yy_hlwNTOKENS, nonterminals.  */
static const char *const yy_hlwtname[] =
{
  "$end", "error", "$undefined", "HEADER", "GRAMMAR", "IMPORT", "PUBLIC",
  "TOKEN", "RULENAME", "TAG", "WEIGHT", "';'", "'='", "'|'", "'('", "')'",
  "'['", "']'", "'*'", "'+'", "$accept", "grammar", "header",
  "jsgf_header", "grammar_header", "import_header", "import_statement",
  "rule_list", "rule", "alternate_list", "rule_expansion",
  "tagged_rule_item", "rule_item", "rule_group", "rule_optional",
  "rule_atom", 0
};
#endif

# ifdef yy_hlwPRINT
/* yy_hlwTOKNUM[yy_hlwLEX-NUM] -- Internal token number corresponding to
   token yy_hlwLEX-NUM.  */
static const yy_hlwtype_uint16 yy_hlwtoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,    59,    61,   124,    40,    41,    91,    93,    42,    43
};
# endif

/* yy_hlwR1[yy_hlwN] -- Symbol number of symbol that rule yy_hlwN derives.  */
static const yy_hlwtype_uint8 yy_hlwr1[] =
{
       0,    20,    21,    21,    21,    22,    23,    23,    23,    23,
      24,    25,    25,    26,    27,    27,    28,    28,    29,    29,
      30,    30,    31,    31,    32,    32,    33,    34,    35,    35,
      35,    35,    35,    35
};

/* yy_hlwR2[yy_hlwN] -- Number of symbols composing right hand side of rule yy_hlwN.  */
static const yy_hlwtype_uint8 yy_hlwr2[] =
{
       0,     2,     1,     2,     3,     2,     2,     3,     4,     5,
       3,     1,     2,     3,     1,     2,     4,     5,     1,     3,
       1,     2,     1,     2,     1,     2,     3,     3,     1,     1,
       1,     1,     2,     2
};

/* yy_hlwDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when yy_hlwTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yy_hlwtype_uint8 yy_hlwdefact[] =
{
       0,     0,     0,     2,     0,     0,     6,     1,     0,     0,
       0,     0,    11,     3,    14,     0,     5,     0,     7,     0,
       0,     0,    12,     4,    15,     0,     0,     8,    13,     0,
      28,    29,     0,     0,     0,     0,    18,    20,    22,    30,
      31,    24,    10,     9,     0,    25,     0,     0,    16,     0,
      21,    23,    32,    33,    17,    26,    27,    19
};

/* yy_hlwDEFGOTO[NTERM-NUM].  */
static const yy_hlwtype_int8 yy_hlwdefgoto[] =
{
      -1,     2,     3,     4,    16,    11,    12,    13,    14,    35,
      36,    37,    38,    39,    40,    41
};

/* yy_hlwPACT[STATE-NUM] -- Index in yy_hlwTABLE of the portion describing
   STATE-NUM.  */
#define yy_hlwPACT_NINF -37
static const yy_hlwtype_int8 yy_hlwpact[] =
{
      -1,    -2,    36,    22,    35,     8,   -37,   -37,    32,    33,
      30,    22,   -37,    17,   -37,    37,   -37,    13,   -37,    34,
      31,    -4,   -37,    17,   -37,    38,    39,   -37,   -37,    -4,
     -37,   -37,     0,    -4,    -4,    18,    -4,    42,   -37,   -37,
     -37,    19,   -37,   -37,    21,    19,    20,     9,   -37,    -4,
      42,   -37,   -37,   -37,   -37,   -37,   -37,    -4
};

/* yy_hlwPGOTO[NTERM-NUM].  */
static const yy_hlwtype_int8 yy_hlwpgoto[] =
{
     -37,   -37,   -37,   -37,   -37,   -37,    41,    43,   -12,   -16,
      -3,   -36,   -37,   -37,   -37,    15
};

/* yy_hlwTABLE[yy_hlwPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what yy_hlwDEFACT says.
   If yy_hlwTABLE_NINF, syntax error.  */
#define yy_hlwTABLE_NINF -1
static const yy_hlwtype_uint8 yy_hlwtable[] =
{
      50,    24,     1,    30,    31,     5,    32,    30,    31,     6,
      33,    24,    34,    44,    33,    17,    34,    46,    47,    18,
      26,    50,    49,     9,    27,    10,    56,     8,     9,    48,
      10,    49,    54,    49,    49,    55,     7,    52,    53,    15,
      19,    20,    21,    29,    25,    28,    57,    45,     0,    42,
      43,    51,    22,     0,    23
};

static const yy_hlwtype_int8 yy_hlwcheck[] =
{
      36,    13,     3,     7,     8,     7,    10,     7,     8,    11,
      14,    23,    16,    29,    14,     7,    16,    33,    34,    11,
       7,    57,    13,     6,    11,     8,    17,     5,     6,    11,
       8,    13,    11,    13,    13,    15,     0,    18,    19,     4,
       8,     8,    12,    12,     7,    11,    49,    32,    -1,    11,
      11,     9,    11,    -1,    11
};

/* yy_hlwSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yy_hlwtype_uint8 yy_hlwstos[] =
{
       0,     3,    21,    22,    23,     7,    11,     0,     5,     6,
       8,    25,    26,    27,    28,     4,    24,     7,    11,     8,
       8,    12,    26,    27,    28,     7,     7,    11,    11,    12,
       7,     8,    10,    14,    16,    29,    30,    31,    32,    33,
      34,    35,    11,    11,    29,    35,    29,    29,    11,    13,
      31,     9,    18,    19,    11,    15,    17,    30
};

#define yy_hlwerrok		(yy_hlwerrstatus = 0)
#define yy_hlwclearin	(yy_hlwchar = yy_hlwEMPTY)
#define yy_hlwEMPTY		(-2)
#define yy_hlwEOF		0

#define yy_hlwACCEPT	goto yy_hlwacceptlab
#define yy_hlwABORT		goto yy_hlwabortlab
#define yy_hlwERROR		goto yy_hlwerrorlab


/* Like yy_hlwERROR except do call yy_hlwerror.  This remains here temporarily
   to ease the transition to the new meaning of yy_hlwERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define yy_hlwFAIL		goto yy_hlwerrlab

#define yy_hlwRECOVERING()  (!!yy_hlwerrstatus)

#define yy_hlwBACKUP(Token, Value)					\
do								\
  if (yy_hlwchar == yy_hlwEMPTY && yy_hlwlen == 1)				\
    {								\
      yy_hlwchar = (Token);						\
      yy_hlwlval = (Value);						\
      yy_hlwtoken = yy_hlwTRANSLATE (yy_hlwchar);				\
      yy_hlwPOPSTACK (1);						\
      goto yy_hlwbackup;						\
    }								\
  else								\
    {								\
      yy_hlwerror (yy_hlwscanner, jsgf, yy_hlw_("syntax error: cannot back up")); \
      yy_hlwERROR;							\
    }								\
while (yy_hlwID (0))


#define yy_hlwTERROR	1
#define yy_hlwERRCODE	256


/* yy_hlwLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define yy_hlwRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef yy_hlwLLOC_DEFAULT
# define yy_hlwLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (yy_hlwID (N))                                                    \
	{								\
	  (Current).first_line   = yy_hlwRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = yy_hlwRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = yy_hlwRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = yy_hlwRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    yy_hlwRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    yy_hlwRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (yy_hlwID (0))
#endif


/* yy_hlw_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef yy_hlw_LOCATION_PRINT
# if yy_hlwLTYPE_IS_TRIVIAL
#  define yy_hlw_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define yy_hlw_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* yy_hlwLEX -- calling `yy_hlwlex' with the right arguments.  */

#ifdef yy_hlwLEX_PARAM
# define yy_hlwLEX yy_hlwlex (&yy_hlwlval, yy_hlwLEX_PARAM)
#else
# define yy_hlwLEX yy_hlwlex (&yy_hlwlval, yy_hlwscanner)
#endif

/* Enable debugging if requested.  */
#if yy_hlwDEBUG

# ifndef yy_hlwFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define yy_hlwFPRINTF fprintf
# endif

# define yy_hlwDPRINTF(Args)			\
do {						\
  if (yy_hlwdebug)					\
    yy_hlwFPRINTF Args;				\
} while (yy_hlwID (0))

# define yy_hlw_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yy_hlwdebug)								  \
    {									  \
      yy_hlwFPRINTF (stderr, "%s ", Title);					  \
      yy_hlw_symbol_print (stderr,						  \
		  Type, Value, yy_hlwscanner, jsgf); \
      yy_hlwFPRINTF (stderr, "\n");						  \
    }									  \
} while (yy_hlwID (0))


/*--------------------------------.
| Print this symbol on yy_hlwOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_hlw_symbol_value_print (FILE *yy_hlwoutput, int yy_hlwtype, yy_hlwSTYPE const * const yy_hlwvaluep, yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf)
#else
static void
yy_hlw_symbol_value_print (yy_hlwoutput, yy_hlwtype, yy_hlwvaluep, yy_hlwscanner, jsgf)
    FILE *yy_hlwoutput;
    int yy_hlwtype;
    yy_hlwSTYPE const * const yy_hlwvaluep;
    yy_hlwscan_t yy_hlwscanner;
    jsgf_t *jsgf;
#endif
{
  if (!yy_hlwvaluep)
    return;
  yy_hlwUSE (yy_hlwscanner);
  yy_hlwUSE (jsgf);
# ifdef yy_hlwPRINT
  if (yy_hlwtype < yy_hlwNTOKENS)
    yy_hlwPRINT (yy_hlwoutput, yy_hlwtoknum[yy_hlwtype], *yy_hlwvaluep);
# else
  yy_hlwUSE (yy_hlwoutput);
# endif
  switch (yy_hlwtype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on yy_hlwOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_hlw_symbol_print (FILE *yy_hlwoutput, int yy_hlwtype, yy_hlwSTYPE const * const yy_hlwvaluep, yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf)
#else
static void
yy_hlw_symbol_print (yy_hlwoutput, yy_hlwtype, yy_hlwvaluep, yy_hlwscanner, jsgf)
    FILE *yy_hlwoutput;
    int yy_hlwtype;
    yy_hlwSTYPE const * const yy_hlwvaluep;
    yy_hlwscan_t yy_hlwscanner;
    jsgf_t *jsgf;
#endif
{
  if (yy_hlwtype < yy_hlwNTOKENS)
    yy_hlwFPRINTF (yy_hlwoutput, "token %s (", yy_hlwtname[yy_hlwtype]);
  else
    yy_hlwFPRINTF (yy_hlwoutput, "nterm %s (", yy_hlwtname[yy_hlwtype]);

  yy_hlw_symbol_value_print (yy_hlwoutput, yy_hlwtype, yy_hlwvaluep, yy_hlwscanner, jsgf);
  yy_hlwFPRINTF (yy_hlwoutput, ")");
}

/*------------------------------------------------------------------.
| yy_hlw_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_hlw_stack_print (yy_hlwtype_int16 *yy_hlwbottom, yy_hlwtype_int16 *yy_hlwtop)
#else
static void
yy_hlw_stack_print (yy_hlwbottom, yy_hlwtop)
    yy_hlwtype_int16 *yy_hlwbottom;
    yy_hlwtype_int16 *yy_hlwtop;
#endif
{
  yy_hlwFPRINTF (stderr, "Stack now");
  for (; yy_hlwbottom <= yy_hlwtop; yy_hlwbottom++)
    {
      int yy_hlwbot = *yy_hlwbottom;
      yy_hlwFPRINTF (stderr, " %d", yy_hlwbot);
    }
  yy_hlwFPRINTF (stderr, "\n");
}

# define yy_hlw_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yy_hlwdebug)							\
    yy_hlw_stack_print ((Bottom), (Top));				\
} while (yy_hlwID (0))


/*------------------------------------------------.
| Report that the yy_hlwRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_hlw_reduce_print (yy_hlwSTYPE *yy_hlwvsp, int yy_hlwrule, yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf)
#else
static void
yy_hlw_reduce_print (yy_hlwvsp, yy_hlwrule, yy_hlwscanner, jsgf)
    yy_hlwSTYPE *yy_hlwvsp;
    int yy_hlwrule;
    yy_hlwscan_t yy_hlwscanner;
    jsgf_t *jsgf;
#endif
{
  int yy_hlwnrhs = yy_hlwr2[yy_hlwrule];
  int yy_hlwi;
  unsigned long int yy_hlwlno = yy_hlwrline[yy_hlwrule];
  yy_hlwFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yy_hlwrule - 1, yy_hlwlno);
  /* The symbols being reduced.  */
  for (yy_hlwi = 0; yy_hlwi < yy_hlwnrhs; yy_hlwi++)
    {
      yy_hlwFPRINTF (stderr, "   $%d = ", yy_hlwi + 1);
      yy_hlw_symbol_print (stderr, yy_hlwrhs[yy_hlwprhs[yy_hlwrule] + yy_hlwi],
		       &(yy_hlwvsp[(yy_hlwi + 1) - (yy_hlwnrhs)])
		       		       , yy_hlwscanner, jsgf);
      yy_hlwFPRINTF (stderr, "\n");
    }
}

# define yy_hlw_REDUCE_PRINT(Rule)		\
do {					\
  if (yy_hlwdebug)				\
    yy_hlw_reduce_print (yy_hlwvsp, Rule, yy_hlwscanner, jsgf); \
} while (yy_hlwID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yy_hlwdebug;
#else /* !yy_hlwDEBUG */
# define yy_hlwDPRINTF(Args)
# define yy_hlw_SYMBOL_PRINT(Title, Type, Value, Location)
# define yy_hlw_STACK_PRINT(Bottom, Top)
# define yy_hlw_REDUCE_PRINT(Rule)
#endif /* !yy_hlwDEBUG */


/* yy_hlwINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	yy_hlwINITDEPTH
# define yy_hlwINITDEPTH 200
#endif

/* yy_hlwMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   yy_hlwSTACK_ALLOC_MAXIMUM < yy_hlwSTACK_BYTES (yy_hlwMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef yy_hlwMAXDEPTH
# define yy_hlwMAXDEPTH 10000
#endif



#if yy_hlwERROR_VERBOSE

# ifndef yy_hlwstrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yy_hlwstrlen strlen
#  else
/* Return the length of yy_hlwSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static yy_hlwSIZE_T
yy_hlwstrlen (const char *yy_hlwstr)
#else
static yy_hlwSIZE_T
yy_hlwstrlen (yy_hlwstr)
    const char *yy_hlwstr;
#endif
{
  yy_hlwSIZE_T yy_hlwlen;
  for (yy_hlwlen = 0; yy_hlwstr[yy_hlwlen]; yy_hlwlen++)
    continue;
  return yy_hlwlen;
}
#  endif
# endif

# ifndef yy_hlwstpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yy_hlwstpcpy stpcpy
#  else
/* Copy yy_hlwSRC to yy_hlwDEST, returning the address of the terminating '\0' in
   yy_hlwDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yy_hlwstpcpy (char *yy_hlwdest, const char *yy_hlwsrc)
#else
static char *
yy_hlwstpcpy (yy_hlwdest, yy_hlwsrc)
    char *yy_hlwdest;
    const char *yy_hlwsrc;
#endif
{
  char *yy_hlwd = yy_hlwdest;
  const char *yy_hlws = yy_hlwsrc;

  while ((*yy_hlwd++ = *yy_hlws++) != '\0')
    continue;

  return yy_hlwd - 1;
}
#  endif
# endif

# ifndef yy_hlwtnamerr
/* Copy to yy_hlwRES the contents of yy_hlwSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yy_hlwerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  yy_hlwSTR is taken from yy_hlwtname.  If yy_hlwRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static yy_hlwSIZE_T
yy_hlwtnamerr (char *yy_hlwres, const char *yy_hlwstr)
{
  if (*yy_hlwstr == '"')
    {
      yy_hlwSIZE_T yy_hlwn = 0;
      char const *yy_hlwp = yy_hlwstr;

      for (;;)
	switch (*++yy_hlwp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yy_hlwp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yy_hlwres)
	      yy_hlwres[yy_hlwn] = *yy_hlwp;
	    yy_hlwn++;
	    break;

	  case '"':
	    if (yy_hlwres)
	      yy_hlwres[yy_hlwn] = '\0';
	    return yy_hlwn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yy_hlwres)
    return yy_hlwstrlen (yy_hlwstr);

  return yy_hlwstpcpy (yy_hlwres, yy_hlwstr) - yy_hlwres;
}
# endif

/* Copy into yy_hlwRESULT an error message about the unexpected token
   yy_hlwCHAR while in state yy_hlwSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If yy_hlwRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return yy_hlwSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static yy_hlwSIZE_T
yy_hlwsyntax_error (char *yy_hlwresult, int yy_hlwstate, int yy_hlwchar)
{
  int yy_hlwn = yy_hlwpact[yy_hlwstate];

  if (! (yy_hlwPACT_NINF < yy_hlwn && yy_hlwn <= yy_hlwLAST))
    return 0;
  else
    {
      int yy_hlwtype = yy_hlwTRANSLATE (yy_hlwchar);
      yy_hlwSIZE_T yy_hlwsize0 = yy_hlwtnamerr (0, yy_hlwtname[yy_hlwtype]);
      yy_hlwSIZE_T yy_hlwsize = yy_hlwsize0;
      yy_hlwSIZE_T yy_hlwsize1;
      int yy_hlwsize_overflow = 0;
      enum { yy_hlwERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yy_hlwarg[yy_hlwERROR_VERBOSE_ARGS_MAXIMUM];
      int yy_hlwx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      yy_hlw_("syntax error, unexpected %s");
      yy_hlw_("syntax error, unexpected %s, expecting %s");
      yy_hlw_("syntax error, unexpected %s, expecting %s or %s");
      yy_hlw_("syntax error, unexpected %s, expecting %s or %s or %s");
      yy_hlw_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yy_hlwfmt;
      char const *yy_hlwf;
      static char const yy_hlwunexpected[] = "syntax error, unexpected %s";
      static char const yy_hlwexpecting[] = ", expecting %s";
      static char const yy_hlwor[] = " or %s";
      char yy_hlwformat[sizeof yy_hlwunexpected
		    + sizeof yy_hlwexpecting - 1
		    + ((yy_hlwERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yy_hlwor - 1))];
      char const *yy_hlwprefix = yy_hlwexpecting;

      /* Start yy_hlwX at -yy_hlwN if negative to avoid negative indexes in
	 yy_hlwCHECK.  */
      int yy_hlwxbegin = yy_hlwn < 0 ? -yy_hlwn : 0;

      /* Stay within bounds of both yy_hlwcheck and yy_hlwtname.  */
      int yy_hlwchecklim = yy_hlwLAST - yy_hlwn + 1;
      int yy_hlwxend = yy_hlwchecklim < yy_hlwNTOKENS ? yy_hlwchecklim : yy_hlwNTOKENS;
      int yy_hlwcount = 1;

      yy_hlwarg[0] = yy_hlwtname[yy_hlwtype];
      yy_hlwfmt = yy_hlwstpcpy (yy_hlwformat, yy_hlwunexpected);

      for (yy_hlwx = yy_hlwxbegin; yy_hlwx < yy_hlwxend; ++yy_hlwx)
	if (yy_hlwcheck[yy_hlwx + yy_hlwn] == yy_hlwx && yy_hlwx != yy_hlwTERROR)
	  {
	    if (yy_hlwcount == yy_hlwERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yy_hlwcount = 1;
		yy_hlwsize = yy_hlwsize0;
		yy_hlwformat[sizeof yy_hlwunexpected - 1] = '\0';
		break;
	      }
	    yy_hlwarg[yy_hlwcount++] = yy_hlwtname[yy_hlwx];
	    yy_hlwsize1 = yy_hlwsize + yy_hlwtnamerr (0, yy_hlwtname[yy_hlwx]);
	    yy_hlwsize_overflow |= (yy_hlwsize1 < yy_hlwsize);
	    yy_hlwsize = yy_hlwsize1;
	    yy_hlwfmt = yy_hlwstpcpy (yy_hlwfmt, yy_hlwprefix);
	    yy_hlwprefix = yy_hlwor;
	  }

      yy_hlwf = yy_hlw_(yy_hlwformat);
      yy_hlwsize1 = yy_hlwsize + yy_hlwstrlen (yy_hlwf);
      yy_hlwsize_overflow |= (yy_hlwsize1 < yy_hlwsize);
      yy_hlwsize = yy_hlwsize1;

      if (yy_hlwsize_overflow)
	return yy_hlwSIZE_MAXIMUM;

      if (yy_hlwresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yy_hlwp = yy_hlwresult;
	  int yy_hlwi = 0;
	  while ((*yy_hlwp = *yy_hlwf) != '\0')
	    {
	      if (*yy_hlwp == '%' && yy_hlwf[1] == 's' && yy_hlwi < yy_hlwcount)
		{
		  yy_hlwp += yy_hlwtnamerr (yy_hlwp, yy_hlwarg[yy_hlwi++]);
		  yy_hlwf += 2;
		}
	      else
		{
		  yy_hlwp++;
		  yy_hlwf++;
		}
	    }
	}
      return yy_hlwsize;
    }
}
#endif /* yy_hlwERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_hlwdestruct (const char *yy_hlwmsg, int yy_hlwtype, yy_hlwSTYPE *yy_hlwvaluep, yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf)
#else
static void
yy_hlwdestruct (yy_hlwmsg, yy_hlwtype, yy_hlwvaluep, yy_hlwscanner, jsgf)
    const char *yy_hlwmsg;
    int yy_hlwtype;
    yy_hlwSTYPE *yy_hlwvaluep;
    yy_hlwscan_t yy_hlwscanner;
    jsgf_t *jsgf;
#endif
{
  yy_hlwUSE (yy_hlwvaluep);
  yy_hlwUSE (yy_hlwscanner);
  yy_hlwUSE (jsgf);

  if (!yy_hlwmsg)
    yy_hlwmsg = "Deleting";
  yy_hlw_SYMBOL_PRINT (yy_hlwmsg, yy_hlwtype, yy_hlwvaluep, yy_hlwlocationp);

  switch (yy_hlwtype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef yy_hlwPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yy_hlwparse (void *yy_hlwPARSE_PARAM);
#else
int yy_hlwparse ();
#endif
#else /* ! yy_hlwPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yy_hlwparse (yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf);
#else
int yy_hlwparse ();
#endif
#endif /* ! yy_hlwPARSE_PARAM */





/*-------------------------.
| yy_hlwparse or yy_hlwpush_parse.  |
`-------------------------*/

#ifdef yy_hlwPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yy_hlwparse (void *yy_hlwPARSE_PARAM)
#else
int
yy_hlwparse (yy_hlwPARSE_PARAM)
    void *yy_hlwPARSE_PARAM;
#endif
#else /* ! yy_hlwPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yy_hlwparse (yy_hlwscan_t yy_hlwscanner, jsgf_t *jsgf)
#else
int
yy_hlwparse (yy_hlwscanner, jsgf)
    yy_hlwscan_t yy_hlwscanner;
    jsgf_t *jsgf;
#endif
#endif
{
/* The lookahead symbol.  */
int yy_hlwchar;

/* The semantic value of the lookahead symbol.  */
yy_hlwSTYPE yy_hlwlval;

    /* Number of syntax errors so far.  */
    int yy_hlwnerrs;

    int yy_hlwstate;
    /* Number of tokens to shift before error messages enabled.  */
    int yy_hlwerrstatus;

    /* The stacks and their tools:
       `yy_hlwss': related to states.
       `yy_hlwvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yy_hlwoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_hlwtype_int16 yy_hlwssa[yy_hlwINITDEPTH];
    yy_hlwtype_int16 *yy_hlwss;
    yy_hlwtype_int16 *yy_hlwssp;

    /* The semantic value stack.  */
    yy_hlwSTYPE yy_hlwvsa[yy_hlwINITDEPTH];
    yy_hlwSTYPE *yy_hlwvs;
    yy_hlwSTYPE *yy_hlwvsp;

    yy_hlwSIZE_T yy_hlwstacksize;

  int yy_hlwn;
  int yy_hlwresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yy_hlwtoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  yy_hlwSTYPE yy_hlwval;

#if yy_hlwERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yy_hlwmsgbuf[128];
  char *yy_hlwmsg = yy_hlwmsgbuf;
  yy_hlwSIZE_T yy_hlwmsg_alloc = sizeof yy_hlwmsgbuf;
#endif

#define yy_hlwPOPSTACK(N)   (yy_hlwvsp -= (N), yy_hlwssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yy_hlwlen = 0;

  yy_hlwtoken = 0;
  yy_hlwss = yy_hlwssa;
  yy_hlwvs = yy_hlwvsa;
  yy_hlwstacksize = yy_hlwINITDEPTH;

  yy_hlwDPRINTF ((stderr, "Starting parse\n"));

  yy_hlwstate = 0;
  yy_hlwerrstatus = 0;
  yy_hlwnerrs = 0;
  yy_hlwchar = yy_hlwEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yy_hlwssp = yy_hlwss;
  yy_hlwvsp = yy_hlwvs;

  goto yy_hlwsetstate;

/*------------------------------------------------------------.
| yy_hlwnewstate -- Push a new state, which is found in yy_hlwstate.  |
`------------------------------------------------------------*/
 yy_hlwnewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yy_hlwssp++;

 yy_hlwsetstate:
  *yy_hlwssp = yy_hlwstate;

  if (yy_hlwss + yy_hlwstacksize - 1 <= yy_hlwssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      yy_hlwSIZE_T yy_hlwsize = yy_hlwssp - yy_hlwss + 1;

#ifdef yy_hlwoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	yy_hlwSTYPE *yy_hlwvs1 = yy_hlwvs;
	yy_hlwtype_int16 *yy_hlwss1 = yy_hlwss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yy_hlwoverflow is a macro.  */
	yy_hlwoverflow (yy_hlw_("memory exhausted"),
		    &yy_hlwss1, yy_hlwsize * sizeof (*yy_hlwssp),
		    &yy_hlwvs1, yy_hlwsize * sizeof (*yy_hlwvsp),
		    &yy_hlwstacksize);

	yy_hlwss = yy_hlwss1;
	yy_hlwvs = yy_hlwvs1;
      }
#else /* no yy_hlwoverflow */
# ifndef yy_hlwSTACK_RELOCATE
      goto yy_hlwexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (yy_hlwMAXDEPTH <= yy_hlwstacksize)
	goto yy_hlwexhaustedlab;
      yy_hlwstacksize *= 2;
      if (yy_hlwMAXDEPTH < yy_hlwstacksize)
	yy_hlwstacksize = yy_hlwMAXDEPTH;

      {
	yy_hlwtype_int16 *yy_hlwss1 = yy_hlwss;
	union yy_hlwalloc *yy_hlwptr =
	  (union yy_hlwalloc *) yy_hlwSTACK_ALLOC (yy_hlwSTACK_BYTES (yy_hlwstacksize));
	if (! yy_hlwptr)
	  goto yy_hlwexhaustedlab;
	yy_hlwSTACK_RELOCATE (yy_hlwss_alloc, yy_hlwss);
	yy_hlwSTACK_RELOCATE (yy_hlwvs_alloc, yy_hlwvs);
#  undef yy_hlwSTACK_RELOCATE
	if (yy_hlwss1 != yy_hlwssa)
	  yy_hlwSTACK_FREE (yy_hlwss1);
      }
# endif
#endif /* no yy_hlwoverflow */

      yy_hlwssp = yy_hlwss + yy_hlwsize - 1;
      yy_hlwvsp = yy_hlwvs + yy_hlwsize - 1;

      yy_hlwDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yy_hlwstacksize));

      if (yy_hlwss + yy_hlwstacksize - 1 <= yy_hlwssp)
	yy_hlwABORT;
    }

  yy_hlwDPRINTF ((stderr, "Entering state %d\n", yy_hlwstate));

  if (yy_hlwstate == yy_hlwFINAL)
    yy_hlwACCEPT;

  goto yy_hlwbackup;

/*-----------.
| yy_hlwbackup.  |
`-----------*/
yy_hlwbackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yy_hlwn = yy_hlwpact[yy_hlwstate];
  if (yy_hlwn == yy_hlwPACT_NINF)
    goto yy_hlwdefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yy_hlwCHAR is either yy_hlwEMPTY or yy_hlwEOF or a valid lookahead symbol.  */
  if (yy_hlwchar == yy_hlwEMPTY)
    {
      yy_hlwDPRINTF ((stderr, "Reading a token: "));
      yy_hlwchar = yy_hlwLEX;
    }

  if (yy_hlwchar <= yy_hlwEOF)
    {
      yy_hlwchar = yy_hlwtoken = yy_hlwEOF;
      yy_hlwDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yy_hlwtoken = yy_hlwTRANSLATE (yy_hlwchar);
      yy_hlw_SYMBOL_PRINT ("Next token is", yy_hlwtoken, &yy_hlwlval, &yy_hlwlloc);
    }

  /* If the proper action on seeing token yy_hlwTOKEN is to reduce or to
     detect an error, take that action.  */
  yy_hlwn += yy_hlwtoken;
  if (yy_hlwn < 0 || yy_hlwLAST < yy_hlwn || yy_hlwcheck[yy_hlwn] != yy_hlwtoken)
    goto yy_hlwdefault;
  yy_hlwn = yy_hlwtable[yy_hlwn];
  if (yy_hlwn <= 0)
    {
      if (yy_hlwn == 0 || yy_hlwn == yy_hlwTABLE_NINF)
	goto yy_hlwerrlab;
      yy_hlwn = -yy_hlwn;
      goto yy_hlwreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yy_hlwerrstatus)
    yy_hlwerrstatus--;

  /* Shift the lookahead token.  */
  yy_hlw_SYMBOL_PRINT ("Shifting", yy_hlwtoken, &yy_hlwlval, &yy_hlwlloc);

  /* Discard the shifted token.  */
  yy_hlwchar = yy_hlwEMPTY;

  yy_hlwstate = yy_hlwn;
  *++yy_hlwvsp = yy_hlwlval;

  goto yy_hlwnewstate;


/*-----------------------------------------------------------.
| yy_hlwdefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yy_hlwdefault:
  yy_hlwn = yy_hlwdefact[yy_hlwstate];
  if (yy_hlwn == 0)
    goto yy_hlwerrlab;
  goto yy_hlwreduce;


/*-----------------------------.
| yy_hlwreduce -- Do a reduction.  |
`-----------------------------*/
yy_hlwreduce:
  /* yy_hlwn is the number of a rule to reduce with.  */
  yy_hlwlen = yy_hlwr2[yy_hlwn];

  /* If yy_hlwLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets yy_hlwVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to yy_hlwVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that yy_hlwVAL may be used uninitialized.  */
  yy_hlwval = yy_hlwvsp[1-yy_hlwlen];


  yy_hlw_REDUCE_PRINT (yy_hlwn);
  switch (yy_hlwn)
    {
        case 5:

/* Line 1455 of yacc.c  */
#line 80 "jsgf_parser.y"
    { jsgf->name = (yy_hlwvsp[(2) - (2)].name); }
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 84 "jsgf_parser.y"
    { jsgf->version = (yy_hlwvsp[(2) - (3)].name); }
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 85 "jsgf_parser.y"
    { jsgf->version = (yy_hlwvsp[(2) - (4)].name); jsgf->charset = (yy_hlwvsp[(3) - (4)].name); }
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 86 "jsgf_parser.y"
    { jsgf->version = (yy_hlwvsp[(2) - (5)].name); jsgf->charset = (yy_hlwvsp[(3) - (5)].name);
					 jsgf->locale = (yy_hlwvsp[(4) - (5)].name); }
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 90 "jsgf_parser.y"
    { (yy_hlwval.name) = (yy_hlwvsp[(2) - (3)].name); }
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 97 "jsgf_parser.y"
    { jsgf_import_rule(jsgf, (yy_hlwvsp[(2) - (3)].name)); ckd_free((yy_hlwvsp[(2) - (3)].name)); }
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 104 "jsgf_parser.y"
    { jsgf_define_rule(jsgf, (yy_hlwvsp[(1) - (4)].name), (yy_hlwvsp[(3) - (4)].rhs), 0); ckd_free((yy_hlwvsp[(1) - (4)].name)); }
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 105 "jsgf_parser.y"
    { jsgf_define_rule(jsgf, (yy_hlwvsp[(2) - (5)].name), (yy_hlwvsp[(4) - (5)].rhs), 1); ckd_free((yy_hlwvsp[(2) - (5)].name)); }
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 108 "jsgf_parser.y"
    { (yy_hlwval.rhs) = (yy_hlwvsp[(1) - (1)].rhs); (yy_hlwval.rhs)->atoms = glist_reverse((yy_hlwval.rhs)->atoms); }
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 109 "jsgf_parser.y"
    { (yy_hlwval.rhs) = (yy_hlwvsp[(3) - (3)].rhs);
                                              (yy_hlwval.rhs)->atoms = glist_reverse((yy_hlwval.rhs)->atoms);
                                              (yy_hlwval.rhs)->alt = (yy_hlwvsp[(1) - (3)].rhs); }
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 114 "jsgf_parser.y"
    { (yy_hlwval.rhs) = ckd_calloc(1, sizeof(*(yy_hlwval.rhs)));
				   (yy_hlwval.rhs)->atoms = glist_add_ptr((yy_hlwval.rhs)->atoms, (yy_hlwvsp[(1) - (1)].atom)); }
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 116 "jsgf_parser.y"
    { (yy_hlwval.rhs) = (yy_hlwvsp[(1) - (2)].rhs);
					    (yy_hlwval.rhs)->atoms = glist_add_ptr((yy_hlwval.rhs)->atoms, (yy_hlwvsp[(2) - (2)].atom)); }
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 121 "jsgf_parser.y"
    { (yy_hlwval.atom) = (yy_hlwvsp[(1) - (2)].atom);
				 (yy_hlwval.atom)->tags = glist_add_ptr((yy_hlwval.atom)->tags, (yy_hlwvsp[(2) - (2)].name)); }
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 126 "jsgf_parser.y"
    { (yy_hlwval.atom) = (yy_hlwvsp[(2) - (2)].atom); (yy_hlwval.atom)->weight = (yy_hlwvsp[(1) - (2)].weight); }
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 129 "jsgf_parser.y"
    { (yy_hlwval.rule) = jsgf_define_rule(jsgf, NULL, (yy_hlwvsp[(2) - (3)].rhs), 0); }
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 132 "jsgf_parser.y"
    { (yy_hlwval.rule) = jsgf_optional_new(jsgf, (yy_hlwvsp[(2) - (3)].rhs)); }
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 135 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_atom_new((yy_hlwvsp[(1) - (1)].name), 1.0); ckd_free((yy_hlwvsp[(1) - (1)].name)); }
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 136 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_atom_new((yy_hlwvsp[(1) - (1)].name), 1.0); ckd_free((yy_hlwvsp[(1) - (1)].name)); }
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 137 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_atom_new((yy_hlwvsp[(1) - (1)].rule)->name, 1.0); }
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 138 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_atom_new((yy_hlwvsp[(1) - (1)].rule)->name, 1.0); }
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 139 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_kleene_new(jsgf, (yy_hlwvsp[(1) - (2)].atom), 0); }
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 140 "jsgf_parser.y"
    { (yy_hlwval.atom) = jsgf_kleene_new(jsgf, (yy_hlwvsp[(1) - (2)].atom), 1); }
    break;



/* Line 1455 of yacc.c  */
#line 1573 "jsgf_parser.c"
      default: break;
    }
  yy_hlw_SYMBOL_PRINT ("-> $$ =", yy_hlwr1[yy_hlwn], &yy_hlwval, &yy_hlwloc);

  yy_hlwPOPSTACK (yy_hlwlen);
  yy_hlwlen = 0;
  yy_hlw_STACK_PRINT (yy_hlwss, yy_hlwssp);

  *++yy_hlwvsp = yy_hlwval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yy_hlwn = yy_hlwr1[yy_hlwn];

  yy_hlwstate = yy_hlwpgoto[yy_hlwn - yy_hlwNTOKENS] + *yy_hlwssp;
  if (0 <= yy_hlwstate && yy_hlwstate <= yy_hlwLAST && yy_hlwcheck[yy_hlwstate] == *yy_hlwssp)
    yy_hlwstate = yy_hlwtable[yy_hlwstate];
  else
    yy_hlwstate = yy_hlwdefgoto[yy_hlwn - yy_hlwNTOKENS];

  goto yy_hlwnewstate;


/*------------------------------------.
| yy_hlwerrlab -- here on detecting error |
`------------------------------------*/
yy_hlwerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yy_hlwerrstatus)
    {
      ++yy_hlwnerrs;
#if ! yy_hlwERROR_VERBOSE
      yy_hlwerror (yy_hlwscanner, jsgf, yy_hlw_("syntax error"));
#else
      {
	yy_hlwSIZE_T yy_hlwsize = yy_hlwsyntax_error (0, yy_hlwstate, yy_hlwchar);
	if (yy_hlwmsg_alloc < yy_hlwsize && yy_hlwmsg_alloc < yy_hlwSTACK_ALLOC_MAXIMUM)
	  {
	    yy_hlwSIZE_T yy_hlwalloc = 2 * yy_hlwsize;
	    if (! (yy_hlwsize <= yy_hlwalloc && yy_hlwalloc <= yy_hlwSTACK_ALLOC_MAXIMUM))
	      yy_hlwalloc = yy_hlwSTACK_ALLOC_MAXIMUM;
	    if (yy_hlwmsg != yy_hlwmsgbuf)
	      yy_hlwSTACK_FREE (yy_hlwmsg);
	    yy_hlwmsg = (char *) yy_hlwSTACK_ALLOC (yy_hlwalloc);
	    if (yy_hlwmsg)
	      yy_hlwmsg_alloc = yy_hlwalloc;
	    else
	      {
		yy_hlwmsg = yy_hlwmsgbuf;
		yy_hlwmsg_alloc = sizeof yy_hlwmsgbuf;
	      }
	  }

	if (0 < yy_hlwsize && yy_hlwsize <= yy_hlwmsg_alloc)
	  {
	    (void) yy_hlwsyntax_error (yy_hlwmsg, yy_hlwstate, yy_hlwchar);
	    yy_hlwerror (yy_hlwscanner, jsgf, yy_hlwmsg);
	  }
	else
	  {
	    yy_hlwerror (yy_hlwscanner, jsgf, yy_hlw_("syntax error"));
	    if (yy_hlwsize != 0)
	      goto yy_hlwexhaustedlab;
	  }
      }
#endif
    }



  if (yy_hlwerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yy_hlwchar <= yy_hlwEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yy_hlwchar == yy_hlwEOF)
	    yy_hlwABORT;
	}
      else
	{
	  yy_hlwdestruct ("Error: discarding",
		      yy_hlwtoken, &yy_hlwlval, yy_hlwscanner, jsgf);
	  yy_hlwchar = yy_hlwEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yy_hlwerrlab1;


/*---------------------------------------------------.
| yy_hlwerrorlab -- error raised explicitly by yy_hlwERROR.  |
`---------------------------------------------------*/
yy_hlwerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     yy_hlwERROR and the label yy_hlwerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yy_hlwerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this yy_hlwERROR.  */
  yy_hlwPOPSTACK (yy_hlwlen);
  yy_hlwlen = 0;
  yy_hlw_STACK_PRINT (yy_hlwss, yy_hlwssp);
  yy_hlwstate = *yy_hlwssp;
  goto yy_hlwerrlab1;


/*-------------------------------------------------------------.
| yy_hlwerrlab1 -- common code for both syntax error and yy_hlwERROR.  |
`-------------------------------------------------------------*/
yy_hlwerrlab1:
  yy_hlwerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yy_hlwn = yy_hlwpact[yy_hlwstate];
      if (yy_hlwn != yy_hlwPACT_NINF)
	{
	  yy_hlwn += yy_hlwTERROR;
	  if (0 <= yy_hlwn && yy_hlwn <= yy_hlwLAST && yy_hlwcheck[yy_hlwn] == yy_hlwTERROR)
	    {
	      yy_hlwn = yy_hlwtable[yy_hlwn];
	      if (0 < yy_hlwn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yy_hlwssp == yy_hlwss)
	yy_hlwABORT;


      yy_hlwdestruct ("Error: popping",
		  yy_hlwstos[yy_hlwstate], yy_hlwvsp, yy_hlwscanner, jsgf);
      yy_hlwPOPSTACK (1);
      yy_hlwstate = *yy_hlwssp;
      yy_hlw_STACK_PRINT (yy_hlwss, yy_hlwssp);
    }

  *++yy_hlwvsp = yy_hlwlval;


  /* Shift the error token.  */
  yy_hlw_SYMBOL_PRINT ("Shifting", yy_hlwstos[yy_hlwn], yy_hlwvsp, yy_hlwlsp);

  yy_hlwstate = yy_hlwn;
  goto yy_hlwnewstate;


/*-------------------------------------.
| yy_hlwacceptlab -- yy_hlwACCEPT comes here.  |
`-------------------------------------*/
yy_hlwacceptlab:
  yy_hlwresult = 0;
  goto yy_hlwreturn;

/*-----------------------------------.
| yy_hlwabortlab -- yy_hlwABORT comes here.  |
`-----------------------------------*/
yy_hlwabortlab:
  yy_hlwresult = 1;
  goto yy_hlwreturn;

#if !defined(yy_hlwoverflow) || yy_hlwERROR_VERBOSE
/*-------------------------------------------------.
| yy_hlwexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yy_hlwexhaustedlab:
  yy_hlwerror (yy_hlwscanner, jsgf, yy_hlw_("memory exhausted"));
  yy_hlwresult = 2;
  /* Fall through.  */
#endif

yy_hlwreturn:
  if (yy_hlwchar != yy_hlwEMPTY)
     yy_hlwdestruct ("Cleanup: discarding lookahead",
		 yy_hlwtoken, &yy_hlwlval, yy_hlwscanner, jsgf);
  /* Do not reclaim the symbols of the rule which action triggered
     this yy_hlwABORT or yy_hlwACCEPT.  */
  yy_hlwPOPSTACK (yy_hlwlen);
  yy_hlw_STACK_PRINT (yy_hlwss, yy_hlwssp);
  while (yy_hlwssp != yy_hlwss)
    {
      yy_hlwdestruct ("Cleanup: popping",
		  yy_hlwstos[*yy_hlwssp], yy_hlwvsp, yy_hlwscanner, jsgf);
      yy_hlwPOPSTACK (1);
    }
#ifndef yy_hlwoverflow
  if (yy_hlwss != yy_hlwssa)
    yy_hlwSTACK_FREE (yy_hlwss);
#endif
#if yy_hlwERROR_VERBOSE
  if (yy_hlwmsg != yy_hlwmsgbuf)
    yy_hlwSTACK_FREE (yy_hlwmsg);
#endif
  /* Make sure yy_hlwID is used.  */
  return yy_hlwID (yy_hlwresult);
}



/* Line 1675 of yacc.c  */
#line 143 "jsgf_parser.y"


void
yy_hlwerror(yy_hlwscan_t lex, jsgf_t *jsgf, const char *s)
{
    fprintf(stderr, "ERROR: %s\n", s);
}

