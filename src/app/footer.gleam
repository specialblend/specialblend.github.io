import lustre/attribute as attr
import lustre/element/html

import app/about
import app/awesome

pub fn html() {
  html.section([attr.class("stack")], [awesome.html(), about.html()])
}
