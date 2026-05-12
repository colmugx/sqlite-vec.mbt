///|
test "sqlite-vec auto_extension works" {
  vec_enable()
  let conn = Connection::open(":memory:")
  let query = conn.prepare("SELECT vec_version();")
  assert_true(query.step())
  let version : String = query.column(index=0)
  assert_true(version.length() > 0)
  query.finalize()
  conn.close()
}
