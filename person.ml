open Core.Std

type t = {
  id: string;
  grade: int;
  class_id: int;
  lessons: int list;
} with fields, sexp

let gen_lessons lesson_ids n =
  let rec loop i ls xs =
    if i >= n then xs
    else
      match List.nth ls (Random.int (List.length ls)) with
      | Some l ->
        let ls = List.filter ~f:(fun x -> x <> l) ls in
        loop (i + 1) ls (l::xs)
      | None -> failwith "Failed to find lesson"
  in
  loop 0 lesson_ids []

let create_test_records num_of_classes num_of_people_per_class
                        num_of_application lessons =
  let lesson_ids = List.fold_left ~init:[]
                    ~f:(fun a x -> (Lesson.id x)::a) lessons in
  let (min_grade, max_grade) = (1, 6) in
  let (min_class_id, max_class_id) = (1, num_of_classes) in
  List.rev @@ List.fold_left ~f:(fun people grade ->
    List.fold_left ~f:(fun people class_id ->
      List.fold_left ~f:(fun people i ->
        let num_of_app = (Random.int num_of_application) + 1 in
        let selected_lessons = gen_lessons lesson_ids num_of_app in
        let id = Printf.sprintf "%d%d%02d" grade class_id i in
        let person = Fields.create ~id:id ~grade:grade
                      ~class_id:class_id ~lessons:selected_lessons in
        person::people
      ) ~init:people @@ List.range ~stop:`inclusive 1 num_of_people_per_class
    ) ~init:people @@ List.range ~stop:`inclusive min_class_id max_class_id
  ) ~init:[] @@ List.range ~stop:`inclusive min_grade max_grade

