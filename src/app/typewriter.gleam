import gleam/float
import gleam/int
import gleam/string

import lustre/attribute as attr
import lustre/element/html

pub fn typewriter(tag, attrs, txt) {
  let len = txt |> string.length |> int.to_string
  let step =
    float.random()
    |> float.multiply(0.02)
    |> float.add(0.01)
    |> float.to_string
    |> string.append("s")
  tag(attrs, [
    html.span(
      [attr.class("typewriter"), attr.style([#("--n", len), #("--step", step)])],
      [html.text(txt)],
    ),
  ])
}
