import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as attr
import lustre/element/html

import app/typewriter.{typewriter}

pub type Item {
  Item(text: String, url: String, comment: Option(String))
}

pub fn html(items: List(Item), name: String) {
  html.section([attr.class("let list")], [
    html.h3([attr.class("var")], [html.text(name)]),
    html.ul([attr.class("val stack")], items |> list.map(item_html)),
  ])
}

fn item_html(item) {
  case item {
    Item(text, url, None) -> {
      html.li([], [hyperlink(text, url)])
    }
    Item(text, url, Some(comment)) -> {
      html.li([], [
        typewriter(html.h4, [attr.class("comment")], comment),
        hyperlink(text, url),
      ])
    }
  }
}

fn hyperlink(text, url) {
  html.p([], [
    html.a([attr.class("string"), attr.href(url), attr.target("_blank")], [
      html.text(text),
    ]),
  ])
}
