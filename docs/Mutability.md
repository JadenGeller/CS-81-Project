# Mutability

A goal of the language is to provide immutable-by-default semantics. The exact mechanism of this hasn't been yet determined, but the idea is to allow `mutable` annotations to arguments of functions that essentially make a C++ style reference. This hasn't been fully considered though, and there may be reasons to do this differently. In general though, it's expected that functions in the language ought to act functionally (not mutating global state).

To make functions like `log` mutable, there might be a `console` variable that is passed into the log function to change its state.
```haskell
let log = (console :: mutable Console) -> (message :: String) -> {
  {- builtin implementation -}
}
```
Since we don't want global state, the `console` variable might be a `mutable` parameter to the `main` function, and it must be propogated to print to the console (although there will probably exist some unsafe mechanism to do the same for debug purposes).
```haskell
console.log "Hello world"
```
