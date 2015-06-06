type t

val lesson_id: t -> int
val order: t -> int
val person_id: t -> string
val support: t -> bool option
val create_test_records: Lesson.t list -> Person.t list -> t list

