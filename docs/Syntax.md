#Syntax 
The language will likely use a hybrid syntax between Haskell and Swift.

```haskell
let append = (array :: mutable Array a) -> (element :: a) -> {
  {- do stuff -}
}
```

```haskell
let logTwice = (mutable console :: Console) -> (string :: String) -> {
  do console.log string
  do console.log string
}
```

The language will support "dot syntax" for calling functions "on a type". Essentially, if there exists a function `f` that takes an instance `v` as its first argument, you can call `v.f` instead of `f v`. It might be intelligent to provide limitations to this (or make functions explictly opt into this behavior), but that hasn't been fully considered yet.

```haskell
let sorted = (unsorted :: Array a) -> {
	var sorted :: SortedArray = empty
	do unsorted.forEach sorted.insert
	return sorted
} :: SortedArray a

```

More details will be provided as this is finalized over the upcoming weeks.

## Examples

```haskell
speak := \-> debugPrint "Hi"

square := x -> x * x :: Int

double := (x :: Int | Float) -> x + x :: Int

identity := (x :: 'A) -> x :: 'A

concat := (lhs :: String) -> (rhs :: String) -> copy in {
	mutable copy := lhs
	rhs.forEach (c -> copy.append c)
} :: String

factorial1 := (x :: Int) -> result in {
	mutable x := x
	mutable result := 1
	while (\-> x > 0) (\-> result.set (result * x))
} :: Int

factorial2 := (x :: Int) -> result in {
	mutable result := 1
	(range 1 x).forEach (x -> result.set (result * x))
}

factorial3 := (x :: Int) -> if (x = 0) (\-> 1) (\-> x * factorial (x - 1))
```
