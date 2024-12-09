let find_or_default h k default =
  match Hashtbl.find_opt h k with
  | None -> default
  | Some v -> v

let occurrence_map_of_array arr =
  let h = Hashtbl.create 0 in
  Array.iter (fun k ->
    Hashtbl.replace h k @@
    (find_or_default h k 0) + 1
  ) arr;
  h

let main() =
  let nums, occur = Lib.scan_path "input.txt" in
  let occur = occurrence_map_of_array occur in
  let sum = Array.fold_left(fun acc n ->
      acc + n * (find_or_default occur n 0)
  ) 0 nums in
  Printf.printf "%d\n" sum

let _ = main()
