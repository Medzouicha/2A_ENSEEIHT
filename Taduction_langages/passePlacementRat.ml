(* Module de la passe de gestion des placements *)
(* doit être conforme à l'interface Passe *)
open Tds
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

(* analyse_placement_instruction : int -> string -> AstType.instruction -> AstPlacement.instruction * int *)
(* Paramètre d : décalage pour l'emplacement dans la mémoire *)
(* Paramètre b : "SB" ou "LB" *)
(* Paramètre i : l'instruction à analyser *)
(* Traiter les emplacements et transformer l'instruction en une 
   instruction de type AstPlacement.instruction avec la nouvelle taille en mémoire *)
let rec analyse_placement_instruction d b i = 
  begin
  match i with 
  | AstType.Declaration  (info_ast, e) -> 
    begin
      match info_ast_to_info info_ast with
      | InfoVar (_,t,_,_) -> modifier_adresse_variable d b info_ast;
      (AstPlacement.Declaration (info_ast, e),(getTaille t))
      | _ -> failwith "erreur"
    end
  | AstType.Conditionnelle (e,b1,b2) -> 
    let a = analyse_placement_bloc d b b1 in
    let b = analyse_placement_bloc d b b2 in
    (AstPlacement.Conditionnelle(e,a,b),0)
  | AstType.TantQue (c, b1) ->  
    let a = analyse_placement_bloc d b b1 in
    (AstPlacement.TantQue(c, a),0)
  | AstType.Affectation (info, e) ->  (AstPlacement.Affectation (info, e),0)
  | AstType.AffichageInt e ->  (AstPlacement.AffichageInt (e),0)
  | AstType.AffichageRat e ->  (AstPlacement.AffichageRat(e),0)
  | AstType.AffichageBool e ->  (AstPlacement.AffichageBool (e),0)
  | AstType.Retour (e, info) ->  
    begin
    match info_ast_to_info info with
      |InfoFun (_,type_retour,type_arg) ->
        let n = getTaille type_retour in 
        let rec taille_arg t = 
          match t with 
          |[] -> 0
          |t::q -> getTaille t + taille_arg q
        in (AstPlacement.Retour (e, n,taille_arg type_arg) , 0)
      | _ -> failwith "erreur"
      end
  | AstType.Empty ->  (AstPlacement.Empty , 0)
  | AstType.For(info_ast,e,e2,info,e3,bloc) ->
    modifier_adresse_variable d b info_ast;
    begin
      match info_ast_to_info info_ast with
      |InfoVar(_,t_info,_,_) ->
        let taille_info = getTaille(t_info) in
        let nbloc = analyse_placement_bloc (d+taille_info) b bloc in 
        (AstPlacement.For(info_ast,e,e2,info,e3,nbloc) , 0)
      |_ -> failwith "erreur"
      end
  | AstType.Goto(ia) -> (AstPlacement.Goto(ia),0)
  | AstType.DeclGoto(ia) -> (AstPlacement.DeclGoto(ia),0)

  end


(* analyse_placement_bloc : int -> string -> AstType.bloc -> AstPlacement.bloc * int *)
(* Paramètre d : décalage pour l'emplacement dans la mémoire *)
(* Paramètre b : "SB" ou "LB" *)
(* Paramètre li : liste des instruction à analyser *)
(* Traiter les emplacements et transformer le bloc en un 
   bloc de type AstPlacement.bloc avec la nouvelle taille en mémoire *)
  and analyse_placement_bloc d b li = 
   match li with 
   | []-> ([],0)
   | t::q -> 
    begin
      let (a,taille_t) = analyse_placement_instruction d b t in 
      let (b,taille_q) = analyse_placement_bloc (d+taille_t) b q in 
      (a::b,(taille_t+taille_q))
    end
  
(* analyse_placement_fonction : AstType.Fonction -> AstPlacement.Fonction *)
(* Paramètre AstType.Fonction(info_ast,list_param,b) : la fonction à analyser *)
(* Traiter les emplacements et transformer la fonction en une 
   fonction de type AstPlacement.Fonction *)
  let analyse_placement_fonction (AstType.Fonction(info_ast,list_param,b)) =
    
    let rec analyse_placement_parametre_fonct lp = 
      match lp with
      | [] -> 0
      | t::q -> match info_ast_to_info t with
        | InfoVar(_,typee,_,_) -> 
          let taille_q = analyse_placement_parametre_fonct q in
          let _ = modifier_adresse_variable (-(getTaille typee)-taille_q) "LB" t in 
            (getTaille typee)+taille_q
        |_ -> failwith "erreur"
    
    in let _ = analyse_placement_parametre_fonct list_param in
    let b1 = analyse_placement_bloc 3 "LB" b in
    AstPlacement.Fonction(info_ast,list_param,b1)
  

    (* analyser :AstType.Programme -> AstPlacement.Programme *)
    (* Paramètre AstType.Programme (fonctions,prog) : le prog à analyser *)
    (* Traiter le programme et transformer le proggramme en un 
    programme de type AstPlacement.Programme *)
    let analyser (AstType.Programme (fonctions,prog)) =
      let fct = List.map (analyse_placement_fonction) fonctions in
      let bloc = analyse_placement_bloc  0 "SB" prog  in
      AstPlacement.Programme (fct, bloc)