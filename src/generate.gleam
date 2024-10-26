import app/home
import app/posts
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import lustre/ssg
import simplifile

const root_dir = "./docs"

pub fn main() {
  let assert Ok(posts) = posts.get_posts()
  let data =
    posts
    |> list.map(fn(post) { #(post.number |> int.to_string, post.number) })
    |> dict.from_list
  let build =
    ssg.new(root_dir)
    |> ssg.add_static_route("/", home.html())
    |> ssg.add_dynamic_route("/posts", data, posts.show)
    |> ssg.build
  let assert Ok(_) =
    simplifile.copy_directory("./priv/static", root_dir <> "/static")
  let assert Ok(_) =
    simplifile.copy_file("./.nojekyll", root_dir <> "/.nojekyll")
  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      io.debug(e)
      io.println("Build failed!")
    }
  }
}
