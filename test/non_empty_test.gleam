import glacier
import glacier/should
import non_empty.{ListWasEmpty, ListWasTooShort, NonEmptyList}
import gleam/list
import gleam/int

pub fn main() {
  glacier.main()
}

pub fn append_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.append(non_empty.new(5, [6, 7]))
  |> should.equal(non_empty.new(1, [2, 3, 4, 5, 6, 7]))

  non_empty.single("a")
  |> non_empty.append(non_empty.new("b", ["c"]))
  |> should.equal(non_empty.new("a", ["b", "c"]))
}

pub fn append_list_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.append_list([5, 6, 7])
  |> should.equal(non_empty.new(1, [2, 3, 4, 5, 6, 7]))

  non_empty.single("a")
  |> non_empty.append_list(["b", "c"])
  |> should.equal(non_empty.new("a", ["b", "c"]))

  non_empty.new(1, [2, 3, 4])
  |> non_empty.append_list([])
  |> should.equal(non_empty.new(1, [2, 3, 4]))

  non_empty.single("a")
  |> non_empty.append_list([])
  |> should.equal(non_empty.single("a"))
}

pub fn at_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.at(0)
  |> should.be_ok
  |> should.equal(1)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.at(2)
  |> should.be_ok
  |> should.equal(3)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.at(-1)
  |> should.be_error
  |> should.equal(Nil)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.at(4)
  |> should.be_error
  |> should.equal(Nil)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.at(5)
  |> should.be_error
  |> should.equal(Nil)
}

pub fn contains_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.contains(any: 1)
  |> should.equal(True)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.contains(any: 2)
  |> should.equal(True)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.contains(any: 3)
  |> should.equal(True)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.contains(any: 4)
  |> should.equal(True)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.contains(any: 5)
  |> should.equal(False)

  non_empty.single(1)
  |> non_empty.contains(any: 1)
  |> should.equal(True)

  non_empty.single(1)
  |> non_empty.contains(any: 5)
  |> should.equal(False)
}

pub fn count_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.count
  |> should.equal(4)

  non_empty.single("a")
  |> non_empty.count
  |> should.equal(1)
}

pub fn drop_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(2)
  |> should.equal([3, 4])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(3)
  |> should.equal([4])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(0)
  |> should.equal([1, 2, 3, 4])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(-1)
  |> should.equal([1, 2, 3, 4])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(4)
  |> should.equal([])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.drop(5)
  |> should.equal([])
}

pub fn find_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.find(fn(x) { x > 2 })
  |> should.be_ok
  |> should.equal(3)

  non_empty.new(1, [2, 3, 4])
  |> non_empty.find(fn(x) { x < 0 })
  |> should.be_error
  |> should.equal(Nil)
}

pub fn find_map_test() {
  non_empty.new([], [[1, 2], [], [3]])
  |> non_empty.find_map(list.first)
  |> should.be_ok
  |> should.equal(1)

  non_empty.new([], [[], [], []])
  |> non_empty.find_map(list.first)
  |> should.be_error
  |> should.equal(Nil)
}

pub fn flat_map_test() {
  non_empty.new(1, [3, 5])
  |> non_empty.flat_map(fn(x) { non_empty.new(x, [x + 1]) })
  |> should.equal(non_empty.new(1, [2, 3, 4, 5, 6]))

  non_empty.new(1, [3, 5])
  |> non_empty.flat_map(fn(x) { non_empty.single(x) })
  |> should.equal(non_empty.new(1, [3, 5]))
}

pub fn flatten_test() {
  non_empty.single(1)
  |> non_empty.new([non_empty.new(2, [3, 4]), non_empty.single(5)])
  |> non_empty.flatten
  |> should.equal(non_empty.new(1, [2, 3, 4, 5]))

  non_empty.new(non_empty.new(1, [2, 3]), [])
  |> non_empty.flatten
  |> should.equal(non_empty.new(1, [2, 3]))
}

pub fn from_list_test() {
  [1, 2, 3, 4]
  |> non_empty.from_list
  |> should.be_ok
  |> should.equal(non_empty.new(1, [2, 3, 4]))

  ["a"]
  |> non_empty.from_list
  |> should.be_ok
  |> should.equal(non_empty.single("a"))

  []
  |> non_empty.from_list
  |> should.be_error
  |> should.equal(ListWasEmpty)
}

pub fn index_map_test() {
  non_empty.new("a", ["b", "c"])
  |> non_empty.index_map(fn(index, letter) { #(index, letter) })
  |> should.equal(non_empty.new(#(0, "a"), [#(1, "b"), #(2, "c")]))
}

pub fn intersperse_test() {
  non_empty.new("a", ["b", "c"])
  |> non_empty.intersperse(with: "z")
  |> should.equal(non_empty.new("a", ["z", "b", "z", "c"]))

  non_empty.single(1)
  |> non_empty.intersperse(2)
  |> should.equal(non_empty.new(1, [2]))
}

pub fn last_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.last
  |> should.equal(4)

  non_empty.single(1)
  |> non_empty.last
  |> should.equal(1)
}

pub fn map_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.map(fn(x) { x + 1 })
  |> should.equal(non_empty.new(2, [3, 4, 5]))
}

pub fn map_fold_test() {
  non_empty.new(1, [2, 3])
  |> non_empty.map_fold(from: 100, with: fn(memo, i) { #(memo + i, i * 2) })
  |> should.equal(#(106, non_empty.new(2, [4, 6])))

  non_empty.new(1, [2, 3])
  |> non_empty.map_fold(from: 100, with: fn(memo, i) { #(memo - i, i * memo) })
  |> should.equal(#(94, non_empty.new(100, [198, 291])))
}

pub fn new_test() {
  non_empty.new(1, [2, 3, 4])
  |> should.equal(NonEmptyList(1, [2, 3, 4]))

  non_empty.new("a", [])
  |> should.equal(NonEmptyList("a", []))
}

pub fn prepend_test() {
  non_empty.single(4)
  |> non_empty.prepend(3)
  |> non_empty.prepend(2)
  |> non_empty.prepend(1)
  |> should.equal(non_empty.new(1, [2, 3, 4]))
}

pub fn reduce_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.reduce(fn(acc, x) { acc + x })
  |> should.equal(10)

  non_empty.new(10, [1, 2, 3, 4])
  |> non_empty.reduce(fn(acc, x) { acc - x })
  |> should.equal(0)
}

pub fn rest_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.rest
  |> should.equal([2, 3, 4])

  non_empty.single("a")
  |> non_empty.rest
  |> should.equal([])
}

pub fn reverse_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.reverse
  |> should.equal(non_empty.new(4, [3, 2, 1]))

  non_empty.single("a")
  |> non_empty.reverse
  |> should.equal(non_empty.single("a"))
}

pub fn scan_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.scan(from: 100, with: fn(acc, i) { acc + i })
  |> should.equal(non_empty.new(101, [103, 106, 110]))

  non_empty.single(1)
  |> non_empty.scan(from: 100, with: fn(acc, i) { acc + i })
  |> should.equal(non_empty.single(101))
}

pub fn shuffle_test() {
  non_empty.single("a")
  |> non_empty.shuffle
  |> should.equal(non_empty.single("a"))

  let shuffled =
    non_empty.new(1, [2, 3, 4])
    |> non_empty.shuffle

  shuffled
  |> non_empty.contains(1)
  |> should.equal(True)

  shuffled
  |> non_empty.contains(2)
  |> should.equal(True)

  shuffled
  |> non_empty.contains(3)
  |> should.equal(True)

  shuffled
  |> non_empty.contains(4)
  |> should.equal(True)

  shuffled
  |> non_empty.count
  |> should.equal(4)
}

pub fn single_test() {
  non_empty.single(1)
  |> should.equal(non_empty.new(1, []))
}

pub fn sort_test() {
  non_empty.single(1)
  |> non_empty.sort(by: int.compare)
  |> should.equal(non_empty.single(1))

  non_empty.new(4, [1, 4, 3, 2, 6, 5])
  |> non_empty.sort(by: int.compare)
  |> should.equal(non_empty.new(1, [2, 3, 4, 4, 5, 6]))
}

pub fn string_zip_test() {
  non_empty.new(1, [2, 3])
  |> non_empty.strict_zip(with: non_empty.single("a"))
  |> should.be_error
  |> should.equal(list.LengthMismatch)

  non_empty.single(1)
  |> non_empty.strict_zip(with: non_empty.new("a", ["b", "c"]))
  |> should.be_error
  |> should.equal(list.LengthMismatch)

  non_empty.new(1, [2, 3])
  |> non_empty.strict_zip(with: non_empty.new("a", ["b", "c"]))
  |> should.be_ok
  |> should.equal(non_empty.new(#(1, "a"), [#(2, "b"), #(3, "c")]))
}

pub fn take_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.take(2)
  |> should.equal([1, 2])

  non_empty.new(1, [2, 3, 4])
  |> non_empty.take(9)
  |> should.equal([1, 2, 3, 4])
}

pub fn to_list_test() {
  non_empty.new(1, [2, 3, 4])
  |> non_empty.to_list
  |> should.equal([1, 2, 3, 4])

  non_empty.single("a")
  |> non_empty.to_list
  |> should.equal(["a"])
}

pub fn unique_test() {
  non_empty.new(1, [2, 2, 3, 1, 2, 4, 2, 3, 4, 4])
  |> non_empty.unique
  |> should.equal(non_empty.new(1, [2, 3, 4]))

  non_empty.single("a")
  |> non_empty.unique
  |> should.equal(non_empty.single("a"))
}

pub fn unzip_test() {
  non_empty.new(#(1, "a"), [#(2, "b"), #(3, "c")])
  |> non_empty.unzip
  |> should.equal(#(non_empty.new(1, [2, 3]), non_empty.new("a", ["b", "c"])))
}

pub fn zip_test() {
  non_empty.new(1, [2, 3])
  |> non_empty.zip(with: non_empty.single("a"))
  |> should.equal(non_empty.single(#(1, "a")))

  non_empty.single(1)
  |> non_empty.zip(with: non_empty.new("a", ["b", "c"]))
  |> should.equal(non_empty.single(#(1, "a")))

  non_empty.new(1, [2, 3])
  |> non_empty.zip(with: non_empty.new("a", ["b", "c"]))
  |> should.equal(non_empty.new(#(1, "a"), [#(2, "b"), #(3, "c")]))
}
