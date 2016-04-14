
# Milestones

## Milestone 1 - Parsing

- [ ] Parser design
   - [ ] Infix operators
      - [x] Operator should not store global precedence/associativity
      - [x] Generalize prefix and postfix operators can eventually be supported
      - [ ] Make it possible to treat anything starting with a certain symbol as an operator
   - [x] Remove Matchable/Parsable/Enumerable protocols
   - [ ] Update testcases to work with modifications
   - [x] Replace dependency injection with parsing context
- [x] Pretty printer
   - [x] Lexing tokens
   - [x] Parsing tokens
- [x] Simplify model for language parsing
   - [x] Make it easier to build test cases
- [x] Fix unresolved parser issues
   - [x] Associativity problem
   - [x] Backwards order of operations
- [x] Allow infix operators to be used as symbols when surrounded by parenthesis
- [ ] Remove sign from literals and add unary operators
- [ ] Add test cases for programming language syntax
- [ ] Determine if infix operator parser gets continually rebuilt
   - [ ] If so, optimize it so that it is only computed once
- [ ] Write execution tests that can actually be checked for correctness
- [ ] Implement prefix/postfix operators
   - [ ] Keep track of spaces around symbols during the lexing stage
   - [ ] Use spaces around the symbols to parse properly
- [ ] Make sure every expression is new-line terminated, but mid-expression new lines are allowed
    - [ ] Add metadata for line/column so we can compute newline-followed
- [ ] Specify infix operators as parsers rather than as an array of symbols
- [x] Fix parsing order bug
- [ ] Include type holes in the parsed expression
    - [ ] Fill in things like A -> B -> C and A -> B for infix and postfix/prefix operators
- [ ] Should include spacer as a character in addition to new line
    - [ ] Use as an infix operator (maybe) between two parsers
    - [ ] Allow easy detection of infix, postfix, prefix (w/o delimiters in the way)
- [ ] Fix right associativity

## Milestone 2 - Typesystem

## Milestone 3 - Typesystem

## Milestone 4 - Language

## Milestone 5 - Language

## Milestone 6 - Advanced Typesystem

## Milestone 7 - Compiling to LLVM

## Milestone 8 - Compiling to LLVM

## Milestone 9 - Compiling to LLVM

## Milestone 10 - Compiling to LLVM
