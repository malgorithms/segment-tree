require=function(t,n,e){function i(e,s){if(!n[e]){if(!t[e]){var o="function"==typeof require&&require;if(!s&&o)return o(e,!0);if(r)return r(e,!0);throw new Error("Cannot find module '"+e+"'")}var u=n[e]={exports:{}};t[e][0].call(u.exports,function(n){var r=t[e][1][n];return i(r?r:n)},u,u.exports)}return n[e].exports}for(var r="function"==typeof require&&require,s=0;s<e.length;s++)i(e[s]);return i}({SegmentTree:[function(t,n){n.exports=t("8U2X6G")},{}],"8U2X6G":[function(t,n){!function(){var e;e=n.exports=t("./segment-tree").SegmentTree}.call(this)},{"./segment-tree":1}],1:[function(t,n,e){!function(){var n,i,r,s;n=t("./bounding-box").BoundingBox,s=t("./utils").Utils,i={SPLIT_GAIN:.2,MIN_TO_SPLIT:16},r=function(){function t(t){var n,e,r,s,o,u,_,l;if(s=t.insertions,n=t.dimensions,u=t.split_gain,o=t.min_to_split,this.split_gain=u||i.SPLIT_GAIN,this.min_to_split=o||i.MIN_TO_SPLIT,this.dimensions=n,this.tree=this._new_tree(),this.by_id={},this.id_count=0,this.num_trees=1,null!=s?s.length:void 0){for(_=0,l=s.length;l>_;_++)r=s[_],e=this._record_and_get_id(r),this._add(e,r.segment,this.tree,0);this._perform_splits(this.tree,0)}}return t.prototype.add=function(t){var n,e,i;return e=t.object,i=t.segment,n=this._record_and_get_id({object:e,segment:i}),this._add(n,i,this.tree,0),n},t.prototype.nearest_segment=function(t){return this._find_nearest_segment(t,this.tree)},t.prototype.nearest_vertex=function(t){return this._find_nearest_vertex(t,this.tree)},t.prototype.vertices_inside_ball=function(t,n){var e;return e=[],this._find_vertices_inside_ball(t,this.tree,n,e),e},t.prototype.summarize=function(){return{num_trees:this.num_trees,num_objs:this.get_all_objs().length}},t.prototype.get_all_objs=function(){var t,n,e,i;e=this.by_id,i=[];for(t in e)n=e[t],i.push(n.o);return i},t.prototype._record_and_get_id=function(t){var n;return n=this.id_count++,this.by_id[n]={o:t.object,segment:t.segment},n},t.prototype._new_tree=function(){return{items:[],left:null,right:null,axis:null,divider:null,bounds:null}},t.prototype._perform_splits=function(t,n){var e;return(null!=(e=t.items)?e.length:void 0)&&this._maybe_split(t,n),null!=t.left?(this._perform_splits(t.left,n+1),this._perform_splits(t.right,n+1)):void 0},t.prototype._add=function(t,e,i,r){return null!=i.bounds?(i.bounds.contain(e[0]),i.bounds.contain(e[1])):i.bounds=new n(e[0],e[1]),null==i.axis?i.items.push({id:t,segment:e}):(this._is_on_left(e,i.axis,i.divider)&&this._add(t,e,i.left,r+1),this._is_on_right(e,i.axis,i.divider)?this._add(t,e,i.right,r+1):void 0)},t.prototype._find_vertices_inside_ball=function(t,n,e,i){var r,o,u,_,l,d,h,f,a,c,p;if(null!=(a=n.items)?a.length:void 0){for(c=n.items,p=[],o=h=0,f=c.length;f>h;o=++h)u=c[o],r=s.dist_sq(t,u.segment[0]),p.push(function(){var t,n,s,o;for(s=[0,1],o=[],t=0,n=s.length;n>t;t++)d=s[t],e*e>r?o.push(i.push({distance:Math.sqrt(r),vertex:u.segment[d],vertex_num:d,object:this.by_id[u.id].o})):o.push(void 0);return o}.call(this));return p}return _=n.left.bounds.distance_from_vec(t),l=n.right.bounds.distance_from_vec(t),_.distance<=e&&this._find_vertices_inside_ball(t,n.left,e,i),l.distance<=e?this._find_vertices_inside_ball(t,n.right,e,i):void 0},t.prototype._find_nearest_vertex=function(t,n){var e,i,r,o,u,_,l,d,h,f,a,c,p,g;if(null!=n.axis){if(d=n.left.bounds.distance_from_vec(t),f=n.right.bounds.distance_from_vec(t),d.distance<f.distance){if(l=this._find_nearest_vertex(t,n.left),l.distance<f.distance)return l;h=this._find_nearest_vertex(t,n.right)}else{if(h=this._find_nearest_vertex(t,n.right),h.distance<d.distance)return h;l=this._find_nearest_vertex(t,n.left)}return l.distance<h.distance?l:h}if(n.items.length){for(e=null,r=null,i=null,g=n.items,u=c=0,p=g.length;p>c;u=++c)_=g[u],o=s.dist_sq(t,_.segment[0]),(!u||i>o)&&(e=_,r=_.segment[0],i=o,a=0),o=s.dist_sq(t,_.segment[1]),i>o&&(e=_,r=_.segment[1],i=o,a=1);return{vertex:r,distance:Math.sqrt(i),object:this.by_id[e.id].o,vertex_num:a}}return{distance:1/0,vertex:null,object:null,vertex_num:null}},t.prototype._find_nearest_segment=function(t,n){var e,i,r,o,u,_,l,d,h,f,a,c;if(null!=n.axis){if(l=n.left.bounds.distance_from_vec(t),h=n.right.bounds.distance_from_vec(t),l.distance<h.distance){if(_=this._find_nearest_segment(t,n.left),_.distance<h.distance)return _;d=this._find_nearest_segment(t,n.right)}else{if(d=this._find_nearest_segment(t,n.right),d.distance<l.distance)return d;_=this._find_nearest_segment(t,n.left)}return _.distance<d.distance?_:d}if(n.items.length){for(e=null,i=null,c=n.items,r=f=0,a=c.length;a>f;r=++f)u=c[r],o=s.point_segment_dist(t,u.segment),(!r||o.dist<i.dist)&&(e=u,i=o);return{distance:i.dist,point:i.point,position_on_segment:i.position_on_segment,segment:e.segment,object:this.by_id[e.id].o}}return{distance:1/0,point:null,segment:null,object:null,position_on_segment:null}},t.prototype._maybe_split=function(t,n){var e,i,r,s;return i=t.items.length,i<this.min_to_split?void 0:(s=function(){var n,i,r;for(r=[],e=n=0,i=this.dimensions;i>=0?i>n:n>i;e=i>=0?++n:--n)r.push(this._get_split_candidate(t,e));return r}.call(this),s.sort(function(t,n){return n.split_gain-t.split_gain}),(r=s[0]).split_gain>=this.split_gain?this._split(t,r.axis,r.divider,n):void 0)},t.prototype._is_on_left=function(t,n,e){var i,r;return i=t[0][n],r=t[1][n],e>=i||e>=r},t.prototype._is_on_right=function(t,n,e){var i,r;return i=t[0][n],r=t[1][n],i>e||r>e},t.prototype._split=function(t,n,e,i){var r,s,o,u,_;for(t.left=this._new_tree(),t.right=this._new_tree(),t.axis=n,t.divider=e,s=t.items,t.items=null,this.num_trees++,_=[],o=0,u=s.length;u>o;o++)r=s[o],_.push(this._add(r.id,r.segment,t,i+1));return _},t.prototype._get_split_candidate=function(t,n){var e;return e={divider:(t.bounds.ll[n]+t.bounds.ur[n])/2,split_gain:null,axis:n},e.split_gain=this._calc_split_gain(t.items,n,e.divider),e},t.prototype._calc_split_gain=function(t,n,e){var i,r,s,o,u,_,l,d,h;for(s=0,u=0,d=0,h=t.length;h>d;d++)r=t[d],l=r.segment,this._is_on_left(l,n,e)&&s++,this._is_on_right(l,n,e)&&u++;return i=s+u-t.length,o=s-i,_=u-i,Math.min(o/t.length,_/t.length)},t}(),e.SegmentTree=r}.call(this)},{"./bounding-box":2,"./utils":3}],2:[function(t,n,e){!function(){var t;t=function(){function t(t,n){var e;this.ll=function(){var n,i,r;for(r=[],n=0,i=t.length;i>n;n++)e=t[n],r.push(e);return r}(),this.ur=function(){var t,i,r;for(r=[],t=0,i=n.length;i>t;t++)e=n[t],r.push(e);return r}()}return t.prototype.contain=function(t){var n,e,i,r,s;for(s=[],n=i=0,r=t.length;r>i;n=++i)e=t[n],e<this.ll[n]&&(this.ll[n]=e),e>this.ur[n]?s.push(this.ur[n]=e):s.push(void 0);return s},t.prototype.distance_from_vec=function(t){var n,e,i,r,s,o,u,_,l;for(o=[],i=0,r=!0,n=_=0,l=t.length;l>_;n=++_)s=t[n],s<this.ll[n]?(u=this.ll[n],i+=(u-s)*(u-s),r=!1):s>this.ur[n]?(u=this.ur[n],o.push(u),i+=(u-s)*(u-s),r=!1):o.push(s);return e=Math.sqrt(i),{distance:e,nearest:o,is_contained:r}},t.prototype.split=function(t,n){var e,i;return e=this.copy(),i=this.copy(),e.ur[t]=n,i.ll[t]=n,{left:e,right:i}},t.prototype.copy=function(){var n,e;return n=new t(function(){var t,n,i,r;for(i=this.ll,r=[],t=0,n=i.length;n>t;t++)e=i[t],r.push(e);return r}.call(this),function(){var t,n,i,r;for(i=this.ur,r=[],t=0,n=i.length;n>t;t++)e=i[t],r.push(e);return r}.call(this))},t}(),e.BoundingBox=t}.call(this)},{}],3:[function(t,n,e){!function(){var t;t={median:function(t){var n,e;return t.sort(function(t,n){return t-n}),t.length%2?e=t[(t.length-1)/2]:(n=t.length/2,e=(t[n]+t[n-1])/2),e},is_power_of_two:function(t){return t>0&&!(t&t-1)},dist_sq:function(t,n){var e,i,r,s,o,u;for(r=0,s=o=0,u=t.length;u>o;s=++o)e=t[s],i=n[s]-e,r+=i*i;return r},dist:function(n,e){return Math.sqrt(t.dist_sq(n,e))},point_segment_dist:function(n,e){var i,r,s,o,u,_,l,d,h;return u=t.dist_sq(e[0],e[1]),l=Math.sqrt(u),0===u?{dist:t.dist(n,e[0]),point:function(){var t,n,i,r;for(i=e[0],r=[],t=0,n=i.length;n>t;t++)h=i[t],r.push(h);return r}(),position_on_segment:[0,0]}:(i=t.diff(n,e[0]),r=t.diff(e[1],e[0]),d=t.dot_product(i,r)/u,0>d?{dist:t.dist(n,e[0]),point:function(){var t,n,i,r;for(i=e[0],r=[],t=0,n=i.length;n>t;t++)h=i[t],r.push(h);return r}(),position_on_segment:[0,l]}:d>1?{dist:t.dist(n,e[1]),point:function(){var t,n,i,r;for(i=e[1],r=[],t=0,n=i.length;n>t;t++)h=i[t],r.push(h);return r}(),position_on_segment:[l,0]}:(s=t.diff(e[1],e[0]),s=function(){var t,n,e;for(e=[],t=0,n=s.length;n>t;t++)h=s[t],e.push(d*h);return e}(),_=function(){var t,n,i,r;for(i=e[0],r=[],o=t=0,n=i.length;n>t;o=++t)h=i[o],r.push(h+s[o]);return r}(),{dist:t.dist(n,_),point:_,position_on_segment:[d*l,(1-d)*l]}))},diff:function(t,n){var e,i,r,s,o;for(o=[],e=r=0,s=t.length;s>r;e=++r)i=t[e],o.push(i-n[e]);return o},dot_product:function(t,n){var e,i,r,s,o;for(i=0,e=s=0,o=t.length;o>s;e=++s)r=t[e],i+=r*n[e];return i}},e.Utils=t}.call(this)},{}]},{},[]);