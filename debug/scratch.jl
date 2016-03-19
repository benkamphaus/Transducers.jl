include("../src/transducers.jl")

using Debug, Transducers
@debug function check_compose()
    fn(x) = x^2
  @bp
  transduce(dedupe(tmap(fn)), tpush!, Any[], [1, 1, 2, 2, 3, 3])
end
