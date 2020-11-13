:- module(file_utils).
:- interface.
:- import_module io, maybe, list.

:- pred read_line_from_file(string::in, maybe(string)::out,
    io::di, io::uo) is det.
:- pred read_lines_from_file(string::in, maybe(list(string))::out,
    io::di, io::uo) is det.

:- implementation.
:- import_module string.

read_line_from_file(File, StringRes, !IO) :-
    open_input(File, OpenResult, !IO),
    (
	OpenResult = ok(Stream),
	read_line_as_string(Stream, ReadResult, !IO),
	(
	    ReadResult = ok(String) -> StringRes = yes(strip(String));
	    StringRes = no
	)
    ;
     %     OpenResult = eof, StringRes = eof;
	OpenResult = error(_), StringRes = no).

read_lines_from_file(File, LinesRes, !IO) :-
    open_input(File, OpenResult, !IO),
    (
	OpenResult = ok(Stream),
	read_all_lines(Stream, Lines, !IO), LinesRes = yes(Lines)
    ;
	OpenResult = error(_), LinesRes = no
    ).

:- pred read_all_lines(io.text_input_stream::in, list(string)::out,
    io::di, io::uo) is det.
read_all_lines(Stream, Lines, !IO) :-
    read_line_as_string(Stream, ReadResult, !IO),
    (
	ReadResult = ok(String) ->
	read_all_lines(Stream, Rest, !IO), Lines = [strip(String) | Rest]
    ;
	Lines = []
    ).

