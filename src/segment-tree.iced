{BoundingBox} = require './bounding-box'
{Utils}       = require './utils'

###

a segment is a pair of points, where each point is an N-dimensional
array, and some object you want associated with that segment

Example:
  new SegmentTree {
    insertions: [
      {object: o1, segment: [[1, 2], [3,  10]}
      {object: o2, segment: [[3, 5], [3,  10]}
    ]
    dimensions:   2
    min_to_split: 8
    split_gain:   0.40 #  when a tree subdivides, 
                       #  x% go solely into one subtree, 
                       #  y% go solely into another,
                       #  Only subdivide if x and y are both greater than split_gain
  }
###

DEFAULTS = 
  SPLIT_GAIN:   0.2
  MIN_TO_SPLIT: 16

class SegmentTree

  constructor: ({insertions, dimensions, split_gain, min_to_split}) ->
    @split_gain   = split_gain   or DEFAULTS.SPLIT_GAIN
    @min_to_split = min_to_split or DEFAULTS.MIN_TO_SPLIT  
    @dimensions   = dimensions
    @tree         = @_new_tree()
    @by_id        = {}
    @id_count     = 0
    @num_trees    = 1

    if insertions?.length
      for insertion in insertions
        id = @_record_and_get_id insertion
        @_add id, insertion.segment, @tree, 0
      @_perform_splits @tree, 0

  add: ({object, segment}) ->
    id = @_record_and_get_id {object, segment}
    @_add id, segment, @tree, 0
    return id

  nearest_segment: (tuple) ->
    return @_find_nearest_segment tuple, @tree

  nearest_vertex: (tuple) ->
    return @_find_nearest_vertex tuple, @tree

  summarize: ->
    return {
      num_trees: @num_trees
      num_objs:  @get_all_objs().length
    }

  get_all_objs: -> (v.o for k,v of @by_id)

  # ---------------------------------------------------------------
  # PRIVATE
  # ---------------------------------------------------------------

  _record_and_get_id: (insertion) ->
    id = @id_count++
    @by_id[id] =
      o:        insertion.object
      segment:  insertion.segment
    return id

  _new_tree: ->
    return {
      items:      []
      left:       null
      right:      null
      axis:       null
      divider:    null
      bounds:     null # BoundingBox
    }

  _perform_splits: (tree, depth) ->
    if tree.items?.length
      @_maybe_split tree, depth
    if tree.left?
      @_perform_splits tree.left, depth+1
      @_perform_splits tree.right, depth+1

  _add: (id, segment, tree, depth) ->
    if tree.bounds?
      tree.bounds.contain segment[0]
      tree.bounds.contain segment[1]
    else
      tree.bounds = new BoundingBox segment[0], segment[1]
    if tree.axis? # this tree has been subdivided
      if @_is_on_left segment, tree.axis, tree.divider
        @_add id, segment, tree.left, depth+1
      if @_is_on_right segment, tree.axis, tree.divider
        @_add id, segment, tree.right, depth+1
    else
      tree.items.push {id, segment}

  _find_nearest_vertex: (tuple, tree) ->
    # returns {vertex, distance, object} // possibly null, Infinity
    if tree.axis?
      left_info  = tree.left.bounds.distance_from_vec  tuple
      right_info = tree.right.bounds.distance_from_vec tuple 
      if left_info.distance < right_info.distance
        left_best = @_find_nearest_vertex tuple, tree.left
        if left_best.distance < right_info.distance
          # prune the right side
          return left_best
        right_best = @_find_nearest_vertex tuple, tree.right
      else
        right_best = @_find_nearest_vertex tuple, tree.right
        if right_best.distance < left_info.distance
          # prune the left side
          return right_best
        left_best = @_find_nearest_vertex tuple, tree.left

      # we couldn't prune, but we have both answers
      if left_best.distance < right_best.distance
        return left_best
      else
        return right_best
    else
      if not tree.items.length
        return {
          distance: Infinity 
          vertex:   null
          object:   null 
        }
      else
        closest_item      = null
        closest_vertex    = null
        closest_item_dsq  = null       
        for item, i in tree.items
          dsq = Utils.dist_sq tuple, item.segment[0]
          if (not i) or dsq < closest_item_dsq
            closest_item      = item
            closest_vertex    = item.segment[0]
            closest_item_dsq  = dsq
          dsq = Utils.dist_sq tuple, item.segment[1]
          if dsq < closest_item_dsq
            closest_item      = item
            closest_vertex    = item.segment[1]
            closest_item_dsq  = dsq
        return {
          vertex:   closest_vertex
          distance: Math.sqrt closest_item_dsq
          object:   @by_id[closest_item.id].o 
        }

  _find_nearest_segment: (tuple, tree) ->
    # returns {distance, object, point, segment} // possibly null, Infinity
    if tree.axis?
      left_info  = tree.left.bounds.distance_from_vec  tuple
      right_info = tree.right.bounds.distance_from_vec tuple 
      if left_info.distance < right_info.distance
        left_best = @_find_nearest_segment tuple, tree.left
        if left_best.distance < right_info.distance
          # prune the right side
          return left_best
        right_best = @_find_nearest_segment tuple, tree.right
      else
        right_best = @_find_nearest_segment tuple, tree.right
        if right_best.distance < left_info.distance
          # prune the left side
          return right_best
        left_best = @_find_nearest_segment tuple, tree.left

      # we couldn't prune, but we have both answers
      if left_best.distance < right_best.distance
        return left_best
      else
        return right_best
    else
      if not tree.items.length
        return {
          distance: Infinity
          point:    null
          segment:  null
          object:   null
        }
      else
        closest_item      = null
        closest_item_info = null        
        for item, i in tree.items
          info = Utils.point_segment_dist tuple, item.segment
          if (not i) or info.dist < closest_item_info.dist
            closest_item      = item
            closest_item_info = info
        return {
          distance:  closest_item_info.dist
          point:     closest_item_info.point   
          segment:   closest_item.segment      
          object:    @by_id[closest_item.id].o 
        }

  _maybe_split: (tree, depth) ->
    ni = tree.items.length
    if ni < @min_to_split
      return
    split_candidates = (@_get_split_candidate tree, axis for axis in [0...@dimensions])
    split_candidates.sort (a,b) -> b.split_gain - a.split_gain
    if (sc = split_candidates[0]).split_gain >= @split_gain
      @_split tree, sc.axis, sc.divider, depth

  _is_on_left: (segment, axis, divider) ->
    n1 = segment[0][axis]
    n2 = segment[1][axis]
    (n1 <= divider) or (n2 <= divider)

  _is_on_right: (segment, axis, divider) ->
    n1 = segment[0][axis]
    n2 = segment[1][axis]
    (n1 > divider) or (n2 > divider)

  _split: (tree, axis, divider, depth) ->
    tree.left     = @_new_tree()
    tree.right    = @_new_tree()
    tree.axis     = axis
    tree.divider  = divider
    to_move       = tree.items
    tree.items    = null
    @num_trees++
    @_add i.id, i.segment, tree, depth+1 for i in to_move

  _get_split_candidate: (tree, axis) ->
    # for now, let's split right down the middle
    # and improve this later
    res =
      divider:    (tree.bounds.ll[axis] + tree.bounds.ur[axis]) / 2
      split_gain: null
      axis:       axis

    ###
    left_points  = (i.segment[0][axis] for i in tree.items)
    right_points = (i.segment[1][axis] for i in tree.items)
    points = []
    points.push p for p in left_points
    points.push p for p in right_points
    res.divider     = Utils.median points
    ###
    res.split_gain = @_calc_split_gain tree.items, axis, res.divider
    return res

  _calc_split_gain: (items, axis, divider) ->
    left_count  = 0
    right_count = 0
    for item in items
      s = item.segment
      if @_is_on_left s, axis, divider  then left_count++
      if @_is_on_right s, axis, divider then right_count++
    duplicates = left_count + right_count - items.length
    lsc = left_count  - duplicates
    rsc = right_count - duplicates
    return Math.min (lsc / items.length), (rsc / items.length)



exports.SegmentTree = SegmentTree
