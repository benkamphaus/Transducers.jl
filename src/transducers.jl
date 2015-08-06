module Transducers

export take, tmap, tfilter, partition_all, random_sample, transduce, tpush!

type Reduced
  val
end

function ensure_reduced(x::Reduced)
  x
end

function ensure_reduced(x)
  Reduced(x)
end

function unreduced(x::Reduced)
  x.val
end

function unreduced(x)
  x
end

function treduce(fn, iterable, initializer=None)
  if initializer == None
    accum_value = fn()
  else
    accum_value = initializer
  end

  for x in iterable
    accum_value = fn(accum_value, x)
    if typeof(accum_value) == Reduced
      return accum_value.val
    end
  end
  accum_value
end

function tpush!()
  Any[]
end

function tpush!(r)
  r
end

function tpush!(r, x)
  push!(r, x)
end

"""
Transduce entry point - reduce collection into start using
reducing function f, applying xform with each step.
"""
function transduce(xform, f, start)
  transduce(xform, f, f(), start)
end

function transduce(xform, f, start, coll)
  let reducer = xform(f)
    reducer((treduce(reducer, coll, start)))
  end
end

function tmap(f)
  function _map_xducer(step)
    _map_step() = step()
    _map_step(r) = step(r)
    _map_step(r, x) = step(r, f(x))
    _map_step
  end
  _map_xducer
end

function tfilter(pred)
  function _filter_xducer(step)
    _filter_step() = step()
    _filter_step(r) = step(r)
    _filter_step(r, x) = pred(x) ? step(r, x) : r
    _filter_step
  end
  _filter_xducer
end

function take(n::Int)
  function _take_xducer(step)
    counter = n
    _take_step() = step()
    _take_step(r) = step(r)
    function _take_step(r, x)
      old_n = counter
      counter -= 1
      r = old_n > 0 ? step(r, x) : r # ensure_reduced
      counter <= 0 ? ensure_reduced(r) : r
    end
    _take_step
  end
  _take_xducer
end

function partition_all(n::Int)
  function _partition_all_xducer(step)
    temp = Any[]
    _partition_all_step() = step()

    function _partition_all_step(r)
      if size(temp)[1] == 0
        r
      else
        _temp = temp[:] #benchmark vs. copy?
        empty!(temp)
        _r =  unreduced(step(r, _temp))
        step(_r)
      end
    end

    function _partition_all_step(r, x)
      push!(temp, x)
      if size(temp)[1] == n
        _temp = temp[:]
        empty!(temp)
        step(r, _temp)
      else
        r
      end
    end

    _partition_all_step
  end
  _partition_all_xducer
end

function random_sample(prob::FloatingPoint)
  function _random_sample_xducer(step)
    _random_sample_step() = step()
    _random_sample_step(r) = step(r)
    _random_sample_step(r, x) = rand() < prob ? step(r, x)  : r
    _random_sample_step
  end
  _random_sample_xducer
end

# module end
end
