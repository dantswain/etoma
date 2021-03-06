// Create a circle shaped path with its center at the center
// of the view and a radius of 10:
var path = new Path.Circle({
  center: view.center,
  radius: 10,
  strokeColor: 'black',
  fillColor: 'blue',
  visible: false
  });

var placedSymbols = {};

function onResize(event) {
}

function ensureObject(id, center) {
  if(placedSymbols[id] === undefined) {
    if(center === undefined){
      center = Point.random() * view.size;
    }
    placedSymbols[id] = path.clone();
    placedSymbols[id].visible = true;
    placedSymbols[id].position = center;
  }
  return placedSymbols[id];
}

var last_frame = 0;

function onFrame(event) {
  var frame_dt = 1000.0 * (event.time - last_frame);
  last_frame = event.time;

  var now = Date.now();
  var es = EtomaEvents.current_events();
  for(var ix = 0; ix < es.length; ix++) {
    var e = es[ix];
    var obj = ensureObject(e.id, dest);

    if(e.fillColor != null) {
      obj.fillColor = e.fillColor;
    }

    var dest = new Point(e.x, e.y);

    var diff = dest - obj.position;

    var dt = e.t - now + EtomaEvents.dt;
    if(dt <= 0.5*frame_dt){
      obj.position = dest;
    } else {
      var delta = frame_dt / dt;
      obj.position += diff * delta;
    }

  }
  
  EtomaEvents.flush_to(now);
}
