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
