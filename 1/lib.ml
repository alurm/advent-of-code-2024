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

let scan_path path =
  In_channel.with_open_bin path @@ fun h -> scan @@ Scanf.Scanning.from_channel h
