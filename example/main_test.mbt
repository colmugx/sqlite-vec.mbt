///|
test "sqlite-vec KNN example with functional API" {
  // Style 1: Direct method chaining
  let conn = @sqlite3.Connection::open(":memory:").load_extension(
    @vec.Vec::init(),
  )

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

  // Insert vectors as JSON arrays
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

  // KNN query with MATCH operator
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
  assert_true(query.step())
  let rowid : Int = query.column(index=0)
  let distance : Double = query.column(index=1)
  assert_eq(rowid, 1)
  assert_eq(distance, 0.0)
  assert_eq(query.step(), false)
  query.finalize()

  conn.close()
}

///|
test "sqlite-vec with pipe operator" {
  // Style 2: Functional pipe operator
  let conn = @sqlite3.Connection::open(":memory:") |> @vec.enable

  let stmt = conn.prepare("SELECT vec_version();")
  assert_true(stmt.step())
  let version : String = stmt.column(index=0)
  assert_true(version.length() > 0)
  stmt.finalize()
  conn.close()
}
