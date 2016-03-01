# Progress

## Parsing

### Infix Operators

I improved the parsing library to easily support infix operators. At first, I just built a hard-coded example that supports 4 levels of precedence. Then, I abstracted this to work with arbitary levels of precedence, and I think the result turned out really nice!

```swift
public func infix<InfixOperator: InfixOperatorType, Result, Discard>(operatorType: InfixOperator.Type, between parser: Parser<InfixOperator.TokenInput, Result>, groupedBy: (left: Parser<InfixOperator.TokenInput, Discard>, right: Parser<InfixOperator.TokenInput, Discard>)) -> Parser<InfixOperator.TokenInput, Infix<InfixOperator, Result>> {
    typealias InfixParser = Parser<InfixOperator.TokenInput, Infix<InfixOperator, Result>>
    
    // Order the operators by precedence, grouping those of similiar precedence, and then further grouping by associativity.
    let precedenceSortedOperators = InfixOperator.all.group{ $0.precedence > $1.precedence }.map{ $0.groupBy { $0.associativity } }
    
    // Set the base case to `parser`.
    var level: InfixParser = between(groupedBy.left, groupedBy.right, parse:
        hold(infix(InfixOperator.self, between: parser, groupedBy: groupedBy))
    ) ?? parser.map(Infix.Value)
    
    // Iterate over the precedence levels in increasing order.
    for precedenceLevel in precedenceSortedOperators {
        let previousLevel = level // Want to capture the value before it changes.
        
        // Define how this level is parsed, updating the `previousLevel` variable for the subsequent iteration.
        // Parse operators of just one of the possible associativities.
        level = coalesce(precedenceLevel.map { (associativity: Associativity, compatibleOperators: [InfixOperator]) in
            recursive { (level: InfixParser) in
                
                // Parse any of the possible operators with this associativity and precedence.
                return coalesce(compatibleOperators.map { anOperator in

                    // Parse the operator symbol expression. Each expression will be either the same or
                    // previous level depending on the associativity of the operator. Eventually, we'll
                    // run out of operators to parse and parse the previous level regardless.
                    return infixOperator(anOperator.matcher, between:
                        associativity == .Right ? (level ?? previousLevel) : previousLevel,
                        associativity == .Left  ? (level ?? previousLevel) : previousLevel
                    ).map { lhs, rhs in
                        Infix.Expression(infixOperator: anOperator, left: lhs, right: rhs)
                    }
                })
            }
        }) ?? previousLevel // There are no operators to parse at this level, so parse the previous level.
    }
    
    // Return the parser that will parse a tree of operators.
    return level
}
```

It turns out my implementation of infix operators is very similiar to what Parsec does, so that's reassuring!

### Research

I spent a while researching parsers because I felt a bit unconfident that mine was as easy to work with as I'd like it to be. I read this really interesting article about (ll and lr parsers)[http://blog.reverberate.org/2013/09/ll-and-lr-in-context-why-parsing-tools.html] and how they deal with ambiguity. This motivated me to try to modify the parsing library to follow all paths simultanously so that ambiguity could always be detected. I spent a bit longer on this than I probably should have before decided it was a big complication and a lot of code rewriting for questionable benefit, so I moved on.

### Critical Sections

I also spent a while understanding how the backtracking in my parsing library differed from Parsec. I had chose to make backtracking implicit (unlike Parsec, which requires an explict `try` everytime backtracking occurs). For example, the coalesce (alternative) combinator automatically backtracks on its arguments. This makes it more convenient to write the parser, but it results in worse error messages since we trash them by backtracking. Because of this, I implemented a "critical section" combinator in my library that, within the combinator, will throw irrecoverable errors. More specifically, errors that leave the combinator will be irrecoverable. This allows us to opt back into better error messages when we *know* that there are no alternatives.

```swift
let directive = optional(pair(string("directive "), critical(many1(digit))).map(right).map{ Int(String($0))! })
try directive.parse("director blah".characters)  // This will fail! We failed out of a criticial section.
try directive.parse("directive blah".characters) // This will return in `nil` since we backtracked to `optional`.
```

I spent a good while studying the Swift grammar [https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/parameter-list] as well when I had trouble writing a parser for my language. I learned that we really ought to start important structures with uniquely identifiable sequences such as `function` or `enum` or `let` so that we can use critical sections for their failures and actually provide good error messages.

### Better Error Reporting

I wanted to improve the error reporting of the parser library, so I rewrote the error handling mechanisms quite a few times, each not much happier than the last. I tried to add on ways to track the index of the character we failed on so we can later look up the line number and column number of the failure as well. Right now, this is implemented in a fork in an unsatisfactory way. After many iterations, I played around with the Parsec parsers we wrote in CS 115 trying to figure out how they gave such good error reporting. Since Parsec is open source, I studied (its implementaiton of error handling)[https://hackage.haskell.org/package/parsec-3.1.9/docs/src/Text-Parsec-Error.html#mergeError] to see what I could learn. I've now implemented a mechanism by which expected values can be communicated so that we know what the parser was unable to match with. This implementation, also on the fork, is very unsatisfactory right now IMO, so I really have a lot of cleaning up to do with it. I turned out to be a lot more difficult to do this right than I ever imagined.

### Tracking Line Numbers

Since my parsing library is general source (generic in the types it will parse rather than specially built to parse text), it doesn't make sense for it to track the column numbers of the text (since that requires knowing about the new line character which is special to text). Instead, I'll be tracking the index of the character during parsing, and I'll make a second pass over the file to determine the relevant column when handling an error thrown from the parsing library.

### Wrote Language Grammar

After studying the Swift grammar, I decided that I finally understood well enough how to write the grammar for my own language. First, let's discuss a few syntactic choices I'll be making for the time being to simplify the grammar. 

A lambda will either be type annotated and surrounded with parenthesis or completely unattotated. Regardless, the lamda with begin with a backslash.
```haskell
\x -> ...
\(x :: Int) -> ...
```

A sequenced block will only contain `let` statements for the time being, and the final statement will be a statement beginning with the word `return`. These decisions are made simply to simplify the grammar for the time being, and the will likely be changed in the future.
```swift
{
    let x = ...
    let y = ...
    return ...
}
```

Note that we will not use semicolons to delimit statements. Instead, we'll use new lines. To simplify parsing, we'll remove duplicate in-a-row new lines during the lexing stage. 

The following is the considered grammar. Note that the working of infix operators are not discussed as their precedence is handled by the parsing library.

```swift
break = "\n" // tokenize such that ignore duplicates in sequence 

program = many(constantDeclaration, separatedBy: break)

declaration = constantDeclaration

constantDeclaration = "let" #CRITICAL identifier "=" looselyBoundExpression

tightlyBoundExpression = identifier | "(" looselyBoundExpression ")"
looselyBoundExpression = lambdaDeclaration | binaryOperator | infixExpression | functionApplication | sequencedBlock // order matters!

infixExpression = tightlyBoundExpression binaryOperator tightlyBoundExpression

functionApplication = many1(tightlyBoundExpression)

lambdaDeclaration = "\" #CRITICAL lamdaArgument "->" expression
lambdaArgument = "(" many(argumentAttribute) identifier "::" typeExpression ")" | identifier

typeExpression = identifier // we aren't yet supporting polymorphic or generic types

sequencedBlock = "{" #CRITICAL many(constantDeclaration, separatedBy: break) sequencedBlockReturn "}"
sequencedBlockReturn = "return" #CRITICAL looselyBoundExpression break
```

