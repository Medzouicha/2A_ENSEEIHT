
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
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
    | UL_IDENT_PACKAGE of (
# 16 "Parser.mly"
       (string)
# 26 "Parser.ml"
  )
    | UL_IDENT_INTERFACE of (
# 17 "Parser.mly"
       (string)
# 31 "Parser.ml"
  )
    | UL_FIN
    | UL_EXTENDS
    | UL_BOOLEAN
  
end

include MenhirBasics

# 1 "Parser.mly"
  

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)


# 49 "Parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_package) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: package. *)

  | MenhirState03 : (('s, _menhir_box_package) _menhir_cell1_UL_PACKAGE _menhir_cell0_UL_IDENT_PACKAGE, _menhir_box_package) _menhir_state
    (** State 03.
        Stack shape : UL_PACKAGE UL_IDENT_PACKAGE.
        Start symbol: package. *)

  | MenhirState06 : (('s, _menhir_box_package) _menhir_cell1_UL_INTERFACE _menhir_cell0_UL_IDENT_INTERFACE, _menhir_box_package) _menhir_state
    (** State 06.
        Stack shape : UL_INTERFACE UL_IDENT_INTERFACE.
        Start symbol: package. *)

  | MenhirState08 : (('s, _menhir_box_package) _menhir_cell1_UL_IDENT_PACKAGE, _menhir_box_package) _menhir_state
    (** State 08.
        Stack shape : UL_IDENT_PACKAGE.
        Start symbol: package. *)

  | MenhirState13 : (('s, _menhir_box_package) _menhir_cell1_nomqualifie, _menhir_box_package) _menhir_state
    (** State 13.
        Stack shape : nomqualifie.
        Start symbol: package. *)

  | MenhirState17 : (('s, _menhir_box_package) _menhir_cell1_UL_INTERFACE _menhir_cell0_UL_IDENT_INTERFACE _menhir_cell0_interfaceaux1, _menhir_box_package) _menhir_state
    (** State 17.
        Stack shape : UL_INTERFACE UL_IDENT_INTERFACE interfaceaux1.
        Start symbol: package. *)

  | MenhirState23 : (('s, _menhir_box_package) _menhir_cell1_typee _menhir_cell0_UL_IDENT_PACKAGE, _menhir_box_package) _menhir_state
    (** State 23.
        Stack shape : typee UL_IDENT_PACKAGE.
        Start symbol: package. *)

  | MenhirState25 : (('s, _menhir_box_package) _menhir_cell1_typee, _menhir_box_package) _menhir_state
    (** State 25.
        Stack shape : typee.
        Start symbol: package. *)

  | MenhirState32 : (('s, _menhir_box_package) _menhir_cell1_methode, _menhir_box_package) _menhir_state
    (** State 32.
        Stack shape : methode.
        Start symbol: package. *)

  | MenhirState36 : (('s, _menhir_box_package) _menhir_cell1_packageaux2, _menhir_box_package) _menhir_state
    (** State 36.
        Stack shape : packageaux2.
        Start symbol: package. *)


and 's _menhir_cell0_interfaceaux1 = 
  | MenhirCell0_interfaceaux1 of 's * (unit)

and ('s, 'r) _menhir_cell1_methode = 
  | MenhirCell1_methode of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_nomqualifie = 
  | MenhirCell1_nomqualifie of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_packageaux2 = 
  | MenhirCell1_packageaux2 of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_typee = 
  | MenhirCell1_typee of 's * ('s, 'r) _menhir_state * (unit)

and 's _menhir_cell0_UL_IDENT_INTERFACE = 
  | MenhirCell0_UL_IDENT_INTERFACE of 's * (
# 17 "Parser.mly"
       (string)
# 122 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_UL_IDENT_PACKAGE = 
  | MenhirCell1_UL_IDENT_PACKAGE of 's * ('s, 'r) _menhir_state * (
# 16 "Parser.mly"
       (string)
# 129 "Parser.ml"
)

and 's _menhir_cell0_UL_IDENT_PACKAGE = 
  | MenhirCell0_UL_IDENT_PACKAGE of 's * (
# 16 "Parser.mly"
       (string)
# 136 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_UL_INTERFACE = 
  | MenhirCell1_UL_INTERFACE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_UL_PACKAGE = 
  | MenhirCell1_UL_PACKAGE of 's * ('s, 'r) _menhir_state

and _menhir_box_package = 
  | MenhirBox_package of (unit) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 51 "Parser.mly"
                                                                                                     ( (print_endline "interface : UL_INTERFACE UL_IDENT_INTERFACE interfaceaux1 UL_LEFT_BRACE interfaceaux2 UL_RIGHT_BRACE") )
# 153 "Parser.ml"
     : (unit))

let _menhir_action_02 =
  fun () ->
    (
# 52 "Parser.mly"
                ( (print_endline "interfaceaux1 : vide") )
# 161 "Parser.ml"
     : (unit))

let _menhir_action_03 =
  fun () ->
    (
# 53 "Parser.mly"
                                           ( (print_endline "interfaceaux1 : UL_EXTENDS interfaceaux3") )
# 169 "Parser.ml"
     : (unit))

let _menhir_action_04 =
  fun () ->
    (
# 57 "Parser.mly"
                ( (print_endline "interfaceaux2 : vide") )
# 177 "Parser.ml"
     : (unit))

let _menhir_action_05 =
  fun () ->
    (
# 58 "Parser.mly"
                                        ( (print_endline "interfaceaux2 : methode interfaceaux2") )
# 185 "Parser.ml"
     : (unit))

let _menhir_action_06 =
  fun () ->
    (
# 54 "Parser.mly"
                            ( (print_endline "interfaceaux3 : nomqualifie") )
# 193 "Parser.ml"
     : (unit))

let _menhir_action_07 =
  fun () ->
    (
# 55 "Parser.mly"
                                                   ( (print_endline "interfaceaux3 : nomqualifie UL_VIR interfaceaux3") )
# 201 "Parser.ml"
     : (unit))

let _menhir_action_08 =
  fun () ->
    (
# 45 "Parser.mly"
                                                                                        ( (print_endline "package : package IDENT_PACKAGE { packageaux1 }") )
# 209 "Parser.ml"
     : (unit))

let _menhir_action_09 =
  fun () ->
    (
# 64 "Parser.mly"
                                                                          ( (print_endline "methode : typee UL_IDENT_PACKAGE UL_PAROUV methodeaux1 UL_PARFER UL_PTVIR") )
# 217 "Parser.ml"
     : (unit))

let _menhir_action_10 =
  fun () ->
    (
# 65 "Parser.mly"
              ( (print_endline "methodeaux1 : vide") )
# 225 "Parser.ml"
     : (unit))

let _menhir_action_11 =
  fun () ->
    (
# 66 "Parser.mly"
                              ( (print_endline "methodeaux1 : methodeaux2") )
# 233 "Parser.ml"
     : (unit))

let _menhir_action_12 =
  fun () ->
    (
# 68 "Parser.mly"
                    ( (print_endline "methodeaux2 : typee") )
# 241 "Parser.ml"
     : (unit))

let _menhir_action_13 =
  fun () ->
    (
# 69 "Parser.mly"
                                           ( (print_endline "methodeaux2 : typee UL_VIR methodeaux2") )
# 249 "Parser.ml"
     : (unit))

let _menhir_action_14 =
  fun () ->
    (
# 60 "Parser.mly"
                                                 ( (print_endline "nomqualifie : nomqualifieaux1 UL_IDENT_INTERFACE") )
# 257 "Parser.ml"
     : (unit))

let _menhir_action_15 =
  fun () ->
    (
# 61 "Parser.mly"
                  ( (print_endline "nomqualifieaux1 : vide") )
# 265 "Parser.ml"
     : (unit))

let _menhir_action_16 =
  fun () ->
    (
# 62 "Parser.mly"
                                                          ( (print_endline "nomqualifieaux1 : methode interfaceaux2") )
# 273 "Parser.ml"
     : (unit))

let _menhir_action_17 =
  fun () ->
    (
# 43 "Parser.mly"
                                  ( (print_endline "package : internal_package FIN") )
# 281 "Parser.ml"
     : (unit))

let _menhir_action_18 =
  fun () ->
    (
# 46 "Parser.mly"
                          ((print_endline "packageaux1 : packageaux2"))
# 289 "Parser.ml"
     : (unit))

let _menhir_action_19 =
  fun () ->
    (
# 47 "Parser.mly"
                                      ( (print_endline "packageaux1 : packageaux2 packageaux1") )
# 297 "Parser.ml"
     : (unit))

let _menhir_action_20 =
  fun () ->
    (
# 48 "Parser.mly"
                               ( (print_endline "packageaux2 : paquetage") )
# 305 "Parser.ml"
     : (unit))

let _menhir_action_21 =
  fun () ->
    (
# 49 "Parser.mly"
                            ( (print_endline "packageaux2 : interface") )
# 313 "Parser.ml"
     : (unit))

let _menhir_action_22 =
  fun () ->
    (
# 71 "Parser.mly"
                   ( (print_endline "typee : UL_BOOLEAN") )
# 321 "Parser.ml"
     : (unit))

let _menhir_action_23 =
  fun () ->
    (
# 72 "Parser.mly"
                ( (print_endline "typee : UL_INT") )
# 329 "Parser.ml"
     : (unit))

let _menhir_action_24 =
  fun () ->
    (
# 73 "Parser.mly"
                 ( (print_endline "typee : UL_VOID") )
# 337 "Parser.ml"
     : (unit))

let _menhir_action_25 =
  fun () ->
    (
# 74 "Parser.mly"
                     ( (print_endline "typee : nomqualifie") )
# 345 "Parser.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | UL_BOOLEAN ->
        "UL_BOOLEAN"
    | UL_EXTENDS ->
        "UL_EXTENDS"
    | UL_FIN ->
        "UL_FIN"
    | UL_IDENT_INTERFACE _ ->
        "UL_IDENT_INTERFACE"
    | UL_IDENT_PACKAGE _ ->
        "UL_IDENT_PACKAGE"
    | UL_INT ->
        "UL_INT"
    | UL_INTERFACE ->
        "UL_INTERFACE"
    | UL_LEFT_BRACE ->
        "UL_LEFT_BRACE"
    | UL_PACKAGE ->
        "UL_PACKAGE"
    | UL_PARFER ->
        "UL_PARFER"
    | UL_PAROUV ->
        "UL_PAROUV"
    | UL_PT ->
        "UL_PT"
    | UL_PTVIR ->
        "UL_PTVIR"
    | UL_RIGHT_BRACE ->
        "UL_RIGHT_BRACE"
    | UL_VIR ->
        "UL_VIR"
    | UL_VOID ->
        "UL_VOID"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_43 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_package =
    fun _menhir_stack _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_FIN ->
          let _v = _menhir_action_17 () in
          MenhirBox_package _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_PACKAGE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_IDENT_PACKAGE _v ->
          let _menhir_stack = MenhirCell0_UL_IDENT_PACKAGE (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_LEFT_BRACE ->
              let _menhir_s = MenhirState03 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | UL_PACKAGE ->
                  _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | UL_INTERFACE ->
                  _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_INTERFACE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_IDENT_INTERFACE _v ->
          let _menhir_stack = MenhirCell0_UL_IDENT_INTERFACE (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_EXTENDS ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | UL_IDENT_PACKAGE _v_0 ->
                  _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState06
              | UL_IDENT_INTERFACE _ ->
                  let _ = _menhir_action_15 () in
                  _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06 _tok
              | _ ->
                  _eRR ())
          | UL_LEFT_BRACE ->
              let _v = _menhir_action_02 () in
              _menhir_goto_interfaceaux1 _menhir_stack _menhir_lexbuf _menhir_lexer _v
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_IDENT_PACKAGE (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_PT ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_IDENT_PACKAGE _v_0 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState08
          | UL_IDENT_INTERFACE _ ->
              let _ = _menhir_action_15 () in
              _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_09 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_UL_IDENT_PACKAGE -> _ -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_UL_IDENT_PACKAGE (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _ = _menhir_action_16 () in
      _menhir_goto_nomqualifieaux1 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_goto_nomqualifieaux1 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState32 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState23 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState25 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState13 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_10 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_IDENT_INTERFACE _ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_14 () in
          _menhir_goto_nomqualifie _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_goto_nomqualifie : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState32 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState23 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState25 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState13 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_26 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_25 () in
      _menhir_goto_typee _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_typee : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState25 ->
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState23 ->
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState32 ->
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_24 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_VIR ->
          let _menhir_stack = MenhirCell1_typee (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_VOID ->
              _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState25
          | UL_INT ->
              _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState25
          | UL_IDENT_PACKAGE _v_0 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState25
          | UL_BOOLEAN ->
              _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState25
          | UL_IDENT_INTERFACE _ ->
              let _ = _menhir_action_15 () in
              _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState25 _tok
          | _ ->
              _eRR ())
      | UL_PARFER ->
          let _ = _menhir_action_12 () in
          _menhir_goto_methodeaux2 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_18 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_24 () in
      _menhir_goto_typee _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_19 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_23 () in
      _menhir_goto_typee _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_20 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_22 () in
      _menhir_goto_typee _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_methodeaux2 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      match _menhir_s with
      | MenhirState23 ->
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MenhirState25 ->
          _menhir_run_27 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_28 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_typee _menhir_cell0_UL_IDENT_PACKAGE -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _ = _menhir_action_11 () in
      _menhir_goto_methodeaux1 _menhir_stack _menhir_lexbuf _menhir_lexer
  
  and _menhir_goto_methodeaux1 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_typee _menhir_cell0_UL_IDENT_PACKAGE -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_PTVIR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_UL_IDENT_PACKAGE (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_typee (_menhir_stack, _menhir_s, _) = _menhir_stack in
          let _v = _menhir_action_09 () in
          let _menhir_stack = MenhirCell1_methode (_menhir_stack, _menhir_s, _v) in
          (match (_tok : MenhirBasics.token) with
          | UL_VOID ->
              _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState32
          | UL_INT ->
              _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState32
          | UL_IDENT_PACKAGE _v_0 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState32
          | UL_BOOLEAN ->
              _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState32
          | UL_RIGHT_BRACE ->
              let _ = _menhir_action_04 () in
              _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer
          | UL_IDENT_INTERFACE _ ->
              let _ = _menhir_action_15 () in
              _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState32 _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_33 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_methode -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let MenhirCell1_methode (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _ = _menhir_action_05 () in
      _menhir_goto_interfaceaux2 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
  
  and _menhir_goto_interfaceaux2 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      match _menhir_s with
      | MenhirState17 ->
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MenhirState32 ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_34 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_UL_INTERFACE _menhir_cell0_UL_IDENT_INTERFACE _menhir_cell0_interfaceaux1 -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_interfaceaux1 (_menhir_stack, _) = _menhir_stack in
      let MenhirCell0_UL_IDENT_INTERFACE (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_UL_INTERFACE (_menhir_stack, _menhir_s) = _menhir_stack in
      let _ = _menhir_action_01 () in
      let _v = _menhir_action_21 () in
      _menhir_goto_packageaux2 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_packageaux2 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_PACKAGE ->
          let _menhir_stack = MenhirCell1_packageaux2 (_menhir_stack, _menhir_s, _v) in
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState36
      | UL_INTERFACE ->
          let _menhir_stack = MenhirCell1_packageaux2 (_menhir_stack, _menhir_s, _v) in
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState36
      | UL_RIGHT_BRACE ->
          let _ = _menhir_action_18 () in
          _menhir_goto_packageaux1 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_packageaux1 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      match _menhir_s with
      | MenhirState03 ->
          _menhir_run_40 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MenhirState36 ->
          _menhir_run_37 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_40 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_UL_PACKAGE _menhir_cell0_UL_IDENT_PACKAGE -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_UL_IDENT_PACKAGE (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_UL_PACKAGE (_menhir_stack, _menhir_s) = _menhir_stack in
      let _ = _menhir_action_08 () in
      _menhir_goto_internal_package _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_goto_internal_package : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_43 _menhir_stack _tok
      | MenhirState03 ->
          _menhir_run_38 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | MenhirState36 ->
          _menhir_run_38 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_38 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_20 () in
      _menhir_goto_packageaux2 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_37 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_packageaux2 -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let MenhirCell1_packageaux2 (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _ = _menhir_action_19 () in
      _menhir_goto_packageaux1 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
  
  and _menhir_run_27 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_typee -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let MenhirCell1_typee (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _ = _menhir_action_13 () in
      _menhir_goto_methodeaux2 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
  
  and _menhir_run_21 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_typee (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_IDENT_PACKAGE _v_0 ->
          let _menhir_stack = MenhirCell0_UL_IDENT_PACKAGE (_menhir_stack, _v_0) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_PAROUV ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | UL_VOID ->
                  _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState23
              | UL_INT ->
                  _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState23
              | UL_IDENT_PACKAGE _v_1 ->
                  _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState23
              | UL_BOOLEAN ->
                  _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState23
              | UL_PARFER ->
                  let _ = _menhir_action_10 () in
                  _menhir_goto_methodeaux1 _menhir_stack _menhir_lexbuf _menhir_lexer
              | UL_IDENT_INTERFACE _ ->
                  let _ = _menhir_action_15 () in
                  _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState23 _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_12 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_VIR ->
          let _menhir_stack = MenhirCell1_nomqualifie (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_IDENT_PACKAGE _v_0 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState13
          | UL_IDENT_INTERFACE _ ->
              let _ = _menhir_action_15 () in
              _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13 _tok
          | _ ->
              _eRR ())
      | UL_LEFT_BRACE ->
          let _ = _menhir_action_06 () in
          _menhir_goto_interfaceaux3 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_interfaceaux3 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_package) _menhir_state -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      match _menhir_s with
      | MenhirState06 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MenhirState13 ->
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_UL_INTERFACE _menhir_cell0_UL_IDENT_INTERFACE -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _v = _menhir_action_03 () in
      _menhir_goto_interfaceaux1 _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_goto_interfaceaux1 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_UL_INTERFACE _menhir_cell0_UL_IDENT_INTERFACE -> _ -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _menhir_stack = MenhirCell0_interfaceaux1 (_menhir_stack, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_VOID ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | UL_INT ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | UL_IDENT_PACKAGE _v_0 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState17
      | UL_BOOLEAN ->
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | UL_RIGHT_BRACE ->
          let _ = _menhir_action_04 () in
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer
      | UL_IDENT_INTERFACE _ ->
          let _ = _menhir_action_15 () in
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_14 : type  ttv_stack. (ttv_stack, _menhir_box_package) _menhir_cell1_nomqualifie -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let MenhirCell1_nomqualifie (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _ = _menhir_action_07 () in
      _menhir_goto_interfaceaux3 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_package =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState00 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_PACKAGE ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let package =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_package v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 75 "Parser.mly"
  


# 838 "Parser.ml"
