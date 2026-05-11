# sqlite-vec for MoonBit

MoonBit bindings for [sqlite-vec](https://github.com/asg017/sqlite-vec), a vector search SQLite extension.

## Installation

Add to your `moon.mod.json`:

```json
{
  "deps": {
    "colmugx/sqlite-vec": "0.1.0",
    "colmugx/sqlite3": "0.1.5"
  }
}
```

## Usage

```moonbit nocheck
///|
let conn = @sqlite3.Connection::open(":memory:")

// Method 1: Pipe operator

///|
let conn = conn |> @vec.enable

// Method 2: Method chaining with loader

///|
let conn = conn.load_extension(@vec.Vec::init())
```

## Functional API Design

The API follows MoonBit's functional style:

- `@vec.enable` returns `Connection` for pipe chaining (`|>`)
- `@vec.Vec::init()` returns a loader function for `Connection::load_extension`

## Example: KNN Vector Search

```moonbit nocheck
let conn = @sqlite3.Connection::open(":memory:") |> @vec.enable

// Create vec0 virtual table
let create = conn.prepare(
  #|CREATE VIRTUAL TABLE items USING vec0(embedding float[3]);
)
create.step_once()
create.finalize()

// Insert vectors
let insert = conn.prepare(
  #|INSERT INTO items(rowid, embedding) VALUES (?, ?);
)
insert.bind(index=1, 1)
insert.bind(index=2, "[1.0, 2.0, 3.0]")
insert.step_once()
insert.finalize()

// KNN query
let query = conn.prepare(
  #|SELECT rowid, distance FROM items
  #|WHERE embedding MATCH ? ORDER BY distance LIMIT 1;
)
query.bind(index=1, "[1.0, 2.0, 3.0]")
if query.step() {
  let rowid : Int = query.column(index=0)
  let distance : Double = query.column(index=1)
}
query.finalize()
conn.close()
```
