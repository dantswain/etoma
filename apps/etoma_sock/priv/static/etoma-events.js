var EtomaEvents = (function(){
  var self = {
    dt: 0
  };

  var buckets = {};

  function bucket_for(id) {
    if(buckets[id] === undefined) {
      buckets[id] = [];
    };
    return buckets[id];
  };

  function find_index_for_time(b, t) {
    // TODO: could take advantage of a being sorted
    for(var ix = 0; ix < b.length; ix++){
      if(b[ix].t >= t) { return ix }
    }
    return b.length;
  }

  function add_event_to_bucket(b, event_data){
    if(b.length == 0) {
      // if this is the only event, just add it
      b.push(event_data);
    } else {
      // otherwise add it at the right index
      var ix = find_index_for_time(b, event_data.t);
      b.splice(ix, 0, event_data);
    }
  }

  // for debugging
  self.buckets = function() {
    return buckets;
  }

  self.current_events = function() {
    var events = [];
    for(bucket in buckets) {
      var e = buckets[bucket][0];
      if(e != undefined){
        events.push(e);
      }
    }
    return events;
  }

  self.push_event = function(event_data) {
    var b = bucket_for(event_data.id);
    add_event_to_bucket(b, event_data);
  }

  self.sync = function(t) { dt = (Date.now() - t); }

  self.flush = function() { self.flush_to(Date.now()); }

  self.flush_to = function(t) {
    for(bucket in buckets) {
      while(buckets[bucket][0] != undefined && buckets[bucket][0].t <= t) {
        buckets[bucket].shift();
      }
    }
  }

  return self;
})();

function EtomaEvents(){
  this.buckets = [];
  this.dt = 0;
};

