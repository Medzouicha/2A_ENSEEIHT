using LinearAlgebra
"""
Approximation d'une solution du problème min f(x), x ∈ Rⁿ, en utilisant l'algorithme de Newton.

# Syntaxe

   x_sol, f_sol, flag, nb_iters, xs = newton(f, gradf, hessf, x0; kwargs...)

# Entrées

   - f       : (Function) la fonction à minimiser
   - gradf   : (Function) le gradient de la fonction f
   - hessf   : (Function) la Hessienne de la fonction f
   - x0      : (Union{Real,Vector{<:Real}}) itéré initial
   - kwargs  : les options sous formes d'arguments "keywords"
      • max_iter : (Integer) le nombre maximal d'iterations (optionnel, par défaut 1000)
      • tol_abs  : (Real) la tolérence absolue (optionnel, par défaut 1e-10)
      • tol_rel  : (Real) la tolérence relative (optionnel, par défaut 1e-8)
      • epsilon  : (Real) le epsilon pour les tests de stagnation (optionnel, par défaut 1)

# Sorties

   - x_sol : (Union{Real,Vector{<:Real}}) une approximation de la solution du problème
   - f_sol : (Real) f(x_sol)
   - flag  : (Integer) indique le critère sur lequel le programme s'est arrêté
      • 0  : convergence
      • 1  : stagnation du xk
      • 2  : stagnation du f
      • 3  : nombre maximal d'itération dépassé
   - nb_iters : (Integer) le nombre d'itérations faites par le programme
   - xs    : (Vector{Vector{<:Real}}) les itérés

# Exemple d'appel

   f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
   gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
   hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
   x0 = [1; 0]
   x_sol, f_sol, flag, nb_iters, xs = newton(f, gradf, hessf, x0)

"""
function newton(f::Function, gradf::Function, hessf::Function,x0::Union{Real,Vector{<:Real}}; 
    max_iter::Integer = 100, 
    tol_abs::Real = sqrt(eps()), 
    tol_rel::Real = 1e-15, 
    epsilon::Real = 1.0)


    #
    n = length(x0);
    x_sol = x0
    f_sol = 0
    flag  = 0
    nb_iters = 0
    xs = [x0] # vous pouvez faire xs = vcat(xs, [xk]) pour concaténer les valeurs
    xk = x0
    xk_1 = x0

    while (norm(gradf(xk))> max(tol_rel*norm(gradf(x0)), tol_abs) )
      nb_iters += 1
      xk_1 = xk
      dk = -hessf(xk)\gradf(xk)
      xk =xk +dk
      xs = vcat(xs, [xk])
      if (norm(gradf(xk))<= max(tol_rel*norm(gradf(x0)), tol_abs))
         flag = 0
         break
      elseif (norm(dk) <= epsilon*max(tol_rel*norm(xk), tol_abs))
         flag = 1
         break
      elseif (abs(f(xk_1) - f(xk)) <= epsilon*max(tol_rel*abs(f(xk)), tol_abs))
         flag = 2
         break
      elseif nb_iters == max_iter 
         flag = 3 
         break
      end
   end
   x_sol = xk
   f_sol = f(x_sol)
   return x_sol, f_sol, flag,nb_iters, xs

end