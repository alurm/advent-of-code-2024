let scan_part h = Scanf.bscanf_opt h "%d "

let scan h =
  let open Dynarray in
  let a = create() in
  let rec loop() =
    match scan_part h @@ fun n -> add_last a n
    with
    | None -> ()
    | Some() -> loop()
  in
  loop();
  to_array a

let scan_path p =
  In_channel.with_open_bin p @@ Fun.compose scan Scanf.Scanning.from_channel

let digits = Fun.compose String.length string_of_int

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n ->
     let b = pow a (n / 2) in
     b * b * (if n mod 2 = 0 then 1 else a)

let transition = function
  | 0 -> [| 1 |]
  | n when ((digits n) mod 2) = 0 ->
     let sep = pow 10 @@ (digits n) / 2 in
     [| n / sep; n mod sep |]
  | n -> [| n * 2024 |]

let transition_pair (x, y) = (transition x, y)

let pair_of_array_to_array_of_pairs (a, count) =
  match a with
  | [| n |] -> [| n, count |]
  | [| x; y |] -> [| x, count; y, count |]

let p = Array.iter @@ fun (x, y) -> Printf.printf "%d %d\n" x y

let number a = Array.map (fun x -> x, 1) a

let flatten arrays =
  let d = Dynarray.create() in
  Array.iter (Dynarray.append_array d) arrays;
  Dynarray.to_array d

let transition_array a =
  flatten @@ Array.map (Fun.compose pair_of_array_to_array_of_pairs transition_pair) a

let find_or_default h k default =
  match Hashtbl.find_opt h k with
  | None -> default
  | Some v -> v

let hash a =
  let h = Hashtbl.create 0 in
  Array.iter (fun (n, count) ->
    Hashtbl.replace h n @@ (find_or_default h n 0) + count
  ) a;
  h

let array_of_hash h =
  let length = Hashtbl.length h in
  let arr = Array.make length (0, 0) in
  let i = ref 0 in
  Hashtbl.iter (fun k v ->
    arr.(!i) <- (k, v);
    i := !i + 1;
  ) h;
  arr

let rec loop init = function
  | 0 -> init
  | n -> loop (array_of_hash @@ hash @@ transition_array @@ init) (n - 1)

let sum a =
  Array.fold_left (fun sum (a, b) -> sum + b) 0 a

let main() =
  let a1 = scan_path "input.txt" in
  Array.iter (Printf.printf "%d\n") a1;
  let a = number a1 in
  let r = loop a 75 in
  p r;
  Printf.printf "%d\n" @@ sum @@ r
  (* p @@ array_of_hash @@ hash @@ transition_array @@ number @@ transition 2024 *)

let _ = main()
