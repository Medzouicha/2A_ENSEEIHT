%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PACKAGE
%token UL_LEFT_BRACE UL_RIGHT_BRACE

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT_PACKAGE
%token <string> UL_IDENT_INTERFACE



/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN
%token UL_INTERFACE
%token UL_EXTENDS
%token UL_INT
%token UL_BOOLEAN
%token UL_VOID
%token UL_PAROUV
%token UL_PARFER
%token UL_PTVIR
%token UL_VIR
%token UL_PT

/* Type renvoye pour le nom terminal document */
%type <unit> package

/* Le non terminal document est l'axiome */
%start package

%% /* Regles de productions */

package : internal_package UL_FIN { (print_endline "package : internal_package FIN") }

internal_package : UL_PACKAGE UL_IDENT_PACKAGE UL_LEFT_BRACE packageaux1 UL_RIGHT_BRACE { (print_endline "package : package IDENT_PACKAGE { packageaux1 }") }
packageaux1 : packageaux2 {(print_endline "packageaux1 : packageaux2")}
            | packageaux2 packageaux1 { (print_endline "packageaux1 : packageaux2 packageaux1") }
packageaux2 : internal_package { (print_endline "packageaux2 : paquetage") }
                | interface { (print_endline "packageaux2 : interface") }

interface : UL_INTERFACE UL_IDENT_INTERFACE interfaceaux1 UL_LEFT_BRACE interfaceaux2 UL_RIGHT_BRACE { (print_endline "interface : UL_INTERFACE UL_IDENT_INTERFACE interfaceaux1 UL_LEFT_BRACE interfaceaux2 UL_RIGHT_BRACE") }
interfaceaux1 : { (print_endline "interfaceaux1 : vide") }
                | UL_EXTENDS interfaceaux3 { (print_endline "interfaceaux1 : UL_EXTENDS interfaceaux3") }
interfaceaux3 : nomqualifie { (print_endline "interfaceaux3 : nomqualifie") }
                | nomqualifie UL_VIR interfaceaux3 { (print_endline "interfaceaux3 : nomqualifie UL_VIR interfaceaux3") }

interfaceaux2 : { (print_endline "interfaceaux2 : vide") }
                | methode interfaceaux2 { (print_endline "interfaceaux2 : methode interfaceaux2") }

nomqualifie : nomqualifieaux1 UL_IDENT_INTERFACE { (print_endline "nomqualifie : nomqualifieaux1 UL_IDENT_INTERFACE") }
nomqualifieaux1 : { (print_endline "nomqualifieaux1 : vide") }
                | UL_IDENT_PACKAGE UL_PT  nomqualifieaux1 { (print_endline "nomqualifieaux1 : methode interfaceaux2") }

methode : typee UL_IDENT_PACKAGE UL_PAROUV methodeaux1 UL_PARFER UL_PTVIR { (print_endline "methode : typee UL_IDENT_PACKAGE UL_PAROUV methodeaux1 UL_PARFER UL_PTVIR") }
methodeaux1 : { (print_endline "methodeaux1 : vide") }
                | methodeaux2 { (print_endline "methodeaux1 : methodeaux2") }

methodeaux2 : typee { (print_endline "methodeaux2 : typee") }
                | typee UL_VIR methodeaux2 { (print_endline "methodeaux2 : typee UL_VIR methodeaux2") }

typee : UL_BOOLEAN { (print_endline "typee : UL_BOOLEAN") }
        |UL_INT { (print_endline "typee : UL_INT") }
        |UL_VOID { (print_endline "typee : UL_VOID") }
        |nomqualifie { (print_endline "typee : nomqualifie") }
%%

