import app/home
import app/posts
import gleam/bytes_builder
import gleam/erlang/process
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/io
import gleam/option.{None}
import gleam/result
import lustre/element
import mist
import radiate

pub fn main() {
  let assert Ok(_) = watcher()
  let assert Ok(_) = router()
  process.sleep_forever()
}

fn watcher() {
  radiate.new()
  |> radiate.add_dir(".")
  |> radiate.on_reload(fn(_, path) { io.println("reloading: " <> path) })
  |> radiate.start()
}

fn router() {
  fn(req) {
    case request.path_segments(req) {
      ["static", "favicon.ico"] -> favicon()
      ["static", "style.css"] -> stylesheet()
      ["static", "script.js"] -> script()
      ["posts", id] -> show_post(id)
      [] -> home()
      _ -> not_found()
    }
  }
  |> mist.new
  |> mist.port(3000)
  |> mist.start_http
}

fn home() {
  ok(home.html())
}

fn show_post(id: String) {
  case id |> int.parse {
    Ok(id) -> ok(posts.show(id))
    Error(_) -> not_found()
  }
}

fn favicon() {
  serve_static("priv/static/favicon.ico", "image/x-icon")
}

fn stylesheet() {
  serve_static("priv/static/style.css", "text/css")
}

fn script() {
  serve_static("priv/static/script.js", "application/javascript")
}

fn serve_static(path, content_type) {
  mist.send_file(path, offset: 0, limit: None)
  |> result.map(fn(data) {
    response.new(200)
    |> response.prepend_header("content-type", content_type)
    |> response.prepend_header(
      "cache-control",
      "public, max-age=3600, stale-while-revalidate=3600",
    )
    |> response.set_body(data)
  })
  |> result.lazy_unwrap(not_found)
}

fn not_found() {
  response.new(404)
  |> response.set_body(mist.Bytes(bytes_builder.new()))
}

fn ok(elem) {
  let html =
    elem
    |> element.to_document_string_builder
    |> bytes_builder.from_string_builder
    |> mist.Bytes
  response.new(200)
  |> response.prepend_header("content-type", "text/html; charset=utf-8")
  |> response.set_body(html)
}
