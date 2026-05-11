///|
fn run_example() -> Unit raise @sqlite3.SqliteError {
  let conn = @sqlite3.Connection::open(":memory:")
  let conn = conn |> @vec.enable

  // Create vec0 virtual table
  let create = conn.prepare(
    (
      #|CREATE VIRTUAL TABLE items USING vec0(
      #|  embedding float[3]
      #|);
    ),
  )
  create.step_once()
  create.finalize()

  // Insert vectors
  let insert = conn.prepare(
    (
      #|INSERT INTO items(rowid, embedding)
      #|VALUES (?, ?);
    ),
  )
  insert.bind(index=1, 1)
  insert.bind(index=2, "[1.0, 2.0, 3.0]")
  insert.step_once()
  insert.finalize()

  // KNN query
  let query = conn.prepare(
    (
      #|SELECT rowid, distance
      #|FROM items
      #|WHERE embedding MATCH ?
      #|ORDER BY distance
      #|LIMIT 1;
    ),
  )
  query.bind(index=1, "[1.0, 2.0, 3.0]")
  if query.step() {
    let rowid : Int = query.column(index=0)
    let distance : Double = query.column(index=1)
    println("rowid: \{rowid}, distance: \{distance}")
  }
  query.finalize()

  conn.close()
}

///|
fn main {
  run_example() catch {
    _ => println("Error occurred")
  }
}
