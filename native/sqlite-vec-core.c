/*
 * Wrapper that compiles sqlite-vec.c WITH SQLITE_CORE defined.
 *
 * When compiled with SQLITE_CORE, sqlite-vec.c includes sqlite3.h
 * (rather than sqlite3ext.h) and accesses SQLite functions directly
 * instead of through the runtime sqlite3_api_routines pointer.
 *
 * This is the same compilation mode used by the Rust binding
 * (cc::Build::new().define("SQLITE_CORE", None)).
 */
#define SQLITE_CORE
#include "sqlite-vec.c"