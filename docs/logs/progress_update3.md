# Progress Update

## Lexing

### Improving Symbols

I've updated the `Matchable` protocol so that, when symbols are parsed, it always starts with the longest possible symbols before making its way toward the shorter ones. This ensures that we'll a symbol such as `->` even if we have registered a symbol `-`.

### Axing Enumerable

I also recently decided that the `Enumerable` protocol is not a good idea since it discourages dynamic behavior. For example, if you want to first lex the document to determine what symbols will be declared, you'll have to modify global state of the symbol type if you want to use such a protocol.

### Replacing Matchable

Matchable adds unnecessary complexity to the parser. Instead, I built a `raw` parser that can parse `RawRepresentable` things in a similiar way that `Matchable` did. You can accomplish the same behavior with `coalesce(arr.map(raw))`. It's much cleaner IMO. A notable grossness---I'm using `RawRepresentable` on things that sometimes don't make sense to be initialized from their raw value (aka, they need extra data for that). Because of this, I should later revist this and make a `TokenRepresentable` type or something. I didn't want to go down that rabit hole today though.
