open Core.Std

type t = {
  lesson_id: int;
  order: int;
  person_id: string;
  support: bool option;
} with fields, sexp

let create_test_records lessons people =
  let lesson_table = Int.Table.create () in

  List.iter
    ~f:(fun lesson ->
          let result = Hashtbl.add lesson_table
            ~key:(Lesson.id lesson) ~data:(Lesson.min_assist lesson) in
          match result with
          | `Ok -> ()
          | `Duplicate -> failwith "lesson_id was duplicated"
        ) lessons;

  let applications =
    List.fold_left ~f:(
      fun a person ->
        let apps = 
          List.mapi ~f:(fun i lesson_id ->
              let can_support = 
                match Hashtbl.find lesson_table lesson_id with
                | Some x when x = 0 -> None
                | Some _ -> Some(Random.int 15 = 0)
                | None -> failwith "Failed to find min_assist"
              in
              Fields.create
                ~lesson_id:lesson_id
                ~order:(i + 1)
                ~person_id:(Person.id person)
                ~support:can_support
          ) @@ Person.lessons person
        in
        List.append apps a
    ) ~init:[] people
  in
  List.sort
    ~cmp:(fun a b -> Pervasives.compare a.lesson_id b.lesson_id)
    @@ List.rev applications
