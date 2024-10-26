import gleam/int
import gleam/list

import kirala/bbmarkdown/parser as md
import lustre/attribute as attr
import lustre/element.{type Element}
import lustre/element/html

pub fn parse_markdown(body: String) -> List(Element(a)) {
  md.parse_all(body)
  |> list.map(parse_token)
}

fn parse_token(token: md.Token) -> Element(a) {
  case token {
    md.Line(tokens) -> {
      element.fragment(tokens |> list.map(parse_token))
    }
    md.LineIndent(_i, tokens) -> {
      case tokens {
        [] -> element.fragment([])
        _ -> element.fragment(tokens |> list.map(parse_token))
      }
    }
    md.Text(text) -> {
      element.fragment([html.text(text)])
    }
    md.Bold(children) -> {
      html.strong([], [parse_token(children)])
    }
    md.Italic(children) -> {
      html.em([], [parse_token(children)])
    }
    md.StrikeThrough(children) -> {
      html.del([], [parse_token(children)])
    }
    md.MarkedText(children) -> {
      html.mark([], [parse_token(children)])
    }
    md.InsertedText(children) -> {
      html.ins([], [parse_token(children)])
    }
    md.Note(title, children) -> {
      html.aside([], [html.h1([], [html.text(title)]), parse_token(children)])
    }
    md.H(id, order, children) -> {
      let h = case order {
        1 -> html.h1
        2 -> html.h2
        3 -> html.h3
        4 -> html.h4
        5 -> html.h5
        6 -> html.h6
        _ -> html.h6
      }
      h([attr.id("H" <> id |> int.to_string)], [parse_token(children)])
    }
    md.CodeBlock(_syntax, _filename, code) -> {
      html.pre([], [html.code([], [html.text(code)])])
    }
    md.CodeSpan(code) -> {
      html.code([], [html.text(code)])
    }
    md.CodeLine(code) -> {
      html.code([], [html.text(code)])
    }
    md.BlockQuote(_indent, token) -> {
      html.blockquote([], [parse_token(token)])
    }
    md.ListItem(_list_type, indent, token) -> {
      html.li(
        [attr.style([#("margin-left", indent |> int.to_string <> "rem")])],
        [parse_token(token)],
      )
    }
    md.Url(url_data) -> {
      case url_data {
        md.UrlPlain(url) -> html.a([attr.href(url)], [html.text(url)])
        md.UrlFootNote(url) -> html.a([attr.href(url)], [html.text(url)])
      }
    }
    md.UrlLink(caption, url_data) -> {
      case url_data {
        md.UrlPlain(url) -> html.a([attr.href(url)], [html.text(caption)])
        md.UrlFootNote(url) -> html.a([attr.href(url)], [html.text(caption)])
      }
    }
    md.ImgLink(_caption, alt, url_data) -> {
      case url_data {
        md.UrlPlain(url) -> html.img([attr.src(url), attr.alt(alt)])
        md.UrlFootNote(url) -> html.img([attr.src(url), attr.alt(alt)])
      }
    }
    md.FootNote(id, token) -> {
      html.aside([], [html.h1([], [html.text(id)]), parse_token(token)])
    }
    md.FootNoteUrlDef(id, url, alt) -> {
      html.aside([], [
        html.h1([], [html.text(id)]),
        html.a([attr.href(url)], [html.text(alt)]),
      ])
    }
    md.Table(header, _aligns, lines) -> {
      html.table([], [
        html.thead([], [
          html.tr(
            [],
            header
              |> list.map(parse_token),
          ),
        ]),
        html.tbody(
          [],
          lines
            |> list.map(fn(line) {
              html.tr(
                [],
                line
                  |> list.map(parse_token),
              )
            }),
        ),
      ])
    }
    md.DefinitionOf(token) -> {
      html.dl([], [parse_token(token)])
    }
    md.Definition(tokens) -> {
      html.p(
        [],
        tokens
          |> list.map(fn(token) { html.dt([], [parse_token(token)]) }),
      )
    }
    md.DefinitionIs(str, token) -> {
      html.p([], [html.dd([], [html.text(str)]), parse_token(token)])
    }
    md.HR -> {
      html.hr([])
    }
  }
}
