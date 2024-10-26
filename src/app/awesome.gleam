import gleam/option.{None, Some}

import lustre/attribute as attr
import lustre/element/html

import app/collection.{Item}

pub fn html() {
  html.section([attr.class("fn stack")], [
    html.h1([], [html.text("awesome")]),
    ppl(),
    langs(),
    videos(),
    games(),
    books(),
  ])
}

fn ppl() {
  [
    Item(
      text: "github.com/joearms",
      url: "https://github.com/joearms",
      comment: Some("Joseph Armstrong (RIP)"),
    ),
    Item(
      text: "github.com/swlaschin",
      url: "https://github.com/swlaschin",
      comment: Some("Scott Wlaschin"),
    ),
    Item(
      text: "github.com/BartoszMilewski",
      url: "https://github.com/BartoszMilewski",
      comment: Some("Bartosz Milewski"),
    ),
  ]
  |> collection.html("ppl")
}

fn videos() {
  [
    Item(
      text: "youtu.be/SxdOUGdseq4",
      url: "https://youtu.be/SxdOUGdseq4",
      comment: Some("Rich Hickey - Simple Made Easy"),
    ),
    Item(
      text: "youtu.be/2JB1_e5wZmU",
      url: "https://youtu.be/2JB1_e5wZmU",
      comment: Some("Scott Wlaschin - Domain Modeling Made Functional"),
    ),
    Item(
      text: "youtu.be/17KCHwOwgms",
      url: "https://youtu.be/17KCHwOwgms",
      comment: Some("Dan Abramov - The Wet Codebase"),
    ),
    Item(
      text: "youtu.be/WgV6M1LyfNY",
      url: "https://youtu.be/WgV6M1LyfNY",
      comment: Some(
        "No Boilerplate - The Unreasonable Effectiveness of Plain Text",
      ),
    ),
  ]
  |> collection.html("videos")
}

fn games() {
  [
    Item(
      "Railgrade",
      "https://railgrade.com",
      Some("like factorio but simpler"),
    ),
    Item(
      "Thronefall",
      "https://store.steampowered.com/app/2239150/Thronefall/",
      Some("simple tower defense game"),
    ),
  ]
  |> collection.html("games")
}

fn langs() {
  [
    Item("rust", "https://www.rust-lang.org", comment: None),
    Item("ocaml", "https://ocaml.org", comment: None),
    Item("gleam", "https://gleam.run", comment: None),
    Item("elixir", "https://elixir-lang.org", comment: None),
    Item("unison", "https://www.unison-lang.org", comment: None),
  ]
  |> collection.html("langs")
}

fn books() {
  [
    Item("Atomic Habits", "https://jamesclear.com/atomic-habits", comment: None),
    Item("Radical Candor", "https://www.radicalcandor.com", comment: None),
    Item(
      "Meltdown",
      "https://www.amazon.com/Meltdown-Systems-Fail-What-About/dp/0735222630",
      comment: None,
    ),
  ]
  |> collection.html("books")
}
