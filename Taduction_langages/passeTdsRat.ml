(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme



  

(* analyse_tds_affectable : tds -> AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre a : l'affectable à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'affectable
en un affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_affectable tds a =
   match a with 
   | AstSyntax.Ident n ->
    begin
      (* Recherche de l'identifiant dans la table des symboles globale *)
      match chercherGlobalement tds n with
        |None -> raise (IdentifiantNonDeclare n)
        |Some info -> 
          match info_ast_to_info info with 
            | InfoFun _ -> raise (MauvaiseUtilisationIdentifiant n)
            | _-> AstTds.Ident((info)) 
    end 

    | AstSyntax.Valeur a2 -> 
      begin
        (* Analyse récursive de l'affectable contenu dans la valeur *)
        let na2 = analyse_tds_affectable tds a2 in 
        AstTds.Valeur(na2) 
      end

    | AstSyntax.Case (a2,e) -> 
      begin
        (* Analyse récursive de l'affectable contenu dans la case *)
        let na2 = analyse_tds_affectable tds a2 in
        let ne = analyse_tds_expression tds e in
        AstTds.Case (na2,ne) 
      end

(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
and  analyse_tds_expression tds e = 
  match e with
  | AstSyntax.Affectable a ->
    begin
      (* Analyse de l'affectable contenu dans l'expression *)
      let na = analyse_tds_affectable tds a in 
      AstTds.Affectable(na)
    end 
  | AstSyntax.Null -> AstTds.Null
  | AstSyntax.New t -> AstTds.New(t)
  | AstSyntax.Adress n -> 
    begin
      (* Recherche de l'identifiant dans la table des symboles globale *)
      match chercherGlobalement tds n with
        |None -> raise (IdentifiantNonDeclare n)
        |Some info -> 
          begin
            match info_ast_to_info info with
              | InfoVar _ -> AstTds.Adress info
              | _ -> raise (MauvaiseUtilisationIdentifiant n)
          end
    end
  | AstSyntax.Booleen b -> AstTds.Booleen b
  | AstSyntax.Entier n -> AstTds.Entier n 
  | AstSyntax.Unaire (op,e1) ->
      begin
        let ne = analyse_tds_expression tds e1 in 
        AstTds.Unaire(op,ne)
      end
  | AstSyntax.Binaire (op,e1,e2) ->
      begin
        let ne1 = analyse_tds_expression tds e1 in
        let ne2 = analyse_tds_expression tds e2 in
        AstTds.Binaire(op,ne1,ne2)
      end
  |AstSyntax.AppelFonction (id,liste) ->
    begin
      match chercherGlobalement tds id with
        |None -> raise (IdentifiantNonDeclare id)
        |Some info ->
          begin
            match info_ast_to_info info with
              |InfoFun (_,_,_) ->
                (* Analyse des expressions dans la liste des arguments de la fonction *)
                let listne = List.map (analyse_tds_expression tds) liste in
                AstTds.AppelFonction(info,listne)
              | _ -> raise (MauvaiseUtilisationIdentifiant id)
          end
    end
  | AstSyntax.Creation(t,e1)->
      let ne1 = analyse_tds_expression tds e1 in 
      AstTds.Creation(t,ne1)
  | AstSyntax.Initialisation list_e -> 
      AstTds.Initialisation(List.map (analyse_tds_expression tds) list_e)


(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre tdsEtiquette : la table des etiquettes *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds tdsEtiquette oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (a,e) ->
      begin
        let ne = analyse_tds_expression tds e in 
        let rec analyse_tds_affectable_affectation a1 =
          match a1 with 
              | AstSyntax.Ident n ->
                begin
                  match chercherGlobalement tds n with
                    |None -> raise (IdentifiantNonDeclare n)
                    |Some info -> 
                      match info_ast_to_info info with 
                        | InfoVar _ -> AstTds.Ident((info)) 
                        | _ -> raise (MauvaiseUtilisationIdentifiant n)
                end 

                | AstSyntax.Valeur a2 -> 
                  begin
                    let na2 = analyse_tds_affectable_affectation a2 in 
                    AstTds.Valeur(na2) 
                  end
                | AstSyntax.Case (a2,e) ->
                  let na2 = analyse_tds_affectable_affectation a2 in 
                  let ne = analyse_tds_expression tds e in 
                  AstTds.Case(na2,ne)

        in let na = analyse_tds_affectable_affectation a in 
        AstTds.Affectation (na,ne)
      end

  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds tdsEtiquette oia t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds tdsEtiquette oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds tdsEtiquette oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end
  | AstSyntax.For (t,n,e1,e2,n2,e3,bloc) ->
    begin
      match chercherGlobalement tds n with
      |None ->
        let tdsBoucleFor = creerTDSFille tds in
        let info = InfoVar (n,Undefined,0,"") in
        let info_ast = info_to_info_ast info in
        ajouter tdsBoucleFor n info_ast;
        let ne1 = analyse_tds_expression tdsBoucleFor e1 in
        let ne2 = analyse_tds_expression tdsBoucleFor e2 in
        begin
            match chercherLocalement tdsBoucleFor n2 with
            (*Pour utiliser le meme identifiant comme mentionne dans le sujet : la tdsBoucleFor a dans ce moment que n*)
            |Some info -> 
                let ne3 = analyse_tds_expression tdsBoucleFor e3 in
                let nbloc = analyse_tds_bloc tdsBoucleFor tdsEtiquette oia bloc in 
                AstTds.For(t,info_ast,ne1,ne2,info,ne3,nbloc)
            |None -> raise (MauvaiseUtilisationIdentifiant n2)
        end
      |_ -> raise (DoubleDeclaration n)
    end
  | AstSyntax.Goto(n) -> 
    begin
      match chercherGlobalement tdsEtiquette n with
      | None -> 
        let info = InfoEtiquette(n,0,"") in
        (* Création du pointeur sur l'information *)
        
        let ia = info_to_info_ast info in
        AstTds.Goto(ia)
      | Some ia -> AstTds.Goto(ia) 
    end
  | AstSyntax.DeclGoto (n) ->
    begin
      (* il ne peut pas y avoir deux ´etiquettes du mˆeme nom dans une mˆeme 
      fonction ou dans le programme principal, mˆeme dans des blocs diff´erents*)
      match chercherGlobalement tdsEtiquette n with
        | None ->
            let info = InfoEtiquette(n,0,"") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tdsEtiquette n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.DeclGoto (ia)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds ,
            il a donc déjà été déclaré *)
            raise (DoubleDeclaration (n))
    end

    


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Paramètre tdsEtiquette : la table des etiquettes *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds tdsEtiquette oia li = 
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc tdsEtiquette oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Paramètre tdsEtiquette : la table des etiquettes *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds tdsEtiquette (AstSyntax.Fonction(t,n,lp,li))  =
  match chercherGlobalement maintds n with
 |None ->
  (* Création d'une table des symboles locale pour la fonction *)
  let tdsFct = creerTDSFille maintds in
  (* Création et ajout de l'information pour la fonction *)
  let info = InfoFun (n,Undefined,[]) in
  let info_ast = info_to_info_ast info in
  ajouter maintds n info_ast;

  (* Analyse des paramètres de la fonction *)
  let nlp = List.map (fun (t2,n2) -> match chercherLocalement tdsFct n2 with 
      |None -> 
        (* Création de l'information pour le paramètre *)
            let info_p = InfoVar (n2,Undefined,0,"") in
            let ia = info_to_info_ast info_p in
            ajouter tdsFct n2 ia;
            (t2,ia)
        |Some _ -> raise (DoubleDeclaration n2) 
    ) lp in

  (* Analyse du bloc de la fonction *)
  let nli = analyse_tds_bloc tdsFct tdsEtiquette (Some info_ast) li in
  AstTds.Fonction(t,info_ast,nlp,nli)
 | Some _ -> raise (DoubleDeclaration n)



(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let tdsEtiquette = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds tdsEtiquette) fonctions in
  let nb = analyse_tds_bloc tds tdsEtiquette None prog in
  AstTds.Programme (nf,nb)