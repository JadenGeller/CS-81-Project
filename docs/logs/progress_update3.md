# Progress Update

## [Last Week](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/logs/progress_update2.md)

We didn't meet last week, so I want to give you an overview of what I was up to. The tl;dr is that I thought about [line-column indexing](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/logs/progress_update2.md#line-column-indexing) and I determined that it didn't make sense for [infix parsing](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/logs/progress_update2.md#infix-parsing) to be so heavily protocol-based. I spent a while trying to do other things, but code debt in the parser really slowed me down. Important to note, the code debt wasn't due to careless coding but rather excessive refactoring. I spent too much time thinking about, rethinking about, and overthinking about how the parsing library should work, and once I started to use it I realized that there were certain design decisions that were not ideal (repeat x10).

This week, I decided to resist any refactoring, and just build write code on top of the current codebase I have. I've ran into quite a few of the same bad design decisions again, but I've mostly worked around them anywhere that it'd be an unnecessary time hole to fix. Basically, I've been working to get to the minimum viable product, and I'll take what I learned from that and clean up the rest during the first week of next term.

## Lexing

### Improving Symbols

I've updated the `Matchable` protocol so that, when symbols are parsed, it always starts with the longest possible symbols before making its way toward the shorter ones. This ensures that we'll a symbol such as `->` even if we have registered a symbol `-`.

### Axing Enumerable

I also recently decided that the `Enumerable` protocol is not a good idea since it discourages dynamic behavior. For example, if you want to first lex the document to determine what symbols will be declared, you'll have to modify global state of the symbol type if you want to use such a protocol.

### Replacing Matchable

Matchable adds unnecessary complexity to the parser. Instead, I built a `raw` parser that can parse `RawRepresentable` things in a similiar way that `Matchable` did. You can accomplish the same behavior with `coalesce(arr.map(raw))`. It's much cleaner IMO. A notable grossness---I'm using `RawRepresentable` on things that sometimes don't make sense to be initialized from their raw value (aka, they need extra data for that). Because of this, I should later revist this and make a `TokenRepresentable` type or something. I didn't want to go down that rabit hole today though.

After giving it more thought, I think `RawRepresentable` is the correct type for these things, they just shouldn't store the extra data on them. For example, *every* infix operator that we lex shouldn't store the associativity. We should just provide the associativity to the parser in a dictionary so we only need it once for each operator.

This implies there probably should be a seperate type for *this is an infix operator that exists and here are its properties* and for *this is an infix operator symbol* we found in the parsed text. The parser library could have some abstraction that takes the former type and build the dictionary based off that. To be honest, I'm not sure that there needs to be a distinction between the different types of symbols at the lexer level. I think that we should provide the lexer that information, but it lexes to symbol, literal, or bare only.

### Separate Stage

I keep going back and forth on whether lexing and parsing ought to be separate stages. It simplifies the logic in some ways and complicates it in others. I think making them separate stages makes sense so I don't have to worry about whitespace while parsing, so that's what I'm going to keep with for now.

## Parsing

### Function Application

It isn't straightforward to me how function application ought to be parsed. If I were to treat spaces between identifiers as infix operators, I could use the existing infix operator parsing which would be very convenient. There are two problems though. First, this makes the lexing stage much more complicated (and much less like lexing) since the lexer must know the context of the surrounding symbols to correctly lex the space. Second, there are some bare words that aren't actually identifiers. For example, keywords such as `let` and `var` ought to not treat the space in between as an infix operator (applying the undeclared identifier to the function "let").

Now, let's back up a moment. One solution to the first problem (lexing context) could be adding another separate phase between the lexing and the parsing phase such that these space operators could be labeled. One solution to the second problem would be to treat `let x` as the identifier `x` applied to the function `let`, and then later fix this in a later phase. Neither of these solutions seem great, but they're just ideas.

The final solution (probably the cleanest) is to simply throw out spaces and detect function application during the parsing stage. This makes infix operator parsing grosser, but this is probably the cleanest solution.

### Matching Specific Token

To match a specific case of a token, we have to use a switch statement to check the case. This is super unideal, so instead we define a `Tag` type that is the token without the assoicated types, so we can just check the tag.

### Infix Operator

When I wrote the infix operator parser, I was thinking of lexing and parsing as the same phase. Thus, the infix operator matches on `Character` rather than the actual type of the token. I fixed this by making the operator parser take a function from operator to matcher as argument. It's not super clean, but it works until I have a better overall idea of how everything should best work together.

### Equatable

A really annoying thing to deal with is making each and every type equatable in Swift. This is especially tedious for enums since you have to use a switch statement to unwrap each type and check if its components are equal. Equality checking on our lexed tokens is necessary to build our parser, so I had to spend a lot of time making everything conform to Equatable. 

# Other

## Swift Style

The [Swift style guide](https://swift.org/documentation/api-design-guidelines/) was updated to make some major changes. A big on is that enum case names are now lowercase. I've been following this convention for newly defined types, but I haven't gone back and updated existing types to follow this style.

## TIL

While holding office hours, I realized that the Ocaml module system works **very** similiarly to the Swift protocol system. Swift protocols have associated types, they allow you to specify what methods a type must implement, and they allow you to give default implementations of methods if desired. Swift protocols are more powerful in that they also allow new methods to be added (w/ default implementations) whenever a certain associated type conforms to some other protocol.

## Language Design

I'm kind of thinking I want tagless union types in my language... And yes, I remember that you did recommend against such a thing. My reasoning is that I'm finding very often in my Swift code that I wish the enum cases were types themselves. Instead of defining both `struct PairedDelimiter { ... }` and `enum Symbol { ... case pairedDelimiter(PairedDelimiter) ... }`, I could simply say that `Symbol = ... | PairedDelimiter | ...`. The big pitfall of this is defining some generic union type like `Optional T = T | None` since this would "flatten" an `Optional (Optional T)` into just an `Optional T`, losing the two different `None`s. One solution is to define it instead as `Optional (Box T) None` so that we don't have that problem. I have to give this a lot more thought, but I still don't hate the idea...