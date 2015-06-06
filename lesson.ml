open Core.Std

type t = {
  id: int;
  name: string;
  min_grade: int;
  max_grade: int;
  date: Date.t;
  capacity: int;
  min_assist: int;
  support: string option
} with fields, sexp

let gen_random_range min max =
  let small = Random.int (max + 1 - min) + min in
  let large = Random.int (max + 1 - small) + small in
  (small, large)

let create_test_records grade_range_min grade_range_max n =
  let base_date = Date.create_exn ~y:2015 ~m:Month.Jul ~d:20 in
  let lessons = 
    List.fold_left ~f:(fun a i ->
      let (min_grade, max_grade) =
        gen_random_range grade_range_min grade_range_max in
      let support = 
        if (Random.int 2 = 0) then
          let (min, max) = gen_random_range grade_range_min grade_range_max in
          Some(List.fold_left ~f:(fun a x -> a ^ string_of_int x)
                ~init:"Support:" @@
                List.range ~stop:`inclusive min max)
        else
          None
      in
      let date =
        Date.add_days base_date @@ Random.int 40 in
      let cls = 
        Fields.create 
          ~id:i
          ~name:("Lesson:" ^ string_of_int i)
          ~min_grade:min_grade
          ~max_grade:max_grade
          ~date:date
          ~capacity:(Random.int 40 + 10)
          ~min_assist:(Random.int 5)
          ~support:support in
      cls::a
    ) ~init:[] @@ List.range ~stop:`inclusive 1 n
  in List.rev lessons
