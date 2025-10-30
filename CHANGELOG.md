# Changelog

## Unreleased

- the `non_empty_list` module gains the `length` and `all` functions.

## v2.0.0 - 2024-05-11

- the `from_list` function in the `non_empty_list` module now return
  `Error(Nil)` if the passed list is empty.
- the `strict_zip` function in the `non_empty_list` module now returns
  `Nil` upon error instead of `list.LengthMismatch` which no longer exists in
  `stdlib`.
- update `stdlib` dep to `>= 0.37.0 and < 2.0.0`.
- set gleam version requirement to `>= 1.0.0 and < 2.0.0`.

## v1.1.1 - 2024-02-10

- update `stdlib` dep to `~> 0.34 or ~> 1.0`
- update `gleeunit` dep to `~> 1.0`

## v1.1.0 - 2023-07-23

- the `non_empty_list` module gains the `map2` function

## v1.0.0 - 2023-05-26

- Initial release!
