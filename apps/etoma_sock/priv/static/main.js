var websocket;
var endpoint;

$(document).ready(init);

function init() {
  endpoint = "ws://" + window.location.host + "/websocket";

  if(!("WebSocket" in window)){  
    $('#status').append('<p><span style="color: red;">websockets are not supported </span></p>');
    $("#navigation").hide();  
  } else {
    $('#status').append('<p><span style="color: green;">websockets are supported </span></p>');
    connect();
  };
  $("#content").hide(); 	
};

function connect()
{
  websocket = new WebSocket(endpoint);
  websocket.onopen = function(evt) { onOpen(evt) }; 
  websocket.onclose = function(evt) { onClose(evt) }; 
  websocket.onmessage = function(evt) { onMessage(evt) }; 
  websocket.onerror = function(evt) { onError(evt) }; 
}; 

function disconnect() {
  websocket.close();
}; 

function toggle_connection(){
  if(websocket.readyState == websocket.OPEN){
    disconnect();
  } else {
    connect();
  };
};

function sendTxt() {
  if(websocket.readyState == websocket.OPEN){
    txt = $("#send_txt").val();
    websocket.send(txt);
  } else {
  };
};

function onOpen(evt) { 
  $("#status").text('Connected');
  $("#content").fadeIn('slow');
};  

function onClose(evt) { 
  $("#status").text('Disconnected');
};  

function onMessage(evt) { 
  var d = JSON.parse(evt.data);
  if(d.tic != undefined) {
    EtomaEvents.sync(d.tic);
  } else {
    for(var ix = 0; ix < d.length; ix++) {
      EtomaEvents.push_event(d[ix]);
    }
  }
};  

function onError(evt) {
  $("#status").text("ERROR: " + evt.data);
};
