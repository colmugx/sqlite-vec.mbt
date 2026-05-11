///|
pub type Vec

///|
pub fn Vec::init() -> (@sqlite3.Connection) -> Unit raise @sqlite3.SqliteError {
  conn => conn |> enable |> ignore
}

///|
#callsite(autofill(loc))
pub fn enable(
  conn : @sqlite3.Connection,
  loc~ : SourceLoc,
) -> @sqlite3.Connection raise @sqlite3.SqliteError {
  let rescode = @native.sqlite3_vec_init(conn.raw())
  if rescode != @sqlite3.SQLITE_OK {
    raise @sqlite3.SqliteError::new(rescode, loc)
  }
  conn
}
