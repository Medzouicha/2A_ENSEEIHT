open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let acceptPackageIdent stream =
  match (peekAtFirstToken stream) with
    | (UL_PACKAGE_IDENT _ | UL_IDENT_INTERFACE _)->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseMachine : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let  rec  parsePackage stream =
  (print_string "Package -> ");
  (match (peekAtFirstToken stream) with
   | UL_PACKAGE ->
      (print_endline "package UL_IDENT_PACKAGE { ... }");
      ((inject stream) >>=
        (accept UL_PACKAGE) >>=
        acceptPackageIdent >>=
        (accept UL_LEFT_BRACE) >>=
        parseE >>=
        parseSe >>=
        (accept UL_RIGHT_BRACE))
   | _ -> Failure)
   and parseSe stream = 
    (print_string "Se -> ");
    (match (peekAtFirstToken stream) with
    |UL_RIGHT_BRACE ->
    inject stream
    | (UL_PACKAGE|UL_INTERFACE) -> 
    inject stream >>=
    parseE >>=
    parseSe
    | _ -> Failure)
  and parseE stream = 
    (print_string "E -> ");
    (match (peekAtFirstToken stream) with
    |UL_PACKAGE ->
    inject stream >>=
    parsePackage
    |UL_INTERFACE -> 
    inject stream >>=
    parseI
    | _ -> Failure)
    and parseI stream = 
      (print_string "I ->");
      (match (peekAtFirstToken stream) with
      |UL_INTERFACE -> 
      inject stream >>=
       (accept UL_INTERFACE) >>=
       acceptPackageIdent >>=
       parseX >>=
       (accept UL_LEFT_BRACE) >>=
       parseSm >>=
       (accept UL_RIGHT_BRACE)
      | _ -> Failure)
      and parseX stream = 
        (print_string "X -> ");
        (match (peekAtFirstToken stream) with
        |UL_LEFT_BRACE ->
        inject stream 
        |UL_EXTENDS -> 
        inject stream >>=
        (accept UL_EXTENDS) >>=
        parseQ >>=
        acceptPackageIdent >>=
        parseSq
        | _ -> Failure)
        and parseQ stream = 
          (print_string "Q ->");
          (match (peekAtFirstToken stream) with
          |UL_IDENT_INTERFACE _ ->
          inject stream 
          |UL_PACKAGE_IDENT _ -> 
          inject stream >>=
          acceptPackageIdent >>=
          (accept UL_PT) >>=
          parseQ

          | _ -> Failure)
          and parseSq stream = 
            (print_string "Sq-> ");
            (match (peekAtFirstToken stream) with
            |UL_LEFT_BRACE ->
            inject stream 
            |UL_VIR -> 
            inject stream >>=
            (accept UL_VIR) >>=
            parseQ >>=
            acceptPackageIdent >>=
            parseSq


            | _ -> Failure)
            and parseSm stream = 
              (print_string "Sm -> ");
              (match (peekAtFirstToken stream) with
              |UL_RIGHT_BRACE ->
              inject stream 
              |(UL_BOOLEAN|UL_INT|UL_VOID| UL_PACKAGE_IDENT _ | UL_IDENT_INTERFACE _) -> 
              inject stream >>=
              parseM >>=
              parseSm
   
              | _ -> Failure)
              and parseM stream = 
                (print_string "M -> ");
                (match (peekAtFirstToken stream) with
                |(UL_BOOLEAN|UL_INT|UL_VOID| UL_PACKAGE_IDENT _ | UL_IDENT_INTERFACE _) -> 
                  inject stream >>=
                  parseT >>=
                  acceptPackageIdent >>=
                  (accept UL_PAROUV) >>=
                  parseO >>=
                  (accept UL_PARFER) >>=
                  (accept UL_PTVIR)
                | _ -> Failure)
                and parseO stream = 
                  (print_string "O -> ");
                  (match (peekAtFirstToken stream) with
                  |UL_PARFER -> 
                    inject stream 
                  |(UL_BOOLEAN|UL_INT|UL_VOID| UL_PACKAGE_IDENT _ | UL_IDENT_INTERFACE _) -> 
                    inject stream >>=
                    parseT >>=
                    parseSt 
                  | _ -> Failure)
                  and parseSt stream = 
                    (print_string "St -> ");
                    (match (peekAtFirstToken stream) with
                    |UL_PARFER -> 
                      inject stream 
                    |UL_VIR -> 
                      inject stream >>=
                      (accept UL_VIR) >>=
                      parseT >>=
                      parseSt
                    | _ -> Failure)
                    and parseT stream = 
                      (print_string "T -> ...");
                      (match (peekAtFirstToken stream) with
                      |UL_BOOLEAN -> 
                        inject stream >>=
                        (accept UL_BOOLEAN)
                      |UL_INT -> 
                        inject stream >>=
                        (accept UL_INT)
                      |UL_VOID -> 
                        inject stream >>=
                        (accept UL_VOID)
                      |(UL_PACKAGE_IDENT _|UL_IDENT_INTERFACE _) -> 
                        inject stream >>=
                        parseQ >>=
                        acceptPackageIdent
                      | _ -> Failure)

              

      



;;
