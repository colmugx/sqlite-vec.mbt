///|
/// Enable sqlite-vec vector search globally.
///
/// Registers `sqlite3_vec_init` via `sqlite3_auto_extension`, so every new
/// database connection automatically gets vec0 virtual tables and vector
/// functions. Call this ONCE before opening any connections.
///
/// Internally this calls `sqlite3_auto_extension(sqlite3_vec_init)` — the
/// same pattern used by the Rust binding. The C init function is compiled
/// WITH `SQLITE_CORE` alongside the sqlite3 amalgamation, so no separate
/// .so/.dylib file is needed.
///
/// Example:
/// ```
/// ///|
/// test "use vec" {
///   vec_enable()
///   let conn = Connection::open(":memory:")
///   let query = conn.prepare("SELECT vec_version();")
///   assert_true(query.step())
///   let version : String = query.column(index=0)
///   assert_true(version.length() > 0)
///   query.finalize()
///   conn.close()
/// }
/// ```
pub fn vec_enable() -> Unit {
  let rc = @native.vec_enable()
  // sqlite3_auto_extension returns SQLITE_OK (0) on success.
  // It's safe to ignore duplicates (same init registered twice is a no-op).
  if rc != 0 {
    // Registration failed — this can happen if SQLite was compiled
    // without SQLITE_ENABLE_LOAD_EXTENSION support.
    println("Warning: sqlite-vec auto_extension returned \{rc}")
  }
}
