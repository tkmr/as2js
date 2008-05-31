package tkmr{
   import flash.utils.*;
   import flash.external.ExternalInterface;

   public dynamic class AS2JS extends Proxy {
      private var _attributes:Object;
      private var _item:Array;

      public function AS2JS(obj:Object){
        _attributes = obj;
      }
      public static function register(generateScript:String):*{
        var result:Object = ExternalInterface.call("AS2JS.Register", String(generateScript));
        return (new AS2JS(result));
      }

      public static function callJS(args:*):*{
        var result:Object = ExternalInterface.call("AS2JS.Call", args);
        if(result!=null && "__JSObjectID" in result){
          return (new AS2JS(result));
        }else{
          return result;
        }
      }
      override flash_proxy function getProperty(name:*):* {
        if(_attributes[String(name)]){
          return _attributes[String(name)];
        }else{
          //return AS2JS.callJS([_attributes.__JSObjectID, String(name)]);
          return null;
        }
      }
      override flash_proxy function setProperty(name:*, value:*):void {
        ExternalInterface.call("AS2JS.Set", _attributes.__JSObjectID, String(name), value);
      }
      override flash_proxy function callProperty(name:*, ... args):* {
        args.unshift(_attributes["__JSObjectID"], String(name));
        return AS2JS.callJS(args);
      }

      override flash_proxy function nextNameIndex (index:int):int {
         if (index == 0) {
            _item = new Array();
            for (var x:* in _attributes) {
              _item.push(x);
            }
         }
         if (index < _item.length) {
             return index + 1;
         } else {
             return 0;
         }
      }
      override flash_proxy function nextName(index:int):String {
         return _item[index - 1];
      }
      override flash_proxy function nextValue(index:int):*{
        return _attributes[String(_item[index - 1])];
      }
   }
}
