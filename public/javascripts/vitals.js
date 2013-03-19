/*
 * Custom javascript code for vitals.
 *
 **/

var timedEvent = "";
var temp = ""
function attribute(str){
	id = str.split("*")[0]
    atr = str.split("*")[1]
	val = str.split("*")[2]
	__$(id).setAttribute(atr, val)
  }

function calculateBP(str){
	id1 = str.split("*")[0]
	id2 = str.split("*")[1]
	pos = str.split("*")[2]
	
    var bp;
    
    if(!$('bp')){
      var div = document.createElement("div");
      div.id = "bp";
      div.className = "statusLabel";

      $("inputFrame" + tstCurrentPage).appendChild(div);
    }

    if(pos == 1){
      bp = ($("touchscreenInput" + tstCurrentPage).value.trim().length > 0 ? $("touchscreenInput" +
        tstCurrentPage).value.trim() : "?") +
        "/" + ($(id2).value.trim().length > 0 ? $(id2).value.trim() : "?");
    } else if(pos == 2){
      bp = ($(id1).value.trim().length > 0 ? $(id1).value.trim() : "?") +
        "/" + ($("touchscreenInput" + tstCurrentPage).value.trim().length > 0 ? $("touchscreenInput" +
        tstCurrentPage).value.trim() : "?");
    }
    
    $("bp").innerHTML = "Blood Pressure: <i style='font-size: 1.2em; float: right;'>" + bp + "</i>";

	if (temp != "event_set"){
    timedEvent = setInterval(function(){calculateBP(str)}, 200);
	temp = "event_set"	
	}
  }


