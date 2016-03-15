# Progress Update

## Lexing

### Symbols

I've updated the `Matchable` protocol so that, when symbols are parsed, it always starts with the longest possible symbols before making its way toward the shorter ones. This ensures that we'll a symbol such as `->` even if we have registered a symbol `-`.

### Enumerable

I also recently decided that the `Enumerable` protocol is not a good idea since it discourages dynamic behavior. For example, if you want to first lex the document to determine what symbols will be declared, you'll have to modify global state of the symbol type if you want to use such a protocol.
