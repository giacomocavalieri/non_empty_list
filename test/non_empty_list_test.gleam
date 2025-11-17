import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleeunit
import non_empty_list.{NonEmptyList}

pub fn main() {
  gleeunit.main()
}

pub fn all_test() {
  let assert Ok(_) =
    non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.map(Ok)
    |> non_empty_list.all

  let assert Error(_) =
    non_empty_list.new(Ok(1), [Error("e")])
    |> non_empty_list.all
}

pub fn append_test() {
  assert non_empty_list.new(1, [2, 3, 4, 5, 6, 7])
    == non_empty_list.append(
      non_empty_list.new(1, [2, 3, 4]),
      non_empty_list.new(5, [6, 7]),
    )

  assert non_empty_list.new("a", ["b", "c"])
    == non_empty_list.append(
      non_empty_list.single("a"),
      non_empty_list.new("b", ["c"]),
    )
}

pub fn append_list_test() {
  assert non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.append_list([5, 6, 7])
    == non_empty_list.new(1, [2, 3, 4, 5, 6, 7])

  assert non_empty_list.single("a")
    |> non_empty_list.append_list(["b", "c"])
    == non_empty_list.new("a", ["b", "c"])

  assert non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.append_list([])
    == non_empty_list.new(1, [2, 3, 4])

  assert non_empty_list.append_list(non_empty_list.single("a"), [])
    == non_empty_list.single("a")
}

pub fn drop_test() {
  assert [3, 4]
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(2)

  assert [4]
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(3)

  assert [1, 2, 3, 4]
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(0)

  assert [1, 2, 3, 4]
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(-1)

  assert []
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(4)

  assert []
    == non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.drop(5)
}

pub fn flat_map_test() {
  assert non_empty_list.new(1, [2, 3, 4, 5, 6])
    == non_empty_list.new(1, [3, 5])
    |> non_empty_list.flat_map(fn(x) { non_empty_list.new(x, [x + 1]) })

  assert non_empty_list.new(1, [3, 5])
    == non_empty_list.new(1, [3, 5])
    |> non_empty_list.flat_map(fn(x) { non_empty_list.single(x) })
}

pub fn flatten_test() {
  assert non_empty_list.single(1)
    |> non_empty_list.new([
      non_empty_list.new(2, [3, 4]),
      non_empty_list.single(5),
    ])
    |> non_empty_list.flatten
    == non_empty_list.new(1, [2, 3, 4, 5])

  assert non_empty_list.flatten(
      non_empty_list.new(non_empty_list.new(1, [2, 3]), []),
    )
    == non_empty_list.new(1, [2, 3])
}

pub fn from_list_test() {
  let assert Ok(value) = non_empty_list.from_list([1, 2, 3, 4])
  assert value == non_empty_list.new(1, [2, 3, 4])

  let assert Ok(value) = non_empty_list.from_list(["a"])
  assert value == non_empty_list.single("a")

  let assert Error(value) = non_empty_list.from_list([])
  assert value == Nil
}

pub fn group_test() {
  assert non_empty_list.group(non_empty_list.new(1, []), by: fn(x) { x * 4 })
    == dict.from_list([#(4, non_empty_list.new(1, []))])

  assert non_empty_list.group(
      non_empty_list.new(Ok(3), [Error("Wrong"), Ok(200), Ok(73)]),
      by: fn(i) {
        case i {
          Ok(_) -> "Successful"
          Error(_) -> "Failed"
        }
      },
    )
    == dict.from_list([
      #("Failed", NonEmptyList(Error("Wrong"), [])),
      #("Successful", NonEmptyList(Ok(73), [Ok(200), Ok(3)])),
    ])

  assert non_empty_list.group(non_empty_list.new(1, [2, 3, 4, 5]), by: fn(i) {
      i - i / 3 * 3
    })
    == dict.from_list([
      #(0, NonEmptyList(3, [])),
      #(1, NonEmptyList(4, [1])),
      #(2, NonEmptyList(5, [2])),
    ])
}

pub fn index_map_test() {
  assert non_empty_list.index_map(
      non_empty_list.new("a", ["b", "c"]),
      fn(index, letter) { #(index, letter) },
    )
    == non_empty_list.new(#(0, "a"), [#(1, "b"), #(2, "c")])
}

pub fn intersperse_test() {
  assert non_empty_list.intersperse(
      non_empty_list.new("a", ["b", "c"]),
      with: "z",
    )
    == non_empty_list.new("a", ["z", "b", "z", "c"])

  assert non_empty_list.intersperse(non_empty_list.single(1), 2)
    == non_empty_list.single(1)
}

pub fn last_test() {
  assert non_empty_list.last(non_empty_list.new(1, [2, 3, 4])) == 4

  assert non_empty_list.last(non_empty_list.single(1)) == 1
}

pub fn length_test() {
  assert non_empty_list.length(non_empty_list.new(1, [])) == 1

  assert non_empty_list.length(non_empty_list.new(1, [2, 3, 4])) == 4
}

pub fn map_test() {
  assert non_empty_list.map(non_empty_list.new(1, [2, 3, 4]), fn(x) { x + 1 })
    == non_empty_list.new(2, [3, 4, 5])
}

pub fn map2_test() {
  assert non_empty_list.map2(
      non_empty_list.new(1, [2, 3]),
      non_empty_list.new(4, [5, 6]),
      int.add,
    )
    == non_empty_list.new(5, [7, 9])

  assert non_empty_list.map2(
      non_empty_list.new(1, [2, 3]),
      non_empty_list.new("a", ["b"]),
      pair.new,
    )
    == non_empty_list.new(#(1, "a"), [#(2, "b")])

  assert non_empty_list.map2(
      non_empty_list.new(1, [2]),
      non_empty_list.new("a", ["b", "c"]),
      pair.new,
    )
    == non_empty_list.new(#(1, "a"), [#(2, "b")])

  assert non_empty_list.map2(
      non_empty_list.single(1),
      non_empty_list.new("a", ["b", "c"]),
      pair.new,
    )
    == non_empty_list.single(#(1, "a"))
}

pub fn map_fold_test() {
  assert non_empty_list.map_fold(
      non_empty_list.new(1, [2, 3]),
      from: 100,
      with: fn(memo, i) { #(memo + i, i * 2) },
    )
    == #(106, non_empty_list.new(2, [4, 6]))

  assert non_empty_list.map_fold(
      non_empty_list.new(1, [2, 3]),
      from: 100,
      with: fn(memo, i) { #(memo - i, i * memo) },
    )
    == #(94, non_empty_list.new(100, [198, 291]))
}

pub fn new_test() {
  assert non_empty_list.new(1, [2, 3, 4]) == NonEmptyList(1, [2, 3, 4])

  assert non_empty_list.new("a", []) == NonEmptyList("a", [])
}

pub fn prepend_test() {
  assert non_empty_list.single(4)
    |> non_empty_list.prepend(3)
    |> non_empty_list.prepend(2)
    |> non_empty_list.prepend(1)
    == non_empty_list.new(1, [2, 3, 4])
}

pub fn reduce_test() {
  assert non_empty_list.reduce(non_empty_list.new(1, [2, 3, 4]), fn(acc, x) {
      acc + x
    })
    == 10

  assert non_empty_list.reduce(non_empty_list.new(10, [1, 2, 3, 4]), fn(acc, x) {
      acc - x
    })
    == 0
}

pub fn rest_test() {
  assert non_empty_list.rest(non_empty_list.new(1, [2, 3, 4])) == [2, 3, 4]

  assert non_empty_list.rest(non_empty_list.single("a")) == []
}

pub fn reverse_test() {
  assert non_empty_list.reverse(non_empty_list.new(1, [2, 3, 4]))
    == non_empty_list.new(4, [3, 2, 1])

  assert non_empty_list.reverse(non_empty_list.single("a"))
    == non_empty_list.single("a")
}

pub fn scan_test() {
  assert non_empty_list.scan(
      non_empty_list.new(1, [2, 3, 4]),
      from: 100,
      with: fn(acc, i) { acc + i },
    )
    == non_empty_list.new(101, [103, 106, 110])

  assert non_empty_list.scan(
      non_empty_list.single(1),
      from: 100,
      with: fn(acc, i) { acc + i },
    )
    == non_empty_list.single(101)
}

pub fn shuffle_test() {
  assert non_empty_list.shuffle(non_empty_list.single("a"))
    == non_empty_list.single("a")

  let shuffled =
    non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.shuffle
    |> non_empty_list.to_list

  assert list.contains(shuffled, 1) == True

  assert list.contains(shuffled, 1) == True

  assert list.contains(shuffled, 3) == True

  assert list.contains(shuffled, 4) == True

  assert list.length(shuffled) == 4
}

pub fn single_test() {
  assert non_empty_list.single(1) == non_empty_list.new(1, [])
}

pub fn sort_test() {
  assert non_empty_list.sort(non_empty_list.single(1), by: int.compare)
    == non_empty_list.single(1)

  assert non_empty_list.sort(
      non_empty_list.new(4, [1, 4, 3, 2, 6, 5]),
      by: int.compare,
    )
    == non_empty_list.new(1, [2, 3, 4, 4, 5, 6])
}

pub fn string_zip_test() {
  let assert Error(value) =
    non_empty_list.strict_zip(
      non_empty_list.new(1, [2, 3]),
      with: non_empty_list.single("a"),
    )
  assert value == Nil

  let assert Error(value) =
    non_empty_list.strict_zip(
      non_empty_list.single(1),
      with: non_empty_list.new("a", ["b", "c"]),
    )
  assert value == Nil

  let assert Ok(value) =
    non_empty_list.strict_zip(
      non_empty_list.new(1, [2, 3]),
      with: non_empty_list.new("a", ["b", "c"]),
    )
  assert value == non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")])
}

pub fn take_test() {
  assert non_empty_list.take(non_empty_list.new(1, [2, 3, 4]), 2) == [1, 2]

  assert non_empty_list.take(non_empty_list.new(1, [2, 3, 4]), 9)
    == [1, 2, 3, 4]
}

pub fn to_list_test() {
  assert non_empty_list.to_list(non_empty_list.new(1, [2, 3, 4]))
    == [1, 2, 3, 4]

  assert non_empty_list.to_list(non_empty_list.single("a")) == ["a"]
}

pub fn unique_test() {
  assert non_empty_list.unique(
      non_empty_list.new(1, [2, 2, 3, 1, 2, 4, 2, 3, 4, 4]),
    )
    == non_empty_list.new(1, [2, 3, 4])

  assert non_empty_list.unique(non_empty_list.single("a"))
    == non_empty_list.single("a")
}

pub fn unzip_test() {
  assert non_empty_list.unzip(
      non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")]),
    )
    == #(non_empty_list.new(1, [2, 3]), non_empty_list.new("a", ["b", "c"]))
}

pub fn zip_test() {
  assert non_empty_list.zip(
      non_empty_list.new(1, [2, 3]),
      with: non_empty_list.single("a"),
    )
    == non_empty_list.single(#(1, "a"))

  assert non_empty_list.zip(
      non_empty_list.single(1),
      with: non_empty_list.new("a", ["b", "c"]),
    )
    == non_empty_list.single(#(1, "a"))

  assert non_empty_list.zip(
      non_empty_list.new(1, [2, 3]),
      with: non_empty_list.new("a", ["b", "c"]),
    )
    == non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")])
}
