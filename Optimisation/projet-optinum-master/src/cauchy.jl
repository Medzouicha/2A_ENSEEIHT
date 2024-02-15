using LinearAlgebra
"""
Approximation de la solution du problème 

 min qₖ(s) = s'gₖ + 1/2 s' Hₖ s

 sous les contraintes s = -t gₖ, t > 0, ‖s‖ ≤ Δₖ

# Syntaxe

 s = cauchy(g, H, Δ; kwargs...)

# Entrées

 - g : (Vector{<:Real}) le vecteur gₖ
 - H : (Matrix{<:Real}) la matrice Hₖ
 - Δ : (Real) le scalaire Δₖ
 - kwargs : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
 • tol_abs : la tolérence absolue (optionnel, par défaut 1e-10)

# Sorties

 - s : (Vector{<:Real}) la solution du problème

# Exemple d'appel

 g = [0; 0]
 H = [7 0 ; 0 2]
 Δ = 1
 s = cauchy(g, H, Δ)

"""
function cauchy(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; tol_abs::Real = 1e-10)

 s = zeros(length(g))
 lambda = 1
 n= length(g)
 # On cherche à Déterminer un vecteur sS k , solution du problème (4) linéarisé, 
 #soit sS = arg min (fk + gₖs) , sous les contraintes ‖s‖ ≤ ∆k. 
 # Déterminer le scalaire λk > 0 minimisant mk(λsS), soit :
 # λk = arg min λ>0 mk(λsS ) , sous les contraintes ‖λsS ‖ ≤ ∆k
 #Finalement, s = λksS .
 if g != zeros(n)
 #La résolution du problème (4) donne aisément la solution suivante :
 sS = - (Δ/norm(g))*g
 #La détermination de λk dépend du signe de gT H g :
 if (g'*H*g > 0)
 #Alors la fonction mk(λksS ) est convexe et quadratique en λ. Le pas λk 
 #est alors soit la valeur qui minimise la fonction quadratique soit la
 # valeur limite 1 déterminée prochainement
 lambda = min(1, ((norm(g))^3)/(Δ*(g'*H*g)))
 else 
 #la fonction mk(λksS ) décroît de façon monotone avec λ, 
 #et ce, même si ∇fk 6 = 0.Le pas λk est donc la plus grande
 #valeur qui satisfasse le rayon de confiance, et donc λk = 1.
 lambda = 1 
 end
 s = lambda * sS
 end
 return s
end






