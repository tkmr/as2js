package tkmr{
    import flash.utils.*;
    import flash.display.*;
    import flash.text.*;
    import flash.external.ExternalInterface;
    import flash.events.*;
    import flash.display.Loader;
    import flash.net.URLRequest
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.filters.*;
    import flash.net.*;

    public class JSTest extends Sprite {
        private var labels:Array = [];
        private var document:AS2JS = AS2JS.register("document");
        private var div:AS2JS = document.getElementById("hoge");
        private var twitter:AS2JS = AS2JS.register("twitter");
        private var filter:DropShadowFilter=new DropShadowFilter();
        private var format:TextFormat = new TextFormat();

        public function JSTest() {
            filter.alpha     =1;
            filter.angle     =45;
            filter.blurX     =4;
            filter.blurY     =4;
            filter.color     =0xFFFFFF;
            filter.distance  =0;
            filter.strength  =1.3;
            filter.quality   =BitmapFilterQuality.LOW;
            filter.inner     =false;
            filter.knockout  =false;
            filter.hideObject=false;

            format.color = 0x000000;
            format.size = 13;
            format.bold = true;

            var window:AS2JS = AS2JS.register("window");
            var element:AS2JS = AS2JS.register("Element");
            var title2:AS2JS = window.$("title2");
            element.update(title2, "Ustream with Twitter");

            var timer2:Timer = new Timer(70);
            var timer:Timer = new Timer(17000);
            timer.addEventListener('timer', updateTwitter);
            timer2.addEventListener('timer', updateDraw);

            ExternalInterface.addCallback("twitterOnLoad", function (obj:Object):void{
              var twitter:AS2JS = new AS2JS(obj);
              for each(var i:* in twitter){
                try{
                  if("text" in i && typeof(i.text)=="string"){
                    var label:TextField = new TextField();
                    label.autoSize = TextFieldAutoSize.LEFT;
                    label.selectable = true;
                    label.text = i.text;
                    label.x=(Math.random() * 2800) + 960;
                    label.y=Math.random() * 600;
                    label.setTextFormat(format);
                    label.filters = [filter];

                    addChild(label);
                    labels.push(label);
                  }
                }catch(e:Error){ trace(e.message); }
              }
            });
            window.eval("function twitterCallback(obj){ document[\"as\"].twitterOnLoad(AS2JS.JStoSimpleObject(obj)); }");

            timer.start();
            timer2.start();
        }
        public function updateDraw(event:TimerEvent):void {
              for(var i:int = 0; i<labels.length; i++){
                labels[i].x -= 7;
                if(labels[i].x < -800){
                  removeChild(labels[i]);
                  labels.splice(i,1);
                }
              }
        }
        public function updateTwitter(event:TimerEvent):void {
            var script:AS2JS = document.createElement("script");
            script.src = "http://twitter.com/statuses/friends_timeline/"+twitter.user_name+".json?callback=twitterCallback&count=30";
            script.type = "text/javascript";
            script.charset = "utf-8";
            div.appendChild(script);
        }
    }
}
