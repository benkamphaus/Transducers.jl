using Base.Test
include("../src/transducers.jl")
using Transducers

@test transduce(ttake(4), tpush!, Any[], 1:100) == Any[1, 2, 3, 4]

@test transduce(treplace(Dict{Any,Any}([(1, "A"),(4, "D")])), tpush!, Any[], 1:5) == Any["A", 2, 3, "D", 5]

@test transduce(dedupe, tpush!, Any[], [1, 1, 2, 2, 3, 3]) == Any[1, 2, 3]

@test transduce(partition_all(4), tpush!, Any[], 1:8) == Any[[1,2,3,4],[5,6,7,8]]
@test transduce(partition_all(4), tpush!, Any[], 1:5) == Any[[1,2,3,4],[5]]

# this is a dorky test, but failures should be rare
@test size(transduce(random_sample(0.99999), tpush!, Any[], 1:10))[1] == 10

