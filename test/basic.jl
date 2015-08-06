using Base.Test
include("../src/transducers.jl")
using Transducers

@test transduce(take(4), tpush!, Any[], 1:100) == Any[1, 2, 3, 4]

@test transduce(partition_all(4), tpush!, Any[], 1:8) == Any[[1,2,3,4],[5,6,7,8]]
@test transduce(partition_all(4), tpush!, Any[], 1:5) == Any[[1,2,3,4],[5]]
