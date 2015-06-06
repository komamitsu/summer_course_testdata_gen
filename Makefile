all: natsu_testdata
 
srcs=lesson.mli lesson.ml person.mli person.ml application.mli application.ml capacity_check.mli capacity_check.ml main.ml

natsu_testdata: ${srcs}
	ocamlfind opt -thread -syntax camlp4o -package 'core,fieldslib.syntax,sexplib.syntax' -linkpkg -o natsu_testdata ${srcs}
