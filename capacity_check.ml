open Core.Std

let create_table lessons applications =
  let ltbl = Int.Table.create () in
  List.iter ~f:(fun x ->
    Hashtbl.replace ltbl ~key:(Lesson.id x) ~data:((Lesson.capacity x), 0, 0, 0)
  ) lessons;
  List.iter ~f:(fun app ->
    let order = Application.order app in
    if order <= 3 then
      let lid = Application.lesson_id app in
      match Hashtbl.find ltbl lid with
      | Some (cap, num_of_top_ones, num_of_top_twos, num_of_top_threes) ->
        if order = 1 then
          Hashtbl.replace ltbl ~key:lid
              ~data:(cap, num_of_top_ones + 1, num_of_top_twos + 1, num_of_top_threes + 1)
        else if order = 2 then
          Hashtbl.replace ltbl ~key:lid
              ~data:(cap, num_of_top_ones, num_of_top_twos + 1, num_of_top_threes + 1)
        else if order = 3 then
          Hashtbl.replace ltbl ~key:lid
              ~data:(cap, num_of_top_ones, num_of_top_twos, num_of_top_threes + 1)
      | None -> failwith (Printf.sprintf "%d doesn't exist" lid)
  ) applications;
  ltbl

let print lessons applications =
  let ltbl = create_table lessons applications in
  print_endline "Priority:1";
  Hashtbl.iter ~f:(fun ~key:lid ~data:(cap, ones, twos, threes) ->
    if cap < ones then
      Printf.printf "%3d: cap:%3d, sum:%3d\n" lid cap ones
  ) ltbl;
  print_endline "Priority:1 + 2";
  Hashtbl.iter ~f:(fun ~key:lid ~data:(cap, ones, twos, threes) ->
    if cap >= ones && cap < twos then
      Printf.printf "%3d: cap:%3d, sum:%3d\n" lid cap twos
  ) ltbl;
  print_endline "Priority:1 + 2 + 3";
  Hashtbl.iter ~f:(fun ~key:lid ~data:(cap, ones, twos, threes) ->
    if cap >= twos && cap < threes then
      Printf.printf "%3d: cap:%3d, sum:%3d\n" lid cap threes
  ) ltbl

