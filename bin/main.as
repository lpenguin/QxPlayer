function onStartExecActions(){
//  	trace("on start exec actions");
//     if( location )
//         trace(location.id);
	PlayTriggers("start");
}

function onStopExecActions(){
	//trace("on stop exec actions");
	PlayTriggers("stop");
}

function AddTrigger(f, triggerClass , name) {
	//trace("Add trigger class:"+triggerClass+", name:"+name); 
	if( ! name ){
		name = triggerClass;
		triggerClass = "start";
	}
	//trace("Add trigger class:"+triggerClass+", name:"+name); 
	triggers.push( {
		func:f,
		name:String(name),
		triggerClass:String(triggerClass)
	});
}

function PlayTriggers( triggerClass ) {
	for ( var i in triggers ) {
		if( !triggerClass || triggerClass == triggers[i].triggerClass ){
			triggers[i].func();
		}
	}
}

var globals = this;
var showVarsMap = {};
var constraintsMap = {};
var showRangesArr = [];
var boundMap = {};
var pathPriorityMap = {};
var pathPassabilityMap = {}
var pathShowOrderMap = {};

function dump(v){
    for(var i in v ){
        trace( "i: "+v[i]);
        if( v[i]){
            trace("sub")
            dump(v[i]);
        }
    }
}
// function searchByName( name, objArray ){
//     for( var i = 0; i < objArray.length; i++ )
//         if( objArray[i].name == name )
//             return objArray[i];
//     return null;
// }
function range(min, max){
	return { "min" : min,
			"max": max};
}

function In( variable, range ){
	return variable >= range.min && variable <=range.max;
}

function hide( name ){
	showVarsMap[ name ] = false;
}

function search( v, ranges ){
	for( var i in ranges ){
		if( In(v, ranges[i] ) )
			return i;
	return -1;
}
function show( name ){
	showVarsMap[ name ] = true;
}

function ShowVars(){
	stateText = "";
	for( var i in showRangesArr ){
        var o = showRangesArr[i];
        var name = o.name;
//         stateText += i +"\n";
		if ( showVarsMap[name] == false){
            continue;
        }
        var v = globals[name]; 
        if ( !v && !o.showOnZero)
            continue;
        var n = search(v , o.ranges );
        if( n == -1){
            trace("Range not found for: "+ name);
            return;
        }
        var txt = o.texts[ n ].replace('<>', v);
        if( txt )
            stateText += txt + "\n";

			//stateText += globals[ name ]
	}
	
}

function AddConstraint(varName, min, max){
	constraintsMap[varName] = range( min, max );
}

function AddBound( varName, type, value, text ){
	boundMap[ varName ] = {
		"type" : type,
		"value" : value,
		"text" : text
	};
}


function AddShowRanges( varName, ranges, texts, show0 ){
	showRangesArr.push({
        "name" : varName,
		"ranges" : ranges,
		"texts" : texts,
		"showOnZero" : show0
	});
}

function SetPathPriority( pathId, value ){
	pathPriorityMap[ pathId ] = value;
}

function SetPathPassability( pathId, value ){
	pathPassabilityMap[ pathId ] = value;
}

function SetPathShowOrder( pathId, value ){
	pathShowOrderMap[ pathId ] = value;
}

function AddLocationTexts( locationId, f, texts ){
	
}

function CheckConstraints( varName ){
	if( constaraintsMap[ varName] ){
		var r = constaraintsMap[ varName];
		var v = globals[varName];
		if( v > r.max )
			v = r.max;
		if( v < r.min )
			v = r.min;
	}
}

function locationPaths( location ){
    var result = [];
    for( var i in location.paths){
        if( checkConditions( location.paths[i]) )
            result.push(location.paths[i]);
    }
    
    return result;
}
        
AddTrigger( function(){ ShowVars(); }, "stop", "showVars" );
trace("main lib loaded");

