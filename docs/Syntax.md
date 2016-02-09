#Syntax 
The language will likely use a hybrid syntax between Haskell and Swift.

```haskell
let append = (array :: inout Array a) -> (element :: a) -> {
  {- do stuff -}
}
```

```haskell
let logTwice = (mutable console :: Console) -> (string :: String) -> {
  do console.log string
  do console.log string
}
```

```haskell
let sorted = (unsorted :: Array a) -> {
	var sorted :: SortedArray = empty
	do unsorted.forEach sorted.insert
	return sorted
} :: SortedArray a

```

More details will be provided as this is finalized over the upcoming weeks.
