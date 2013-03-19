/*
 * Custom javascript code goes in here.
 *
 **/
var timedEvent = "";
var mother_status = "";
var temp;

function setMax(id){
    __$(id).setAttribute("absoluteMax", parseInt(__$("touchscreenInput" + tstCurrentPage).value) - 1)
}

function setAt(str){
	id = str.split("!")[0]
    atr = str.split("!")[1]
	val = str.split("!")[2]
	__$(id).setAttribute(atr, val)
}

function showAPGAR(){
    __$("page" + tstCurrentPage).innerHTML = "";

    __$("keyboard").style.display = "none";
    
    
    __$("page" + tstCurrentPage).style.backgroundColor = "#eee";
}

function unloadAPGAR(){
    
}
function setDate(elementId){

    if ($(elementId).value.toLowerCase() == 'unknown'){
      $(elementId+'_value_datetime').value = null;
      $(elementId+'_value_modifier').value = null;
    }
    else{
      $(elementId+'_value_datetime').value = new Date($(elementId).value);  //.replace(/-/g, '/'));
    }
  }

  function checkHIVTestDate(id){
    var hiv_test_date_str = $(id).value.replace(/-/g, '/');
    var hiv_test_date     = new Date(hiv_test_date_str);
    var today             = new Date(Date.now());

    var weeks_ago = parseInt((today.getTime()- hiv_test_date.getTime())/ (1000 * 60 * 60 * 24 * 7));
   
    if (weeks_ago > 12){
       showMessage("Patient needs to be tested now!", true);
      return "true";
    }
    return "false";
  }

  // Every 500 milliseconds update the Next/Finish button
  function updateNextFinish(){
    if (tstInputTarget.value == '')
      $('nextButton').innerHTML = '<span>Finish</span>';
    else
      $('nextButton').innerHTML = '<span>Next</span>';
    setTimeout(updateNextFinish, 500)
  }

  function calculateEDOD(id){
    var edod = "";
    var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    if(!$(id)){
      var div = document.createElement("div");
      div.id = id;
      div.className = "statusLabel";

      $("inputFrame" + tstCurrentPage).appendChild(div);
    }

    if($("touchscreenInput" + tstCurrentPage).value.trim().length > 0){
      var theDate = new Date($("touchscreenInput" + tstCurrentPage).value.trim());

      theDate.setDate(theDate.getDate() + 7);

      theDate.setMonth(theDate.getMonth() + 9);

      edod = (theDate.getDate() + "-" + month[theDate.getMonth()] + "-" + theDate.getFullYear());
    }

    $(id).innerHTML = "Expected Date Of Delivery: <i style='font-size: 1.2em; float: right;'>" + edod + "</i>";
    
	if (temp != "already_done"){
    timedEvent = self.setInterval(function(){calculateEDOD()}, 100);
	temp = "already_done"
	}
  }
 
  function changeIds(){
    $("6").style.display = "none";
	$("7").style.display = "none";
	$("8").style.display = "none";
	$("9").style.display = "none";
	$("zero").style.display = "none";

    $("clearButton").onclick = function(){
      enableButtons();
    }
    $("1").onclick = function(){
      disableButtons();
    }
    $("2").onclick = function(){
      disableButtons();
    }
    $("3").onclick = function(){
      disableButtons();
    }
    $("4").onclick = function(){
      disableButtons();
    }
    $("5").onclick = function(){
      disableButtons();
    }
  }

  function disableButtons(){
    $("1").className = "keyboardButton gray";
    $("2").className = "keyboardButton gray";
    $("3").className = "keyboardButton gray";
    $("4").className = "keyboardButton gray";
    $("5").className = "keyboardButton gray";

    $("1").onmousedown = function(){};
    $("2").onmousedown = function(){};
    $("3").onmousedown = function(){};
    $("4").onmousedown = function(){};
    $("5").onmousedown = function(){};
  }

  function enableButtons(){
    $("1").className = "keyboardButton blue";
    $("2").className = "keyboardButton blue";
    $("3").className = "keyboardButton blue";
    $("4").className = "keyboardButton blue";
    $("5").className = "keyboardButton blue";

    $("1").onmousedown = function() {
      press('1');
    }
    $("2").onmousedown = function() {
      press('2');
    }
    $("3").onmousedown = function() {
      press('3');
    }
    $("4").onmousedown = function() {
      press('4');
    }
    $("5").onmousedown = function() {
      press('5');
    }
  }
function calculatePeriodOnARVs(){
    var periodOnARVs = 0;
    var date_started = $("touchscreenInput" + tstCurrentPage).value.trim() + " 00:00"
    var one_month = 1000*60*60*24*30;
    var date = createDate(date_started);
    var today = new Date();   
    var periodOnARVs = Math.round(Math.abs(today - date)/one_month);
    //feed a value as a patient selection
    // $("period_on_arvs").value = periodOnARVs;
    return periodOnARVs;
  }
  function showPeriodOnARVs(){
    if(!$('arv_period')){
      var div = document.createElement("div"); 
      div.id = "arv_period";
      div.className = "statusLabel";
      $("inputFrame" + tstCurrentPage).appendChild(div);
    }
   
    $('arv_period').innerHTML = "<i style='font-size: 1.2em;float: left;'> Period On ARVs    </i> "
      +  "<i style='font-size: 1.2em;float: right;'>" + calculatePeriodOnARVs() + ((calculatePeriodOnARVs() == 1)? " Month</i>" : " Months</i>")
	if (temp != "eventSet"){
	timedEvent = self.setInterval(function(){showPeriodOnARVs()}, 100);
	temp = "eventSet"
}
  }
function checkHIVTestUnkown(id){
    if($(id).value.toLowerCase() == "unknown"){

      showMessage("Patient needs to be tested now!", true);
      return true;
    }
    return false;
  }
function isValidDateFormat(value){
    return value.trim().match(/(\d{4})\-(\d{2})\-(\d{2})\s(\d{2})\:(\d{2})/);
  }
  function createDate(value){
    var d = isValidDateFormat(value);
    if(d){
      return new Date(eval(d[1]),(eval(d[2])-1),eval(d[3]),eval(d[4]),eval(d[5]));
    } else {
      return new Date();
    }
  } 

function weightAlert(str){
	gender_id = str.split("*")[1]
    if(!$('weight_label')){
      var div = document.createElement("div");
      div.id = "weight_label";
      div.className = "statusLabel";  

      gender = $(gender_id).value;
      if (gender == "Male"){
        maxi = 4.5;
        mini = 2.5;
      }else if (gender == "Female"){
        maxi = 4.4;
        mini = 2.4;
      }
      $("inputFrame" + tstCurrentPage).appendChild(div);

    }
    weight = $("touchscreenInput" + tstCurrentPage).value.trim();
    if (weight != ""){
      $('weight_label').innerHTML = ((weight > maxi )? "<i style='font-size: 1.2em;color: red;float: right;'> Over Weight</i>" : ((weight < mini)? "<i  style='font-size: 1.2em;float: right;color: red;'>Under Weight</i>"  : ""));
      if (weight < maxi && weight > mini){$('weight_label').innerHTML = "<i style='float:right;font-size:1.2em;'>  Normal Weight</i>";}
    }else {       
      $('weight_label').innerHTML = "<i style='float:left;font-size:1.2em;'>  Enter Weight</i>";
    }

	if (temp != "alert_done"){
		timedEvent = self.setInterval(function(){weightAlert(str)}, 100);
		temp = "alert_done";
	}
  }
  
