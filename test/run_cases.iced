{SegmentTree} = require '../src/segment-tree'
{BoundingBox} = require '../src/bounding-box'
{Utils}       = require '../src/utils'


# ---------------------------------------------------------------

INSERTIONS = 1000*10
LOOKUPS    = 1000*10

exports.test = test = ->


  insertions = []
  for c in [0...INSERTIONS]
    x1  = -95 + 190 * Math.random()
    y1  = -95 + 190 * Math.random()
    x2  = x1 - 1 + 2 * Math.random()
    y2  = y1 - 1 + 2 * Math.random()
    obj = "shit#{c}"
    insertions.push {
      object:  "shit#{c}"
      segment: [[x1, y1], [x2, y2]]
    }

  d = Date.now()
  st = new SegmentTree {
    insertions:   insertions
    dimensions:   2
    split_gain:   0.2
    min_to_split: 16
  }
  console.log "#{INSERTIONS} insertions in #{Date.now() - d} == #{(Date.now() - d) / INSERTIONS}ms/insertions"

  console.log st.summarize()

  d = Date.now()
  for i in [0...LOOKUPS]
    v = [Math.random()*50, Math.random()*50]
    res = st.nearest_vertex v
  console.log "#{LOOKUPS} vertex lookups in #{Date.now() - d} == #{(Date.now() - d) / LOOKUPS}ms/lookup"

  d = Date.now()
  for i in [0...LOOKUPS]
    v = [Math.random()*50, Math.random()*50]
    res = st.nearest_segment v
  console.log "#{LOOKUPS} segment lookups in #{Date.now() - d} == #{(Date.now() - d) / LOOKUPS}ms/lookup"
