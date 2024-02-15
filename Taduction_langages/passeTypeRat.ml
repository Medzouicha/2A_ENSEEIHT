(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Type
open Exceptions
open Ast

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable *)
(* Paramètre a: l'affectable à analyser *)
(* Vérifie le type, tranforme l'affectable
en un affectable de type AstTds.affectable et renvoie le type de l'affectable,
 déclenchant des exceptions si type différent de celui attendu *)
let rec analyse_type_affectable a = 
  match a with
  | AstTds.Ident na ->
    begin
      match info_ast_to_info na with
     | InfoVar (_,t,_, _) -> (t, AstType.Ident na)
     | InfoConst _ -> (Int, AstType.Ident na)
     | _ -> failwith "erreur"
    end
  | AstTds.Valeur a2->
    begin
    let ta2,na2 = analyse_type_affectable a2 in 
      match ta2 with 
      | Pointeur t2 -> (t2,AstType.Valeur(na2))
      | _ -> raise (TypeInattendu(ta2,Pointeur Undefined))
    end
  | AstTds.Case (a2,e) -> 
    let ta2,na2 = analyse_type_affectable a2 in 
    let te,ne = analyse_type_expression e in
    match ta2 with
    | Tab t2 -> 
      if est_compatible Int te then
        (t2,AstType.Case(na2,ne))
      else raise (TypeInattendu(t2,Int))
    | _ -> raise (TypeInattendu(ta2,Tab Undefined))

(* analyse_tds_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_type_expression  e = 
  match e with

(*Pointeur*)
|AstTds.Affectable a -> 
  let (t,na) = analyse_type_affectable a in
  (t,AstType.Affectable(na))

|AstTds.Null -> (Pointeur Undefined,AstType.Null)
|AstTds.New t -> (Pointeur t,AstType.New(t))
|AstTds.Adress info ->
  begin
    match info_ast_to_info info with
    |InfoVar(_,t,_,_) -> (Pointeur t,AstType.Adress info)
    |_ -> failwith "erreur"
  end
|AstTds.Booleen b -> (Bool ,AstType.Booleen b)
|AstTds.Entier n -> (Int, AstType.Entier n)
|AstTds.Unaire (op,e1) ->
  begin
    let (te,ne) = analyse_type_expression  e1 in 
       if (te = Rat) then 
        begin 
          match op with 
          | Numerateur -> (Int, AstType.Unaire (Numerateur, ne))
          | Denominateur -> (Int, AstType.Unaire (Denominateur, ne))
          end
        else
          raise (TypeInattendu (te, Rat))
        end

|AstTds.Binaire (op,e1,e2) ->
  begin
    let (te1,ne1) = analyse_type_expression  e1 in
    let (te2,ne2) = analyse_type_expression  e2 in
    match op, te1, te2 with 
    | Plus, Int, Int -> (Int, AstType.Binaire (PlusInt, ne1, ne2))
    | Plus, Rat, Rat -> (Rat, AstType.Binaire (PlusRat, ne1, ne2))
    | Plus, _, _ -> raise (TypeBinaireInattendu (Plus, te1, te2))
    | Mult , Int , Int -> (Int, AstType.Binaire (MultInt, ne1, ne2))
    | Mult , Rat , Rat -> (Rat, AstType.Binaire (MultRat, ne1, ne2))
    | Mult, _, _ -> raise (TypeBinaireInattendu (Mult, te1, te2))
    | Equ , Int , Int     -> (Bool, AstType.Binaire (EquInt, ne1, ne2))
    | Equ , Bool , Bool  -> (Bool, AstType.Binaire (EquBool, ne1, ne2))
    | Equ , _, _ -> raise (TypeBinaireInattendu (Equ, te1, te2))
    | Inf , Int , Int        -> (Bool, AstType.Binaire (Inf, ne1, ne2))
    | Inf, _, _ ->  raise (TypeBinaireInattendu (Inf, te1, te2))
    | Fraction, Int, Int -> (Rat, AstType.Binaire (Fraction, ne1, ne2))
    | Fraction, _, _ -> raise (TypeBinaireInattendu (Fraction, te1, te2))



  end

 |AstTds.AppelFonction (id,liste) ->
  begin
    let listp, listne = List.(split (map analyse_type_expression liste)) in
    match info_ast_to_info id with 
    | InfoFun (_, t, lp) -> 
      if ( est_compatible_list lp listp) then 
        (t, AstType.AppelFonction (id, listne))
    else raise (TypesParametresInattendus (listp,lp))
    | _ -> failwith "erreur"
  end

  |AstTds.Creation (t,e) ->
    begin
      let (te,ne) = analyse_type_expression e in 
      if est_compatible Int te then
        (Tab t,AstType.Creation(t,ne))
      else raise  (TypeInattendu(te,Int))
    end
  |AstTds.Initialisation le ->
    (*Il faut que tous les exepressions en le meme tipe t et en retourne le tab(t)*)
    let list_t, list_ne = List.(split (map analyse_type_expression le)) in
    (*Determination de t*)
    let t = 
      match list_t with
        |[]->Undefined
        |tete::_->tete
    in 
    (*Verification qu'on a le meme type*)
    let rec verif_aux l =
      match l with
        |[]->(Tab t ,AstType.Initialisation list_ne)
        |tete::q-> 
          if est_compatible t tete then
            verif_aux q 
          else raise (TypeInattendu(t,tete))
    in verif_aux list_t



(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Gère le typage d'une instruction et la transforme en AstType.instruction *)
(* Erreur si les types ne sont pas compatibles *) 
let rec analyse_type_instruction ir i =
    match i with
    | AstTds.Declaration (t, n, e) ->

        let (te, ne) = analyse_type_expression e in 
        (* Vérification que le type de l'expression correspond à celui associé à la déclaration *)
        begin match (est_compatible te t) with 
          |true -> modifier_type_variable t n; AstType.Declaration (n, ne )
          |false -> raise (TypeInattendu(te, t))
        end 
    
    |AstTds.Affectation (a,e) -> 
      let ta,na = analyse_type_affectable a in 
      let te,ne = analyse_type_expression e in 
      (*On vérifie la compatiblité des types*)
      if est_compatible ta te then
        AstType.Affectation (na,ne)
      else
        raise (TypeInattendu (te, ta))
    | AstTds.Affichage e -> 
      let te, ne = analyse_type_expression e in
        begin match te with 
            |Int -> (AstType.AffichageInt ne)
            |Bool -> (AstType.AffichageBool ne)
            |Rat -> (AstType.AffichageRat ne)
            | _ -> assert false
        end
    | AstTds.Conditionnelle (c,t,e) ->
      begin
        let (tc, nc) = analyse_type_expression c in
        (*On vérifie que la condition est bien booleane*) 
        if (est_compatible tc Bool) then
          let tast = analyse_type_bloc ir t in
          let east = analyse_type_bloc ir e in
          AstType.Conditionnelle (nc, tast, east)
        else
          raise (TypeInattendu (tc, Bool))
      end

    |  AstTds.TantQue (c,b) -> 
      let tc, nc = analyse_type_expression c in
      let bast = analyse_type_bloc ir b in
      (*On vérifie que la condition est bien booleane*)
      if Type.est_compatible tc Bool then 
        AstType.TantQue(nc,bast)
      else
         raise (TypeInattendu (tc, Bool))

    | AstTds.Retour (e, iast) -> 
      let (te, ne) = analyse_type_expression e in 
      if (Type.est_compatible ir te ) then 
        AstType.Retour(ne, iast)
      else 
        raise (TypeInattendu (te,ir))    
    | AstTds.Empty -> AstType.Empty

    | AstTds.For(t,info_ast,e1,e2,info,e3,bloc) -> 
      if est_compatible Int t then

        let (te, ne) = analyse_type_expression e1 in 
        begin match (est_compatible te t) with 

          |true -> modifier_type_variable Int info_ast;
                   let (te2, ne2) = analyse_type_expression e2 in
                   if est_compatible Bool te2 then
                      let (te3,ne3) = analyse_type_expression e3 in 
                      if est_compatible te3 Int then
                        (*analyse du bloc associé à la boucle for*)
                        let nbloc = analyse_type_bloc ir bloc in 
                        AstType.For(info_ast,ne,ne2,info,ne3,nbloc)
                      else raise (TypeInattendu(te3, Int))
                   else raise (TypeInattendu(te2, Bool))
                             
          |false -> raise (TypeInattendu(te, t))
        end 

      else 
        raise (TypeInattendu(Int,t))
    | AstTds.DeclGoto (ia) -> AstType.DeclGoto (ia)
    | AstTds.Goto(ia) -> AstType.Goto(ia)

(* analyser_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Gère le typage du bloc et l'analyse de chaque instruction constituant le bloc *)
and analyse_type_bloc ir li = 
  List.(map (analyse_type_instruction ir) li )
(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(*Gère le typage des paramètres et du retour, des instructions, 
  tranforme la fonction en AstType.fonction *)
(* Erreur si problèmes de typage  *)
let analyse_type_fonction (AstTds.Fonction(t, ia, lp, li)) = 
  let tp, lia = List.split lp in 
  modifier_type_fonction t tp ia ;
  (* Définition du type de retour et des types des paramètres*)
  let _ =  List.map2 modifier_type_variable tp lia in 
  let nli = analyse_type_bloc t li  in AstType.Fonction(ia, lia, nli)

(* analyser : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Effectue le typage des fonctions et du bloc principal du programme *)
let analyser (AstTds.Programme (lf, b)) = 
  let nlf = List.map analyse_type_fonction lf in
  let nb = analyse_type_bloc Undefined b in
  AstType.Programme (nlf, nb)