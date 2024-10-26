import app/layout.{layout}
import app/markdown
import dot_env
import dot_env/env
import gleam/dict.{type Dict}
import gleam/dynamic as dyn
import gleam/dynamic.{type Dynamic}
import gleam/http/request
import gleam/http/response.{Response}
import gleam/httpc
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option}
import gleam/result.{replace_error as expect, try}
import gleam/uri
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import tempo.{type DateTime}
import tempo/datetime

pub type Post {
  Post(
    id: Int,
    number: Int,
    title: String,
    body: String,
    html_url: String,
    created_at: DateTime,
    updated_at: Option(DateTime),
    comments: Option(Int),
  )
}

pub fn show(number: Int) {
  case get_post(number) {
    Ok(post) -> layout([details(post)])
    Error(e) -> layout([html.p([], [html.text(e)])])
  }
}

pub fn summaries() {
  let posts = get_posts() |> result.unwrap([])
  case posts {
    [] -> element.fragment([])
    _ ->
      html.section([attr.class("let list")], [
        html.h3([attr.class("var")], [html.text("posts")]),
        html.ul([attr.class("val stack")], posts |> list.map(summary)),
      ])
  }
}

fn summary(post: Post) {
  let url = "/posts/" <> { post.number |> int.to_string }
  html.li([], [
    html.article([], [
      html.footer(
        [
          attr.attribute(
            "data-timestamp",
            post.created_at |> datetime.to_string,
          ),
          attr.class("comment timestamp"),
          attr.style([#("display", "block")]),
        ],
        [html.text(post.created_at |> timestamp)],
      ),
      html.p([], [
        html.a([attr.href(url), attr.target("_self"), attr.class("string")], [
          html.text(post.title),
        ]),
      ]),
    ]),
  ])
}

fn details(post: Post) {
  let url = "/posts/" <> { post.number |> int.to_string }
  html.article([attr.class("markdown blog post")], [
    html.header([], [
      html.h1([], [
        html.a([attr.href(url), attr.target("_self")], [html.text(post.title)]),
      ]),
      html.p(
        [
          attr.attribute(
            "data-timestamp",
            post.created_at |> datetime.to_string,
          ),
          attr.class("muted timestamp"),
        ],
        [html.text(post.created_at |> timestamp)],
      ),
    ]),
    html.section([attr.class("content")], post.body |> markdown.parse_markdown),
  ])
}

fn timestamp(ts) {
  ts |> datetime.format("YYYY-MM-DD HH:mm")
}

const discussions = "https://api.github.com/repos/specialblend/specialblend.dev/discussions"

pub fn get_posts() {
  use uri <- try(uri.parse(discussions) |> expect("Failed to parse URI"))
  use req <- try(request.from_uri(uri) |> expect("Failed to create request"))
  use token <- try(get_token())
  let res =
    req
    |> request.prepend_header("Authorization", "Bearer " <> token)
    |> httpc.send
    |> expect("Failed to fetch posts")

  case res {
    Error(e) -> Error(e)
    Ok(Response(200, _, body)) ->
      body
      |> json.decode(dyn.dynamic)
      |> expect("Failed to parse response")
      |> result.then(parse_list)
      |> result.map(list.filter_map(_, parse_post))
    Ok(res) -> Error("Request failed with status " <> int.to_string(res.status))
  }
}

pub fn get_post(number: Int) {
  let url = discussions <> "/" <> int.to_string(number)
  use uri <- try(uri.parse(url) |> expect("Failed to parse URI"))
  use req <- try(request.from_uri(uri) |> expect("Failed to create request"))
  use token <- try(get_token())
  let res =
    req
    |> request.prepend_header("Authorization", "Bearer " <> token)
    |> httpc.send
    |> expect("Failed to fetch posts")

  case res {
    Error(e) -> Error(e)
    Ok(Response(200, _, body)) ->
      body
      |> json.decode(dyn.dynamic)
      |> expect("Failed to parse response")
      |> result.then(parse_dict)
      |> result.then(parse_post)
    Ok(res) -> Error("Request failed with status " <> int.to_string(res.status))
  }
}

fn parse_list(data) {
  data
  |> dyn.list(of: dyn.dict(of: dyn.string, to: dyn.dynamic))
  |> expect("failed to parse list of posts")
}

fn parse_dict(data) {
  data
  |> dyn.dict(of: dyn.string, to: dyn.dynamic)
  |> expect("failed to parse post")
}

fn parse_post(data: Dict(String, Dynamic)) {
  let get_int = get_key(data, dyn.int, _)
  let get_string = get_key(data, dyn.string, _)

  use id <- try(get_int("id"))
  use number <- try(get_int("number"))
  use title <- try(get_string("title"))
  use body <- try(get_string("body"))
  use html_url <- try(get_string("html_url"))
  use created_at <- try(get_string("created_at"))

  let updated_at = get_string("updated_at")
  let comments = get_int("comments")

  Post(
    id: id,
    number: number,
    title: title,
    body: body,
    html_url: html_url,
    created_at: created_at |> datetime.literal,
    updated_at: updated_at |> option.from_result |> option.map(datetime.literal),
    comments: comments |> option.from_result,
  )
  |> Ok
}

fn get_key(data, parse, key) {
  let err = "failed to parse key " <> key
  use data <- try(
    data
    |> dict.get(key)
    |> expect(err),
  )
  data |> parse |> expect(err)
}

fn get_token() {
  dot_env.load_default()
  env.get_string("DISCUSSIONS_API_TOKEN")
  |> expect("missing DISCUSSIONS_API_TOKEN")
}
