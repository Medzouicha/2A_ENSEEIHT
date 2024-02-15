using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s, sous la contrainte ‖s‖ ≤ Δₖ

# Syntaxe

    s = gct(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • max_iter : le nombre maximal d'iterations (optionnel, par défaut 100)
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel  : la tolérence relative (optionnel, par défaut 1e-8)

# Sorties

    - s : (Vector{<:Real}) une approximation de la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = gct(g, H, Δ)

"""
function gct(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; 
    max_iter::Integer = 100, 
    tol_abs::Real = 1e-10, 
    tol_rel::Real = 1e-8)

    s = zeros(length(g))
    n = length(g)
    j = 0 
    gj = g 
    gj_1 = g
    sj = s
    q(s) = transpose(g)*s + (1/2)*transpose(s)*H*s
    #delta = 2 
    pj = -g
    pj_1 = -g 
    while (j<2*n && norm(gj) > max(norm(g)*tol_rel,tol_abs))
        κj = transpose(pj)*H*pj
        if κj <= 0 
            #calculer racine de ∥sj + σpj ∥ = ∆ pour laquelle q(sj + σpj ) est la plus petite
            a = norm(pj)^2
            b = 2*transpose(sj)*pj
            c = norm(sj)^2 - Δ^2
            d = (b^2 - 4*a*c)
            if d >= 0
                Δ1  = sqrt(d)
            end
            sig1 = (-b + Δ1)/(2*a)
            sig2 = (-b - Δ1)/(2*a)
            if q(sj + sig1*pj )>q(sj + sig2*pj )
                sigj = sig2
            else
                sigj = sig1
            end
            s = sj + sigj*pj
            return s
        end
        αj = (transpose(gj)*gj)/κj
        if norm(sj + αj*pj ) >= Δ 
             # Calculer la racine positive de ∥sj + σj*pj ∥ = delta, Mathématiquement, cela peut être exprimé comme suit: transpose(sj+σjpj)*(sj+σjpj)= delta 
            a=norm(pj)^2
            b= 2*transpose(sj)*pj
            c= norm(sj)^2 - Δ^2
            d=b^2 -4*a*c
            if d >= 0
                Δ1  = sqrt(d)
            end
            sig1 = (-b + Δ1)/(2*a)
            sig2 = (-b - Δ1)/(2*a)
            if sig1 > 0
                sigj = sig1 
            else
                sigj = sig2
            end
            s = sj + sigj*pj
            return s
        end 
        sj = sj + αj*pj
        gj_1 = gj + αj*H*pj
        βj = (transpose(gj_1)*gj_1)/(transpose(gj)*gj)
        pj_1 = -gj_1 +  βj*pj
        gj = gj_1
        pj = pj_1
        j = j+1
    end 
    s = sj

   return s
end
