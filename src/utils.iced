Utils = 
  median: (vals) ->
    vals.sort (a,b) -> a - b
    if vals.length % 2
      res = vals[(vals.length-1)/2]
    else
      m = vals.length / 2
      res = (vals[m] + vals[m-1]) / 2
    return res

  is_power_of_two: (x) -> x > 0 && not (x & (x-1))

  dist_sq: (v1,v2) ->
    # n-dimensional vecs
    dsq = 0
    for a, i in v1
      d = v2[i] - a
      dsq += d*d
    dsq

  dist: (v1, v2) -> Math.sqrt Utils.dist_sq v1, v2

  point_segment_dist: (v, s) ->
    # returns {dist, point, position_on_segment}
    l2 = Utils.dist_sq s[0], s[1]
    s_len = Math.sqrt l2
    if l2 is 0
      return  {
        dist:                 Utils.dist v, s[0]
        point:                (x for x in s[0])
        position_on_segment:  [0, 0]
      }
    else
      d1 = Utils.diff v, s[0]
      d2 = Utils.diff s[1], s[0]      
      t = Utils.dot_product(d1, d2) / l2
      if t < 0
        return {
          dist:                 Utils.dist v, s[0]
          point:                (x for x in s[0])
          position_on_segment:  [0, s_len]
        }
      else if t > 1
        return {
          dist:                 Utils.dist v, s[1]
          point:                (x for x in s[1])
          position_on_segment:  [s_len, 0]
        }
      else
        diff = Utils.diff s[1], s[0]
        diff = (t * x for x in diff)
        proj = (x + diff[i] for x,i in s[0])
        return {
          dist:                 Utils.dist v, proj
          point:                proj
          position_on_segment:  [t * s_len, (1-t) * s_len]
        }

  diff: (v1, v2) -> ((x - v2[i]) for x,i in v1)

  dot_product: (v1, v2) ->
    sum = 0
    for x,i in v1
      sum += x * v2[i]
    sum

exports.Utils = Utils