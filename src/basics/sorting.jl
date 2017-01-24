sort{D,P}(xs::Vector{ArbDec{D,P}}, lt::Function=<, rev::Bool=false) = 
    sort(xs, alg=QuickSort, lt=lt, rev=rev)

function sort_intervals{D,P}(xs::Vector{ArbDec{D,P}}, rev::Bool=false)
   lessthan = rev ? pred : succ  
   return sort(xs, alg=MergeSort, lt=lessthan)
end
