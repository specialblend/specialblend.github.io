import app/typewriter.{typewriter}
import lustre/attribute as attr
import lustre/element/html

pub fn html() {
  html.section([attr.class("fn")], [
    html.h1([], [html.text("about")]),
    bio(),
    github(),
  ])
}

fn bio() {
  html.section([attr.class("let")], [
    typewriter(
      html.p,
      [attr.class("comment")],
      "software engineer, hobbyist polyglot, simple caveman. likes fire, watermelon, and functional programming.",
    ),
    html.dt([attr.class("var")], [html.text("name")]),
    html.dd([attr.class("val string")], [html.text("cj")]),
  ])
}

fn github() {
  html.section([attr.class("let")], [
    html.dt([attr.class("var")], [html.text("github")]),
    html.dd([attr.class("val string")], [
      html.a(
        [attr.href("https://github.com/specialblend"), attr.target("_blank")],
        [html.text("specialblend")],
      ),
    ]),
  ])
}
