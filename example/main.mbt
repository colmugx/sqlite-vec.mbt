///|
/// 1. 存 — 插入多条向量数据
fn insert_example(conn : @sv.Connection) -> Unit raise @sv.SqliteError {
  println("=== 插入向量示例 ===")
  let create = conn.prepare(
    (
      #|CREATE VIRTUAL TABLE IF NOT EXISTS items USING vec0(
      #|  embedding float[3]
      #|);
    ),
  )
  create.step_once()
  create.finalize()

  let stmt1 = conn.prepare(
    (
      #|INSERT INTO items(rowid, embedding) VALUES (?, ?);
    ),
  )
  stmt1.bind(index=1, 1)
  stmt1.bind(index=2, "[1.0, 2.0, 3.0]")
  stmt1.step_once()
  stmt1.finalize()
  println("插入 rowid=1, embedding=[1.0, 2.0, 3.0]")

  let stmt2 = conn.prepare(
    (
      #|INSERT INTO items(rowid, embedding) VALUES (?, ?);
    ),
  )
  stmt2.bind(index=1, 2)
  stmt2.bind(index=2, "[4.0, 5.0, 6.0]")
  stmt2.step_once()
  stmt2.finalize()
  println("插入 rowid=2, embedding=[4.0, 5.0, 6.0]")

  let stmt3 = conn.prepare(
    (
      #|INSERT INTO items(rowid, embedding) VALUES (?, ?);
    ),
  )
  stmt3.bind(index=1, 3)
  stmt3.bind(index=2, "[7.0, 8.0, 9.0]")
  stmt3.step_once()
  stmt3.finalize()
  println("插入 rowid=3, embedding=[7.0, 8.0, 9.0]")
}

///|
/// 2. 查 — KNN 相似度搜索并打印结果
fn query_example(conn : @sv.Connection) -> Unit raise @sv.SqliteError {
  println("\n=== KNN 查询示例 ===")
  let stmt = conn.prepare(
    (
      #|SELECT rowid, distance
      #|FROM items
      #|WHERE embedding MATCH ?
      #|ORDER BY distance
      #|LIMIT 3;
    ),
  )
  stmt.bind(index=1, "[3.0, 4.0, 5.0]")
  println("查询向量: [3.0, 4.0, 5.0]")
  println("结果:")
  if stmt.step() {
    let rowid : Int = stmt.column(index=0)
    let distance : Double = stmt.column(index=1)
    println("  rowid=\{rowid}, distance=\{distance}")
  }
  if stmt.step() {
    let rowid : Int = stmt.column(index=0)
    let distance : Double = stmt.column(index=1)
    println("  rowid=\{rowid}, distance=\{distance}")
  }
  if stmt.step() {
    let rowid : Int = stmt.column(index=0)
    let distance : Double = stmt.column(index=1)
    println("  rowid=\{rowid}, distance=\{distance}")
  }
  stmt.finalize()
}

///|
fn run() -> Unit raise @sv.SqliteError {
  @sv.vec_enable()
  let conn = @sv.Connection::open(":memory:")
  insert_example(conn)
  query_example(conn)
  conn.close()
}

///|
fn main {
  run() catch {
    _ => println("example failed")
  }
}
