
(* The type of tokens. *)

type token = 
  | UL_VOID
  | UL_VIR
  | UL_RIGHT_BRACE
  | UL_PTVIR
  | UL_PT
  | UL_PAROUV
  | UL_PARFER
  | UL_PACKAGE
  | UL_LEFT_BRACE
  | UL_INTERFACE
  | UL_INT
  | UL_IDENT_PACKAGE of (string)
  | UL_IDENT_INTERFACE of (string)
  | UL_FIN
  | UL_EXTENDS
  | UL_BOOLEAN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val package: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
