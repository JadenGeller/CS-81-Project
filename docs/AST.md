# Abstract Syntax Tree

```swift
enum Expression {
	case Literal(LiteralValue)
	case Bare(Identifier)
	indirect case Assignment(Identifier, Expression)
	indirect case Lambda(Identifier, Expression)
	indirect case Invocation(Expression, Expression)
	case Sequence([Expression])
}
```

## Examples

### Square

```haskell
let square = (x :: Int) -> multiply x x
```

```lisp
(#assign square (#capture x
	(#invoke (#invoke (#lookup multiply) (#lookup x)) (#lookup x))
))
```

### Concat

```haskell
let concat = (lhs :: String) -> (rhs :: String) -> {
	var copy = lhs
	rhs.forEach (c -> copy.append c)
	return copy
}
```

```lisp
(#assign concat (#capture lhs (#capture rhs (#sequence
	(#assign copy (#lookup lhs))
	(#invoke (#invoke (#lookup forEach) (#lookup rhs)) (#capture c 
		(#invoke (#invoke (#lookup append) (#lookup copy)) (#lookup c)))
	)
	(#lookup copy)
))))
```
