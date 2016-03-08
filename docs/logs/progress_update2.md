# Progress Update

## Line-Column Indexing

I created a type [`Document`](https://github.com/jadengeller/document) that provides indexing based on line and column such that the lexer and provide more useful indexing information without specializing the lexer specifically for `String` and without performing an expensive linear index to line-column index lookup for every token after the lexing process.
