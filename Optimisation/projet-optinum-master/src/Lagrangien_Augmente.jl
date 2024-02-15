using LinearAlgebra
include("../src/newton.jl")
include("../src/Regions_De_Confiance.jl")
"""

Approximation d'une solution au problème 

    min f(x), x ∈ Rⁿ, sous la c c(x) = 0,

par l'algorithme du lagrangien augmenté.

# Syntaxe

    x_sol, f_sol, flag, nb_iters, μs, λs = lagrangien_augmente(f, gradf, hessf, c, gradc, hessc, x0; kwargs...)

# Entrées

    - f      : (Function) la ftion à minimiser
    - gradf  : (Function) le gradient de f
    - hessf  : (Function) la hessienne de f
    - c      : (Function) la c à valeur dans R
    - gradc  : (Function) le gradient de c
    - hessc  : (Function) la hessienne de c
    - x0     : (Vector{<:Real}) itéré initial
    - kwargs : les options sous formes d'arguments "keywords"
        • max_iter  : (Integer) le nombre maximal d'iterations (optionnel, par défaut 1000)
        • tol_abs   : (Real) la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel   : (Real) la tolérence relative (optionnel, par défaut 1e-8)
        • λ0        : (Real) le multiplicateur de lagrange associé à c initial (optionnel, par défaut 2)
        • μ0        : (Real) le facteur initial de pénalité de la c (optionnel, par défaut 10)
        • τ         : (Real) le facteur d'accroissement de μ (optionnel, par défaut 2)
        • algo_noc  : (String) l'algorithme sans c à utiliser (optionnel, par défaut "rc-gct")
            * "newton"    : pour l'algorithme de Newton
            * "rc-cauchy" : pour les régions de confiance avec pas de Cauchy
            * "rc-gct"    : pour les régions de confiance avec gradient conjugué tronqué

# Sorties

    - x_sol    : (Vector{<:Real}) une approximation de la solution du problème
    - f_sol    : (Real) f(x_sol)
    - flag     : (Integer) indique le critère sur lequel le programme s'est arrêté
        • 0 : convergence
        • 1 : nombre maximal d'itération dépassé
    - nb_iters : (Integer) le nombre d'itérations faites par le programme
    - μs       : (Vector{<:Real}) tableau des valeurs prises par μk au cours de l'exécution
    - λs       : (Vector{<:Real}) tableau des valeurs prises par λk au cours de l'exécution

# Exemple d'appel

    f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
    gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
    hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
    c(x) =  x[1]^2 + x[2]^2 - 1.5
    gradc(x) = 2*x
    hessc(x) = [2 0; 0 2]
    x0 = [1; 0]
    x_sol, _ = lagrangien_augmente(f, gradf, hessf, c, gradc, hessc, x0, algo_noc="rc-gct")

"""
function lagrangien_augmente(f::Function, gradf::Function, hessf::Function, 
        c::Function, gradc::Function, hessc::Function, x0::Vector{<:Real}; 
        max_iter::Integer=1000, tol_abs::Real=1e-10, tol_rel::Real=1e-8,
        λ0::Real=2, μ0::Real=10, τ::Real=2, algo_noc::String="rc-gct")

    #
    n = length(x0)
    x_sol = x0
    f_sol = f(x_sol)
    α = 0.1
    β = 0.9
    xk = x0
    
    flag  = -1
    nb_iters = 0
    μk =  μ0
   
    λk = λ0
   
    μs = [μ0] # vous pouvez faire μs = vcat(μs, μk) pour concaténer les valeurs
    λs = [λ0]
    ε0 = 1e-2
    εk =  ε0 
    η =  0.1258925
    η0 = η/μ0^α 
    ηk = η0


    while nb_iters < max_iter
        Langrangien(x) = f(x) + λk' * c(x) + (μk / 2) * (norm(c(x))) ^ 2
        gradLangrangien(x) = gradf(x) + λk' * gradc(x) + μk*gradc(x)*c(x)
        HessLangrangien(x) = hessf(x) + λk' * hessc(x) + μk*(gradc(x)*gradc(x)' + hessc(x)*c(x))
        if (norm(gradLangrangien(xk)) > εk)
           
            if algo_noc == "rc-gct" 
                xk, ~ = regions_de_confiance(Langrangien, gradLangrangien, HessLangrangien, xk, algo_pas = "gct")
            elseif algo_noc == "rc-cauchy" 
                xk, ~ = regions_de_confiance(Langrangien, gradLangrangien, HessLangrangien, xk, algo_pas = "cauchy")
            elseif algo_noc == "newton"

                xk, ~ = newton(Langrangien, gradLangrangien, HessLangrangien, xk)
            end

        end
        nb_iters = nb_iters + 1
        λs = vcat(λs, [λk])
        μs = vcat(μs, [μk])

         #Tests d'arrêt

         gradL(x,l) = gradf(x) + l'*gradc(x)

    
         if norm(gradL(xk, λk)) <= max(εk, tol_rel*norm(gradL(x0, λ0)))
            flag = 0 
            break
         elseif norm(c(xk)) <= max(tol_rel, tol_rel*norm(c(xk)))
            flag = 1
            break 
         elseif nb_iters == max_iter
            flag = 3
            break
         else 
            if norm(c(xk)) <= ηk
                λk = λk + μk*c(xk)
                μk =μk
                εk = εk/μk
                ηk = ηk/(μk^β)
            else
                λk = λk
                μk = τ*μk
                εk = ε0/μk
                ηk = η/(μk^α)
            end
            
        end
    end
    x_sol = xk
    f_sol = f(x_sol)
    


    return x_sol, f_sol, flag, nb_iters, μs, λs

end
