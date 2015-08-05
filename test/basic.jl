using Base.Test
include("../src/transducers.jl")
using Transducers

@test transduce(take(4), tpush!, Any[], 1:100) == Any[1, 2, 3, 4]
