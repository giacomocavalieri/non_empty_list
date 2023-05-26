# non_empty_list

[![Package Version](https://img.shields.io/hexpm/v/non_empty)](https://hex.pm/packages/non_empty)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/non_empty/)

Non-empty lists in Gleam ✨

This package has almost exactly all functions you can find on [`gleam/list`](https://hexdocs.pm/gleam_stdlib/gleam/list.html) but for non-empty lists. If you think there's a missing functions you'd love to have, open an issue!

## Installation

This package can be added to your Gleam project:

```sh
gleam add non_empty_list
```

and its documentation can be found at <https://hexdocs.pm/non_empty>.

## Usage

Import the `non_empty_list` module and write some code!

```gleam
import non_empty_list
import gleam/int
import gleam/io

pub fn main() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.scan(fn(n, m) { n + m })
  |> int.to_string
  |> io.println 
}
```
