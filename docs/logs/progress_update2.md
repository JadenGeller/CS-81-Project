# Progress Update

## Line-Column Indexing

I created a type [`Document`](https://github.com/jadengeller/document) that provides indexing based on line and column such that the lexer and provide more useful indexing information without specializing the lexer specifically for `String` and without performing an expensive linear index to line-column index lookup for every token after the lexing process.

Unfortunately, the current version of Parsley cannot utilize this feature yet as its `GeneratorType` uses type-erasure to improve the function signatures of the parsers. This is very reasonable behavior, but it means that we cannot easily just drop in a generator of another type. A possible solution would be to restrict the generators to being `Indexable` such that the type-erased generator can always support index. I haven't decided if this is the right thing to do yet.
