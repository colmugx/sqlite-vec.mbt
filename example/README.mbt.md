# sqlite-vec Example

Runnable example demonstrating sqlite-vec vector search with MoonBit.

## Run

```bash
moon run example
```

## API Styles Demonstrated

### Pipe Operator
```moonbit nocheck
///|
let conn = @sqlite3.Connection::open(":memory:") |> @vec.enable
```

### Method Chaining
```moonbit nocheck
///|
let conn = @sqlite3.Connection::open(":memory:").load_extension(
  @vec.Vec::init(),
)
```

## What It Does

1. Opens an in-memory SQLite database
2. Loads the sqlite-vec extension
3. Creates a `vec0` virtual table with 3-dimensional float vectors
4. Inserts a sample vector `[1.0, 2.0, 3.0]`
5. Performs a KNN (k-nearest neighbors) query
6. Prints the matching rowid and distance
