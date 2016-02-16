Literal values in the programming language will be represented in a data format that minimizes data loss. For example, integer literals will be stored as an array of digits (rather than some native integer type) so that future types can utilize arbitrarily large integer literals (instead of being bounded by the built-in type).

```swift
enum LiteralValue: Parsable, Equatable, CustomStringConvertible {
    case IntegerLiteral(sign: Sign, digits: [Digit])
    case FloatingPointLiteral(sign: Sign, significand: [Digit], exponent: Int)
    case StringLiteral(String)
}
```

Types in the language will be able to define implicit conversion from literal values, and the type unifier will choose the appropriate conversion or notify the user if there is ambiguity.
