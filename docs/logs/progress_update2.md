# Progress Update

I've spent the last 5 days working nonstop on the most recent CS 124 assingment, so I haven't made notable progress on CS 81 this week. I stayed up this last night working, but I'm having trouble making progress while tired, so I'd perfer to reschedule our meeting for later this week.

Here's what I've been working on and pondering:

## Line-Column Indexing

I created a type [`Document`](https://github.com/jadengeller/document) that provides indexing based on line and column such that the lexer and provide more useful indexing information without specializing the lexer specifically for `String` and without performing an expensive linear index to line-column index lookup for every token after the lexing process.

Unfortunately, the current version of Parsley cannot utilize this feature yet as its `GeneratorType` uses type-erasure to improve the function signatures of the parsers. This is very reasonable behavior, but it means that we cannot easily just drop in a generator of another type. A possible solution would be to restrict the generators to being `Indexable` such that the type-erased generator can always support index. I haven't decided if this is the right thing to do yet.

## Infix Parsing

Previously, infix parsing was based on a protocol `InfixParser` that allowed any types that conform to this protocol to be parsed as an infix operator. I decided that this was too restrictive since it prevent the runtime addition of new infix operators without making global changes to the type. Because of this, I redid the parser so that it accepts a parser rather than a type.

## Organization

I've been having a lot of trouble feeling overwhelmed with parsing particularly due to the immense size of the Parsley library along with the constant flux of its implementation. I really think I need to stabilize it before I feel confident maintaining a parser for the language.

## Lexing + Parsing Language Syntax

There's not a lot to talk about here, I just have to *do* it. [Last week](https://github.com/JadenGeller/CS-81-Project/blob/master/docs/logs/progress_update1.md#decisions) we talked about the CFG for the language, which ends up being pretty similiar to the recursive descent parser. The only hesitation in implementation here is that, as mentioned above, I feel a lot of uncertainty regarding both the AST semantics and the parsing semantics, and I've spent a lot of time convincing myself back-and-forth on different decisions. I think I need to document my intent with each of these and commit to a design decision.

## Timeline

I plan to get parsing completely finished by this weekend (or our next meeting, which ever is sooner). By our next meeting on Tuesday, the goal is still to parse, typecheck, and run a factorial function. With the business of finals week, it'll definitely be a challenge to get this done, but I won't be satisfied with my progress this term if I do not, so I'm definitely going to prioritize this amid my hectic schedule.

Let me know if you have any questions!
