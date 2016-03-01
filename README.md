# CS 81 Compiler Project
The goal of this project is to build a programming language entirely from scratch (e.g. building the parsing libraries, the type checker, etc.) that has a strong type system and eventually compiles down to LLVM IR.

## [--->Progress Update<---](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/logs/progress_update1.md)

## Parsing
The language [*syntax*](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/Syntax.md) will be largely inspired by Haskell and Swift. The current plan is to whitespace delimit function application (as Haskell does). Eventually, things like infix operators ought to be supported, but this is low priority as it is not a major area of exploration for the project.

[**Spork**](https://github.com/JadenGeller/Spork) provides the ability to efficiently duplicate arbitrary generators while maintining independent state. This is useful for backtracking, since it allows the previous state to be saved and later restored if this search path doesn't work out.

[**Parsley**](https://github.com/JadenGeller/Parsley), a recursive descent parsing library, will be used for the parsing stage of the compilation process. Parsley is built on top of Spork to provide backtracking capabilities. Parsley is built with ease-of-use in mind rather than parsing speed (as compilation speed is not a focus of the project). Parsley defines many primitive parsers and parser combinators that can be combined to form complex parserlits. It will be used for both the lexing and the parsing stages.

Parsing will be divided into two phases: a lexing phase in which the input will be tokenized, [*literal values*](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/Literals.md) will be parsed, and whitespace will be discared, and a parsing phase in which the stream of tokens will be transformed into the [*abstract syntax tree*](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/AST.md) of the program.

## Type Checking
A major focus of this project will be implementing features found in strong type systems as well as exploring novel systems. As such, a large amount of time has been devoted to this stage of compilation. I've written three frameworks thus far, each building on top of the previous, that provide abstractions that enable the implementation of complex type systems.

[**Gluey**](https://github.com/JadenGeller/Gluey) is a library built to make unification easy. It defines types that can be unified together (even if they have no value yet), throwing an error if unification fails. Further, it defines types that enable the construction of recursive unification types. Gluey also provides constructs for performing deep copies or backtracking on failed unification.

[**Axiomatic**](https://github.com/JadenGeller/Axiomatic) builds onto of Gluey to form a logic layer on top of the unification framework. Essentially, it implements the tree-like term structures that are needed to represent complex relations and provides a backtracking logic framework for querying a given system. It was largely inspired by Prolog, and implements what's required to build complex [logical formulas](https://en.wikipedia.org/wiki/Horn_clause). 

[**Typist**](https://github.com/JadenGeller/Typist) is an abstraction built atop Axiomatic that allows for the annotation of types directly in the abstract syntax tree. The abstract syntax tree must only be partially annotated with types, and Typist will generate the logical clauses necessary to determine the rest of the types. This stage is necessary not only for type checking, but for determining the types of each subexpression for purposes of name mangling.

The first implementation of the language will not include protocols/interfaces/typeclasses, but will include some advanced features such generics. The initial focus will be to implement the bare bones necessary features for a type system, but while making design choices that make it easily extensible in the future.

## Executing
Though the eventual goal of this language is to compile down to LLVM IR, the immediate goal is to be interpreted since this will be easier to implement. Once more about the language is determined (after experimenting with the typesystem and such), then the focus will shift to generating the IR bitcode. For now though, the language will be interpreted.

[**Expressive**](https://github.com/JadenGeller/Expressive) is the lambda-supporting interpreter that will be used for the language. It was written with simplicity, not speed, in mind. Currently, it models an imperative language only with record types, but it also supports features like lambdas and recursion.

[**Assemble**](https://github.com/JadenGeller/Assemble) is an IR generation library that makes it easy to generate syntactically valid, properly indented IR from some sort of abstract syntax tree intermediate representation. Right now, Assemble generates the IR from scratch, but it might be worthwhile to look into using the LLVM C library in the future, providing Assemble as an abstraction over this.

Ideally, there'll eventually exist some intermediate representation that both Assemble and Expressive can utilize depending on if the language ought to be interpreted or compiled.
