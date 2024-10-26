import gleam/option.{Some}

import lustre/attribute as attr
import lustre/element/html

import app/collection.{Item}
import app/layout.{layout}
import app/posts

pub fn html() {
  layout([
    html.section([attr.class("pub fn")], [
      html.h1([], [html.text("main")]),
      html.section([attr.class("stack")], [
        //
        posts.summaries(),
        projects(),
      ]),
    ]),
  ])
}

fn projects() {
  [
    Item(
      text: "specialblend/mapql",
      url: "https://github.com/specialblend/mapql",
      comment: Some(
        "map, filter, and transform data structures using GraphQL and JSONPath.",
      ),
    ),
    Item(
      text: "specialblend/tokenbot",
      url: "https://github.com/specialblend/tokenbot",
      comment: Some("slack bot as social recognition platform"),
    ),
  ]
  |> collection.html("projects")
}
