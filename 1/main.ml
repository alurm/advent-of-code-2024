let scan_line h = Scanf.bscanf_opt h "%d %d\n"

let scan h =
  let open Dynarray in
  let left, right = create(), create() in
  let rec loop() =
    match scan_line h @@ fun l r ->
      add_last left l;
      add_last right r;
    with
    | None -> ()
    | Some() -> loop()
  in
  loop();
  to_array left, to_array right

let main() =
  let open Array in
  let l, r = In_channel.with_open_bin "input.txt" @@ fun h -> scan @@ Scanf.Scanning.from_channel h in
  let sort = sort compare in
  sort l;
  sort r;
  let pairs = combine l r in
  let diffs = map(fun (x, y) -> Int.abs(x - y)) pairs in
  Printf.printf "%d\n" @@ fold_left(+) 0 diffs

let _ = main()
