open Core.Std

ignore @@ Random.self_init ()

let () =
  let lessons = Lesson.create_test_records 1 6 110 in
  let people = Person.create_test_records 4 32 10 lessons in
  let applications = Application.create_test_records lessons people in
  Out_channel.with_file "lessons.csv" ~f:(fun out ->
    List.iter ~f:(fun l -> 
      let line =
        Printf.sprintf "%d,%s,%d,%d,%s,%d,%d,%s"
          (Lesson.id l)
          (Lesson.name l)
          (Lesson.min_grade l)
          (Lesson.max_grade l)
          (Date.to_string @@ Lesson.date l)
          (Lesson.capacity l)
          (Lesson.min_assist l)
          (match Lesson.support l with Some x -> x | None -> "") in
      Out_channel.output_string out line;
      Out_channel.newline out
    ) lessons
  );
  Out_channel.with_file "applications.csv" ~f:(fun out ->
    List.iter ~f:(fun a -> 
      let line =
        Printf.sprintf "%d,%d,%s,%s"
          (Application.lesson_id a)
          (Application.order a)
          (Application.person_id a)
          (match Application.support a with
            | Some x -> String.uppercase @@ string_of_bool x
            | None -> ""
          ) in
      Out_channel.output_string out line;
      Out_channel.newline out
    ) applications
  );
  Capacity_check.print lessons applications
