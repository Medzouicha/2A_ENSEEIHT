(* Module de la passe de generation du code *)
(* doit être conforme à l'interface Passe *)
open Tds
open Type
open Ast
open AstType
open Code
open Tam


type t1 = Ast.AstPlacement.programme
type t2 = string

(* analyser_code_affectable : AstTds.affectable -> bool -> string *)
(* Paramètre a : l'affectable à analyser *)
(* Paramètre modif : un booléen indiquant si la fonction est modifiable ou non *)
(* Génération le code correspondant aux affectables *)
let rec analyse_code_affectable a modif = 
  match a with
  | AstType.Ident na ->
    (* Chargement de la valeur *)
    begin
      match info_ast_to_info na with
      |InfoVar(_, t, dep, reg) ->
        if modif then 
          (t, store (getTaille t) dep reg)
        else 
          (t, load (getTaille t) dep reg)
      |InfoConst(_, n) -> 
         (Int, loadl_int n)
      | _ -> failwith "erreur"
    end 
  | AstType.Valeur a2 -> 
    let (t, na2) = analyse_code_affectable a2 false in 
    if modif then 
      (t, na2 ^ (storei (getTaille t)))
    else 
      (t, na2 ^(loadi (getTaille t)))
  | AstType.Case (a, e) -> 
    begin 
      let (t,na) = analyse_code_affectable a false in 
      let (_,ne) = analyse_code_expression e in 
      begin
      match t with 
      | Tab (nt) -> 
        if modif then 
          (nt, (na ^ (loadl_int (getTaille nt)) ^ ne ^ (subr "IMul") ^ (subr "IAdd") ^ (storei (getTaille nt))))
        else 
          (nt, (na ^ (loadl_int (getTaille nt)) ^ ne ^ (subr "IMul") ^ (subr "IAdd") ^ (loadi (getTaille nt))))
      | _ -> failwith "erreur interne"
      end
    end
(* analyser_code_expression : expression -> string *)
(* Paramètre e : l'expression à analyser *)
(* Gère la génération de codecorrespondant à l'expression *)
and analyse_code_expression e = 
  match e with 
  | AstType.Affectable a -> 
      analyse_code_affectable a false 
  | AstType.Booleen(b) -> 
      if b then 
        (Bool,loadl_int 1 )
      else (Bool ,loadl_int 0)
  | AstType.Entier (n) -> (Int,loadl_int n)
  | AstType.Null -> (Pointeur (Undefined),loadl_int (-1))
  (*Allouer mémoire nécessaire pour un nouveau pointeur grace à Malloc*)
  | AstType.New t ->( Pointeur(t),loadl_int (getTaille t) ^ subr "Malloc")
  | AstType.Adress a -> 
    begin 
      match info_ast_to_info a with 
      | InfoVar(_,t, dep,reg) -> (Pointeur(t),loada dep reg)
      | _ -> failwith "erreur"
    end 
  | AstType.Unaire(op, e) -> 
          let (_,ne1) = analyse_code_expression e in
          let ne2 =
            match op with 
              | AstType.Numerateur -> pop 0 1
              | AstType.Denominateur -> pop 1 1
          in (Int,ne1^ne2)
  |AstType.Binaire(op, e1, e2) -> 
      begin  
         let (_,ne1) = analyse_code_expression e1 in
         let (_,ne2) = analyse_code_expression e2 in 
         match op with 
          |PlusInt -> (Int,ne1 ^ ne2 ^ subr "IAdd")
          |PlusRat -> (Rat,ne1 ^ ne2 ^ call "SB" "radd")
          |MultInt -> (Int,ne1 ^ ne2 ^ subr "IMul")
          |MultRat -> (Rat,ne1 ^ ne2 ^ call "SB" "rmul")
          |EquInt -> (Bool,ne1 ^ ne2 ^ subr "IEq")
          |EquBool -> (Bool,ne1 ^ ne2 ^ subr "IEq")
          |Inf -> (Bool,ne1 ^ ne2 ^ subr "ILss")
          |Fraction -> (Rat,ne1 ^ ne2 ^ call "SB" "norm")     
      end
  (*Appel de fonction*)
  |AstType.AppelFonction(ia, listExp) -> 
    begin
      match info_ast_to_info ia with 
        (*Génération du code tam associé à chaque expression des parametres, et l'appel de la fonction *)
        |InfoFun(n,t,_) ->  (t,(List.fold_right (fun t tq -> (snd (analyse_code_expression t))^tq) listExp "") ^ "CALL (SB)"^ n^"\n")
        | _ -> failwith "erreur"
    end
  (*Creation d'un nouveau tableau*)
  | AstType.Creation(t, e) -> 
    begin
       let (_, ne) = analyse_code_expression e in 
      (Tab (t), ne ^ loadl_int(getTaille t) ^ subr "IMul" ^ subr "Malloc")  
    end 
  | AstType.Initialisation le ->
    begin 
      let (l_t,l_ne) = List.split (List.map analyse_code_expression le) in
      let ne = List.fold_left (^) "" l_ne in 
      let taille = getTaille (List.hd l_t) * List.length l_ne in 
      (Tab (List.hd l_t),(loadl_int taille ^ subr "Malloc" ^ ne ^ loada (-taille-1) "ST" ^ loadi 1 ^ storei taille ))
    end


(* analyse_code_instruction: instruction -> string *)
(* Paramètre i : l'instruction à analyser *)
(* Génération du code tam correspondant à l'instruction. *)
let rec analyse_code_instruction i =
  match i with 
  |AstPlacement.Declaration(ia, e) -> 
    begin 
       match info_ast_to_info ia with 
       | InfoVar(_,t,dep,reg) -> 
            let _,code_e = analyse_code_expression e in 
            (push (getTaille t)) ^ code_e ^ (store (getTaille t) dep reg)
       | _ -> failwith "erreur"
    end 
  | AstPlacement.Affectation(ia,e) -> 
    let _,c1 = analyse_code_expression e in 
    let (_,c2) = analyse_code_affectable ia true in
    c1 ^ c2  
  | AstPlacement.AffichageInt e -> 
      let _,ce = analyse_code_expression e in 
      ce ^ (subr "IOut")
  | AstPlacement.AffichageBool e -> 
      let _,ce = analyse_code_expression e in 
      ce ^ (subr "BOut")
  | AstPlacement.AffichageRat e -> 
      let _,ce = analyse_code_expression e in 
      ce ^ call "SB" "ROut"
  | AstPlacement.Conditionnelle (e,b1,b2) ->
        begin
          let nb1 = analyse_code_bloc b1 in
          let nb2= analyse_code_bloc b2 in
          let _,ne = analyse_code_expression e in
          (* Génération de l'etiquette du else *)
          let etqElse = getEtiquette () in
          (* Génération de l'étiquette de fin *)
          let etqEnd = getEtiquette () in
          (* Génération du code de la conditionnelle *)
          ne^(jumpif 0 etqElse)^(nb1)^(jump etqEnd)^(label etqElse)^nb2^(label etqEnd)
        end
   | AstPlacement.TantQue(c,b) -> begin 
        let _,nc = analyse_code_expression c in 
        let nb = analyse_code_bloc b in 
        let bDebut = getEtiquette() in 
        let bEnd = getEtiquette() in 
        label bDebut ^ nc ^ (jumpif 0 bEnd) ^ nb ^ jump bDebut ^ label bEnd 
     end 
   | AstPlacement.Retour(e,tr,tp) -> 
            let _,code = (analyse_code_expression e)  
          in code ^ (return tr tp)
   | AstPlacement.Empty -> " "
   | AstPlacement.For(ia1, e1, e2, ia2, e3, b) -> 
      let nd1 = analyse_code_instruction(AstPlacement.Declaration(ia1,e1)) in 
      (* Génération du code du bloc de la boucle *)
      let nb = analyse_code_bloc b in 
      let (_,c) = analyse_code_expression e2 in 
      let nd2 = analyse_code_instruction(AstPlacement.Affectation(Ident(ia2), e3)) in 
      (* Génération de l'étiquette de début*)
      let bDebut = getEtiquette() in 
      (* Génération de l'étiquette de fin*)
      let bEnd = getEtiquette() in 
      (nd1 ^ (label bDebut) ^ c ^ (jumpif 0 bEnd) ^ nb ^ nd2 ^ (jump bDebut) ^ (label bEnd) ^ (pop 0 1))
  | AstPlacement.Goto(ie) -> 
      begin    
        match info_ast_to_info ie with 
          |InfoEtiquette(n,_,_) -> jump n     
          |_ -> failwith("erreur")
      end
  | AstPlacement.DeclGoto(ie) -> 
      begin 
        match info_ast_to_info ie with 
        |InfoEtiquette(n,_,_) -> label n
        |_ -> failwith("erreur")
      end

(* analyse_code_bloc : bloc -> string *)
(* Paramètre li : la liste des instruction à analyser *)
(* Paramètre taille : la taille du bloc  *)
(* Génération de code tam d'un bloc *)
and analyse_code_bloc(li,taille) = 
    let codeBloc = String.concat "" (List.map analyse_code_instruction li) in 
    codeBloc^(pop 0 taille)
(* analyse_code_fonction : fonction -> string *)
(* Paramètre : la fonction à analyser *)
(* Génération du code d'une fonction *)
let analyse_code_fonction (AstPlacement.Fonction (ia, _,b)) = 
    begin
      match info_ast_to_info ia with 
      |InfoFun(n,_,_) -> (label n) ^"\n"^ (analyse_code_bloc b) ^ halt 
      | _ -> failwith "erreur"
    end 
(* analyser : AstPlacement.programme -> string *)
(* Paramètre : le programme à analyser *)
(* Génération du code d'un programme *)
let analyser (AstPlacement.Programme(lf, b)) = 
    (*analyse des fonctions *) 
    let nlf = String.concat "" (List.map analyse_code_fonction lf) in 
    (*analyse du bloc principal *)
    let nb = analyse_code_bloc b in   
    getEntete() ^ nlf ^ label "main" ^ nb ^ halt 