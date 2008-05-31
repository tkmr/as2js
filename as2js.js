var AS2JS = {
    store: [],
    Set: function(){
        var id = arguments[0];
        var func = arguments[1];
        AS2JS.store[id][func]=arguments[2];
    },
    Call: function (){
        var id = arguments[0].shift();
        var func = arguments[0].shift();
        var obj = AS2JS.store[id];
        for(var i=0; i<arguments[0].length; i++){
            arguments[0][i] = arguments[0][i]["__JSObjectID"] ?
                AS2JS.store[arguments[0][i]["__JSObjectID"]] :
                arguments[0][i];
        }
        var result = typeof(obj[func])=="function" ?
          AS2JS.doFunction(obj, obj[func], arguments[0]) :
          obj[func];
        if(typeof(result)=="object" || typeof(result)=="function"){
            return AS2JS.JStoSimpleObject(result);
        }else{
            return result;
        }
    },
    Register: function (generateScript){
        return AS2JS.JStoSimpleObject(eval(generateScript));;
    },
    JStoSimpleObject: function(js_obj){
        var id = (AS2JS.store.push(js_obj)) - 1;
        var obj={};
        obj = AS2JS.toCleanObject(js_obj);
        obj["__JSObjectID"] = id;
        return obj;
    },
    toCleanObject: function(js_obj){
        var obj = {};
        if(Array.prototype.isPrototypeOf(js_obj)){
            for(var i=1; i<js_obj.length; i++){ obj[i]=js_obj[i] }
        }else{
            if((typeof(js_obj)=="object" || typeof(js_obj)=="function") && (js_obj!=document)){
                for(var key in js_obj){
                    if(typeof(js_obj[key])=="string" || typeof(js_obj[key])=="number" || typeof(js_obj[key])=="boolean"){
                        obj[key] = js_obj[key];
                    }
                }
            }
        }
        return obj;
    },
    doFunction: function(obj, method, args){
        var params = ["obj"];
        for(var i=0;i<args.length;i++){ params[i+1] = "args["+i+"]"; }
        return eval("method.call("+params.join(',')+")");
    }
}
