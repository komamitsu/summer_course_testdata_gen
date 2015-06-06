type t

val id: t -> string
val grade: t -> int
val class_id: t -> int
val lessons: t -> int list
val create_test_records: int -> int -> int -> Lesson.t list -> t list
