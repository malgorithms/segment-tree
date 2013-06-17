# vecs are all just n-dimensional arrays

class BoundingBox
  constructor: (lower_left, upper_right) ->
    @ll = (n for n in lower_left)
    @ur = (n for n in upper_right)

  contain: (vec) ->
    for n, dim in vec
      if n < @ll[dim] then @ll[dim] = n
      if n > @ur[dim] then @ur[dim] = n

  distance_from_vec: (vec) ->
    nearest       = [] # nearest vec in bounding box outside
    dsq           = 0
    is_contained  = true 
    for n, dim in vec
      if n < @ll[dim]
        v = @ll[dim]
        dsq += (v-n) * (v-n)
        is_contained = false
      else if n > @ur[dim]
        v = @ur[dim]
        nearest.push v
        dsq += (v-n) * (v-n)
        is_contained = false
      else
        nearest.push n

    distance = Math.sqrt dsq
    return {distance, nearest, is_contained}


  split: (axis, median) ->
    left  = @copy()
    right = @copy()
    left.ur[axis]  = median
    right.ll[axis] = median
    return {left, right}

  copy: ->
    bb = new BoundingBox (x for x in @ll), (x for x in @ur)




exports.BoundingBox = BoundingBox