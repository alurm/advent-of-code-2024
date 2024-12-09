let main() =
  let open Array in
  let l, r = Lib.scan_path "input.txt" in
  sort compare l;
  sort compare r;
  let pairs = combine l r in
  let diffs = map(fun (x, y) -> Int.abs(x - y)) pairs in
  let sum = fold_left(+) 0 diffs in
  Printf.printf "%d\n" sum

let _ = main()
