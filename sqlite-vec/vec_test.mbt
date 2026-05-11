///|
test "sqlite-vec loads and vec_version works" {
  let conn = @sqlite3.Connection::open(":memory:")
  let conn = conn |> enable
  let query = conn.prepare("SELECT vec_version();")
  assert_true(query.step())
  let version : String = query.column(index=0)
  assert_true(version.length() > 0)
  query.finalize()
  conn.close()
}
