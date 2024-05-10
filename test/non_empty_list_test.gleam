import gleam/int
import gleam/list
import gleam/pair
import gleeunit
import gleeunit/should
import non_empty_list.{ListWasEmpty, NonEmptyList}

pub fn main() {
  gleeunit.main()
}

pub fn append_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.append(non_empty_list.new(5, [6, 7]))
  |> should.equal(non_empty_list.new(1, [2, 3, 4, 5, 6, 7]))

  non_empty_list.single("a")
  |> non_empty_list.append(non_empty_list.new("b", ["c"]))
  |> should.equal(non_empty_list.new("a", ["b", "c"]))
}

pub fn append_list_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.append_list([5, 6, 7])
  |> should.equal(non_empty_list.new(1, [2, 3, 4, 5, 6, 7]))

  non_empty_list.single("a")
  |> non_empty_list.append_list(["b", "c"])
  |> should.equal(non_empty_list.new("a", ["b", "c"]))

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.append_list([])
  |> should.equal(non_empty_list.new(1, [2, 3, 4]))

  non_empty_list.single("a")
  |> non_empty_list.append_list([])
  |> should.equal(non_empty_list.single("a"))
}

pub fn drop_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(2)
  |> should.equal([3, 4])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(3)
  |> should.equal([4])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(0)
  |> should.equal([1, 2, 3, 4])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(-1)
  |> should.equal([1, 2, 3, 4])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(4)
  |> should.equal([])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.drop(5)
  |> should.equal([])
}

pub fn flat_map_test() {
  non_empty_list.new(1, [3, 5])
  |> non_empty_list.flat_map(fn(x) { non_empty_list.new(x, [x + 1]) })
  |> should.equal(non_empty_list.new(1, [2, 3, 4, 5, 6]))

  non_empty_list.new(1, [3, 5])
  |> non_empty_list.flat_map(fn(x) { non_empty_list.single(x) })
  |> should.equal(non_empty_list.new(1, [3, 5]))
}

pub fn flatten_test() {
  non_empty_list.single(1)
  |> non_empty_list.new([
    non_empty_list.new(2, [3, 4]),
    non_empty_list.single(5),
  ])
  |> non_empty_list.flatten
  |> should.equal(non_empty_list.new(1, [2, 3, 4, 5]))

  non_empty_list.new(non_empty_list.new(1, [2, 3]), [])
  |> non_empty_list.flatten
  |> should.equal(non_empty_list.new(1, [2, 3]))
}

pub fn from_list_test() {
  [1, 2, 3, 4]
  |> non_empty_list.from_list
  |> should.be_ok
  |> should.equal(non_empty_list.new(1, [2, 3, 4]))

  ["a"]
  |> non_empty_list.from_list
  |> should.be_ok
  |> should.equal(non_empty_list.single("a"))

  []
  |> non_empty_list.from_list
  |> should.be_error
  |> should.equal(ListWasEmpty)
}

pub fn index_map_test() {
  non_empty_list.new("a", ["b", "c"])
  |> non_empty_list.index_map(fn(index, letter) { #(index, letter) })
  |> should.equal(non_empty_list.new(#(0, "a"), [#(1, "b"), #(2, "c")]))
}

pub fn intersperse_test() {
  non_empty_list.new("a", ["b", "c"])
  |> non_empty_list.intersperse(with: "z")
  |> should.equal(non_empty_list.new("a", ["z", "b", "z", "c"]))

  non_empty_list.single(1)
  |> non_empty_list.intersperse(2)
  |> should.equal(non_empty_list.new(1, [2]))
}

pub fn last_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.last
  |> should.equal(4)

  non_empty_list.single(1)
  |> non_empty_list.last
  |> should.equal(1)
}

pub fn map_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.map(fn(x) { x + 1 })
  |> should.equal(non_empty_list.new(2, [3, 4, 5]))
}

pub fn map2_test() {
  non_empty_list.new(1, [2, 3])
  |> non_empty_list.map2(non_empty_list.new(4, [5, 6]), int.add)
  |> should.equal(non_empty_list.new(5, [7, 9]))

  non_empty_list.new(1, [2, 3])
  |> non_empty_list.map2(non_empty_list.new("a", ["b"]), pair.new)
  |> should.equal(non_empty_list.new(#(1, "a"), [#(2, "b")]))

  non_empty_list.new(1, [2])
  |> non_empty_list.map2(non_empty_list.new("a", ["b", "c"]), pair.new)
  |> should.equal(non_empty_list.new(#(1, "a"), [#(2, "b")]))

  non_empty_list.single(1)
  |> non_empty_list.map2(non_empty_list.new("a", ["b", "c"]), pair.new)
  |> should.equal(non_empty_list.single(#(1, "a")))
}

pub fn map_fold_test() {
  non_empty_list.new(1, [2, 3])
  |> non_empty_list.map_fold(from: 100, with: fn(memo, i) { #(memo + i, i * 2) })
  |> should.equal(#(106, non_empty_list.new(2, [4, 6])))

  non_empty_list.new(1, [2, 3])
  |> non_empty_list.map_fold(from: 100, with: fn(memo, i) {
    #(memo - i, i * memo)
  })
  |> should.equal(#(94, non_empty_list.new(100, [198, 291])))
}

pub fn new_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> should.equal(NonEmptyList(1, [2, 3, 4]))

  non_empty_list.new("a", [])
  |> should.equal(NonEmptyList("a", []))
}

pub fn prepend_test() {
  non_empty_list.single(4)
  |> non_empty_list.prepend(3)
  |> non_empty_list.prepend(2)
  |> non_empty_list.prepend(1)
  |> should.equal(non_empty_list.new(1, [2, 3, 4]))
}

pub fn reduce_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.reduce(fn(acc, x) { acc + x })
  |> should.equal(10)

  non_empty_list.new(10, [1, 2, 3, 4])
  |> non_empty_list.reduce(fn(acc, x) { acc - x })
  |> should.equal(0)
}

pub fn rest_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.rest
  |> should.equal([2, 3, 4])

  non_empty_list.single("a")
  |> non_empty_list.rest
  |> should.equal([])
}

pub fn reverse_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.reverse
  |> should.equal(non_empty_list.new(4, [3, 2, 1]))

  non_empty_list.single("a")
  |> non_empty_list.reverse
  |> should.equal(non_empty_list.single("a"))
}

pub fn scan_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.scan(from: 100, with: fn(acc, i) { acc + i })
  |> should.equal(non_empty_list.new(101, [103, 106, 110]))

  non_empty_list.single(1)
  |> non_empty_list.scan(from: 100, with: fn(acc, i) { acc + i })
  |> should.equal(non_empty_list.single(101))
}

pub fn shuffle_test() {
  non_empty_list.single("a")
  |> non_empty_list.shuffle
  |> should.equal(non_empty_list.single("a"))

  let shuffled =
    non_empty_list.new(1, [2, 3, 4])
    |> non_empty_list.shuffle
    |> non_empty_list.to_list

  shuffled
  |> list.contains(1)
  |> should.equal(True)

  shuffled
  |> list.contains(1)
  |> should.equal(True)

  shuffled
  |> list.contains(3)
  |> should.equal(True)

  shuffled
  |> list.contains(4)
  |> should.equal(True)

  shuffled
  |> list.length
  |> should.equal(4)
}

pub fn single_test() {
  non_empty_list.single(1)
  |> should.equal(non_empty_list.new(1, []))
}

pub fn sort_test() {
  non_empty_list.single(1)
  |> non_empty_list.sort(by: int.compare)
  |> should.equal(non_empty_list.single(1))

  non_empty_list.new(4, [1, 4, 3, 2, 6, 5])
  |> non_empty_list.sort(by: int.compare)
  |> should.equal(non_empty_list.new(1, [2, 3, 4, 4, 5, 6]))
}

pub fn string_zip_test() {
  non_empty_list.new(1, [2, 3])
  |> non_empty_list.strict_zip(with: non_empty_list.single("a"))
  |> should.be_error
  |> should.equal(Nil)

  non_empty_list.single(1)
  |> non_empty_list.strict_zip(with: non_empty_list.new("a", ["b", "c"]))
  |> should.be_error
  |> should.equal(Nil)

  non_empty_list.new(1, [2, 3])
  |> non_empty_list.strict_zip(with: non_empty_list.new("a", ["b", "c"]))
  |> should.be_ok
  |> should.equal(non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")]))
}

pub fn take_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.take(2)
  |> should.equal([1, 2])

  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.take(9)
  |> should.equal([1, 2, 3, 4])
}

pub fn to_list_test() {
  non_empty_list.new(1, [2, 3, 4])
  |> non_empty_list.to_list
  |> should.equal([1, 2, 3, 4])

  non_empty_list.single("a")
  |> non_empty_list.to_list
  |> should.equal(["a"])
}

pub fn unique_test() {
  non_empty_list.new(1, [2, 2, 3, 1, 2, 4, 2, 3, 4, 4])
  |> non_empty_list.unique
  |> should.equal(non_empty_list.new(1, [2, 3, 4]))

  non_empty_list.single("a")
  |> non_empty_list.unique
  |> should.equal(non_empty_list.single("a"))
}

pub fn unzip_test() {
  non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")])
  |> non_empty_list.unzip
  |> should.equal(#(
    non_empty_list.new(1, [2, 3]),
    non_empty_list.new("a", ["b", "c"]),
  ))
}

pub fn zip_test() {
  non_empty_list.new(1, [2, 3])
  |> non_empty_list.zip(with: non_empty_list.single("a"))
  |> should.equal(non_empty_list.single(#(1, "a")))

  non_empty_list.single(1)
  |> non_empty_list.zip(with: non_empty_list.new("a", ["b", "c"]))
  |> should.equal(non_empty_list.single(#(1, "a")))

  non_empty_list.new(1, [2, 3])
  |> non_empty_list.zip(with: non_empty_list.new("a", ["b", "c"]))
  |> should.equal(non_empty_list.new(#(1, "a"), [#(2, "b"), #(3, "c")]))
}
