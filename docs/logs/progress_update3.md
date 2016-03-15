# Progress Update

## Lexing

### Improving Symbols

I've updated the `Matchable` protocol so that, when symbols are parsed, it always starts with the longest possible symbols before making its way toward the shorter ones. This ensures that we'll a symbol such as `->` even if we have registered a symbol `-`.

### Axing Enumerable

I also recently decided that the `Enumerable` protocol is not a good idea since it discourages dynamic behavior. For example, if you want to first lex the document to determine what symbols will be declared, you'll have to modify global state of the symbol type if you want to use such a protocol.

### Replacing Matchable

Matchable adds unnecessary complexity to the parser. Instead, I built a `raw` parser that can parse `RawRepresentable` things in a similiar way that `Matchable` did. You can accomplish the same behavior with `coalesce(arr.map(raw))`. It's much cleaner IMO. A notable grossness---I'm using `RawRepresentable` on things that sometimes don't make sense to be initialized from their raw value (aka, they need extra data for that). Because of this, I should later revist this and make a `TokenRepresentable` type or something. I didn't want to go down that rabit hole today though.

After giving it more thought, I think `RawRepresentable` is the correct type for these things, they just shouldn't store the extra data on them. For example, *every* infix operator that we lex shouldn't store the associativity. We should just provide the associativity to the parser in a dictionary so we only need it once for each operator.

This implies there probably should be a seperate type for *this is an infix operator that exists and here are its properties* and for *this is an infix operator symbol* we found in the parsed text. The parser library could have some abstraction that takes the former type and build the dictionary based off that. To be honest, I'm not sure that there needs to be a distinction between the different types of symbols at the lexer level. I think that we should provide the lexer that information, but it lexes to symbol, literal, or bare only.

## Parsing

### Function Application

It isn't straightforward to me how function application ought to be parsed. If I were to treat spaces between identifiers as infix operators, I could use the existing infix operator parsing which would be very convenient. There are two problems though. First, this makes the lexing stage much more complicated (and much less like lexing) since the lexer must know the context of the surrounding symbols to correctly lex the space. Second, there are some bare words that aren't actually identifiers. For example, keywords such as `let` and `var` ought to not treat the space in between as an infix operator (applying the undeclared identifier to the function "let").

Now, let's back up a moment. One solution to the first problem (lexing context) could be adding another separate phase between the lexing and the parsing phase such that these space operators could be labeled. One solution to the second problem would be to treat `let x` as the identifier `x` applied to the function `let`, and then later fix this in a later phase. Neither of these solutions seem great, but they're just ideas.
