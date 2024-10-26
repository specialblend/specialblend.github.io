import lustre/attribute as attr
import lustre/element/html

import app/footer
import app/typewriter.{typewriter}

pub fn layout(children) {
  html.html([], [
    html.head([], [
      html.title([], "specialblend.dev"),
      html.meta([
        attr.name("viewport"),
        attr.attribute("content", "width=device-width, initial-scale=1"),
        attr.attribute("charset", "utf-8"),
      ]),
      html.link([
        attr.rel("icon"),
        attr.href("static/favicon.ico"),
        attr.type_("image/x-icon"),
      ]),
      html.link([attr.rel("stylesheet"), attr.href("static/style.css")]),
      html.link([
        attr.rel("preconnect"),
        attr.href("https://fonts.googleapis.com"),
      ]),
      html.link([attr.rel("preconnect"), attr.href("https://fonts.gstatic.com")]),
      html.link([
        attr.rel("stylesheet"),
        attr.href(
          "https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&display=swap",
        ),
      ]),
      html.link([
        attr.rel("stylesheet"),
        attr.href(
          "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark-dimmed.min.css",
        ),
      ]),
      html.script(
        [
          attr.src(
            "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js",
          ),
        ],
        "",
      ),
      html.script([attr.src("static/script.js")], ""),
    ]),
    html.body([attr.class("stack")], [
      html.header([], [
        html.h1([], [
          typewriter(
            html.a,
            [attr.class("comment"), attr.href("/")],
            "specialblend.dev",
          ),
        ]),
      ]),
      html.main([], children),
      html.footer([], [footer.html()]),
      html.script([], "hljs.highlightAll();"),
    ]),
  ])
}
