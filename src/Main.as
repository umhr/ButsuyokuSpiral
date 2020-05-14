/*
物欲スパイラル
初出：080610

一年以上前、少しずつクラスを使い始めたころのものを、
wonderflで動くように修正。

もー、ほんとコードが汚すぎ。
位置調整に１時間以上かけたけど、うまくいかない。
ビール飲みながら書いているからだけじゃないはず。

丸い画像を作るために、マスク使っているので重い。
bitmapFillを使えば、もっとずっと軽くなるはず。




*/

package{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	import flash.text.TextField;

    [SWF(width="465", height="465", frameRate="30", backgroundColor="0xFFFFFF")]
	public class Main extends Sprite {
		private var itemURL_array:Array = new Array();
		private var txt_array:Array = new Array();
		private var autoCount:int;
		private var stagesize_array:Array = new Array();
		private var itemList:Array = new Array();
		
		public function Main():void {
			stage.scaleMode = "noScale";
			var _btn:SimpleButton = Create.newSimpleButton([0,0,100,21,"FullScreen"])
			addChild(_btn);
			_btn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				if(stage.displayState == "normal"){
					stage.displayState = "fullScreen";
				}else{
					stage.displayState = "normal";
				}
			});
			stage.addEventListener(Event.RESIZE, function(event:Event):void{
				stageResize();
			});
			function stageResize():void {
				stagesize_array[0] = -(stage.stageWidth-465)/2;
				stagesize_array[1] = -(stage.stageHeight-465)/2;
				_btn.x = stagesize_array[2] = stage.stageWidth-(stage.stageWidth-465)/2-100;
				_btn.y = stagesize_array[3] = stage.stageHeight-(stage.stageHeight-465)/2-20;
			}
			stageResize();
			
			var XMLlist_array:Array = new Array("data");
			function MulitLoad(_XMLlist_array:Array):void{
				var _XML_array:Array = new Array();
				var _urlL_array:Array = new Array();
				for (var i:int=0;i<_XMLlist_array.length;i++) {
					var _urlR:URLRequest = new URLRequest("3d/arss/data.xml");
					var _urlL:URLLoader = new URLLoader(_urlR);
					_urlL_array[i] = _urlL;
					_urlL_array[i].addEventListener (Event.COMPLETE,function(e:Event):void{
						_XML_array.push(XML(_urlL_array[_XML_array.length].data));
						if(_XML_array.length == XMLlist_array.length){
							_XMLadd2(_XML_array);
						}
					});
				}
				function _XMLadd2(_XML_array:Array):void{
					var _l:int = _XML_array[0].items.length();
					for (var i:int=0;i<_l;i++) {
						var xml:XML = new XML(_XML_array[0].items[i]);
						var _length:int = xml.item.length();
						var titleStr:String = new String(xml.title.children());
						titleStr = titleStr.replace(/Amazon.co.jp: |のベストセラー/g,"");
						for (var j:int=0;j<_length;j++){
							var _str:String = String(xml.item[j].jpg.children());
							if(_str.substr(-3,3) == "jpg"){
								var priceStr:String = String(xml.item[j].price.children());
								var link:String = String(xml.item[j].url.children());
								var txt:String = String(xml.item[j].title.children());
								txt = txt.split(": ")[1];
								itemURL_array.push(_str);
								itemList.push(i);
								txt_array.push("<a href='"+link+"' target='_blank'>"+titleStr+"売上"+(j+1)+"位\n"+txt+"\n¥"+priceStr+"\n &gt;&gt; この商品のAmazonページ</a>")
							}
						}
						
					}
					Main3();
				}
			}
			MulitLoad(XMLlist_array);
		}
		
		public function Main3():void {
			var item_array:Array = new Array();
			var arrayLoaderObj:arrayLoader = new arrayLoader();
			item_array = arrayLoaderObj.loadImg(itemURL_array);
			//trace(itemURL_array)
			//MultiLoader.setLoad(itemURL_array,Main2);
			var clicked:int = 999;
			var clickeded:int = 999;
			var clicked_n:int = 0;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 22;	
			
			for (var j:int=0;j<item_array.length;j++) {
				var sp:Sprite = new Sprite();
				sp = new Sprite();
				sp.graphics.beginFill(0x000000,1);
				sp.graphics.drawCircle(0,0,50);
				item_array[j].addChild(sp);
				item_array[j].mask = sp;
				sp.x = sp.y = 75;
				//
				var _tf:TextField = new TextField();
				//_tf.textColor = fieldcolor_array[i];
				_tf.defaultTextFormat = textFormat;
				//_tf.selectable = false;
				_tf.htmlText = txt_array[j];
				//itemLink_array
				//_tf.htmlText = "<b>hogebee</b>";
				//_tf.embedFonts = true;
				//_tf.border = true;
				//_tf.borderColor = 0xff0000;
				//_tf.background = true;
				//_tf.backgroundColor = 0xffffff;
				_tf.height = uint(300);
				_tf.width = uint(300);
				_tf.x = 100-300;
				_tf.y = -75-170;
				_tf.multiline = true;
				_tf.wordWrap = true;
				item_array[j].addChild(_tf);
				_tf.visible = false;
				//
				item_array[j].x = (j%5)*150;
				item_array[j].y = int(j/5)*150;
				//item_array[j].name = "mama"
				item_array[j].buttonMode = true;;
				item_array[j].getChildAt(0).addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {																								
					fnClicked(int(event.target.name));
				})
			
				stage.addChild(item_array[j]);
			}	
			
			function fnClicked(_n:int):void{
				clickeded = clicked;
				clicked = _n;
				clicked_n = 0;
				autoCount = 0;
			}
///////////
var mousepoz_array:Array = new Array(150,50);
stage.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
	mousepoz_array = [event.stageX-stage.stageWidth/2,event.stageY-stage.stageHeight/2];
	autoCount = 0;
});
function xy2degrees(_x:Number,_y:Number):Number{
	return 180*Math.atan(_y/_x)/Math.PI;
}
//////////
var cubes_array:Array = new Array();
var cube:Object = new Object();
for (var i:int= 0; i<item_array.length; i++){
	cube = new Object();
	var _rx:Number = i/5;
	var _ry:Number = _rx;
	var _rz:Number = i*15-9*item_array.length;
	_rx = Math.cos(_rx)*360;
	_ry = Math.sin(_ry)*360;
	cube.shape = [[_rx,_ry,_rz]];
	cube.poz = [0,0,0,0,0,0];
	cube.fillColor = 0xff00cc;
	cube.type = "item";
	cube.item = item_array[i];
	cubes_array.push(cube);
}

//

var renderObj:render = new render();

var _count:int;
//var autoCount:int;
function fnMain(e:Event):void {
	autoCount ++;
	if(autoCount > 30*10){
		if(Math.random() > (mousepoz_array[0]+mousepoz_array[1])/5000){
			mousepoz_array[0] += Math.random()*200-100;
			mousepoz_array[1] += Math.random()*200-100;
		}else{
			mousepoz_array[0] /= 2;
			mousepoz_array[1] /= 2;
		}
		fnClicked(Math.floor(Math.random()*item_array.length));
	}
	
	var _length:int = cubes_array.length;
	var obj_array:Array = new Array(_length);
	_count ++;
	if(clicked_n < 100){
		clicked_n += 4;
	}
	gPoz[3] += -mousepoz_array[1]/80000;
	gPoz[4] += -mousepoz_array[0]/80000;
	for (var i:int= 0; i<_length; i++){
		obj_array[i] = _mov(cubes_array[i],gPoz,i);
	}
	
	var z_array:Array = _zsort(obj_array);
	
	for (var j:int= 0; j<_length; j++){
		var k:int = z_array[j];
		if(cubes_array[k].type == "item"){
			stage.setChildIndex(cubes_array[k].item,j);
		}
		var _is:Boolean = false;
		if(obj_array[k][0][0] < stagesize_array[0]-600 || stagesize_array[2]-200 < obj_array[k][0][0]){
			_is = false;
		}else if(obj_array[k][0][1] < stagesize_array[1]-500 || stagesize_array[3]-100 < obj_array[k][0][1]){
			_is = false;
		}else if(0<obj_array[k][0][2] && obj_array[k][0][2]<6){
			_is = true;
		}
		renderObj.xRender(_sp_array[j],obj_array[k],cubes_array[k],_is,j);
	}
}
//mainの関数を呼び続ける。fnMainレイヤーへ
stage.addEventListener(Event.ENTER_FRAME,fnMain);

function _zsort(arg_data_array:Array):Array {
	var _length:int = arg_data_array.length;
	var _array:Array = new Array(_length);
	for (var i:int = 0; i<_length; i++) {
		_array[i] = distance4zSort(arg_data_array[i][0]);
	}
	return _array.sort(Array.NUMERIC|Array.RETURNINDEXEDARRAY);
}
import flash.geom.Point;
function distance4zSort(_array:Array):Number {
	var _pt:Point = new Point(_array[0],_array[1]);
	_pt = new Point(_pt.length, -10000000-_array[2]);
	return _pt.length;
}

function _distance3d(arg0_array:Array,arg1_array:Array):Number {
	var pt0xy:Point = new Point(arg0_array[0], arg0_array[1]);
	var pt1xy:Point = new Point(arg1_array[0], arg1_array[1]);
	var _xy:Number = Point.distance(pt0xy,pt1xy);
	var ptxyz:Point = new Point(_xy, arg1_array[2]-arg0_array[2]);
	return ptxyz.length;
}

var gPoz:Array = new Array(0,0,0,0,0,0);
var xPoz:Number = 0;
var yPoz:Number = 0;
var zPoz:Number = 0;
var cPoz:Array = new Array([0,0,0]);
var toPoz:Array = new Array(0,0,0);
var listPoz:Array = new Array(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
var tolistPoz:Array = new Array(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
var isDefolt:Boolean;
function _mov(arg:Object,poz:Array,_i:int):Array {
	var _length:int = arg.shape.length;
	var ar:Array = new Array(_length);
	for (var i:int= 0; i<_length; i++) {
		ar[i] = [arg.shape[i][0],arg.shape[i][1],arg.shape[i][2]];
	}
	if(itemList[_i] == itemList[clicked]){
		listPoz[itemList[_i]]=0.6;
	}else if(!isDefolt){
		listPoz[itemList[_i]]=1;
	}
	tolistPoz[itemList[_i]] = tolistPoz[itemList[_i]]*(1-(clicked_n/100))+listPoz[itemList[_i]]*tween(clicked_n/100);

	var toar:Array = new Array(3);
	if(_i == clicked){
		var _n:Number = tween(1-clicked_n/100);
		if(itemList[clickeded] == itemList[clicked]){
			_n*=0.5;
		}
		ar[0] = [arg.shape[0][0]*_n,arg.shape[0][1]*_n,arg.shape[0][2]];
		zPoz = arg.shape[0][2]*tween2(1-clicked_n/100);
		if(95 < clicked_n && clicked_n < 100){
			//item_array[_i].rotation += 0.1;
			var _sp:Sprite =  item_array[_i];
			_sp.getChildAt(1).scaleX = _sp.getChildAt(1).scaleY = 10;
			_sp.getChildAt(0).scaleX = _sp.getChildAt(0).scaleY = 2;
			_sp.getChildAt(1).x = -75;
			_sp.getChildAt(0).x = -200;
			_sp.getChildAt(0).y = -75;
			_sp.getChildAt(2).visible = true;
		//sp.scaleX = sp.scaleY = 2;
		}
	}else{
		var _m2:Number = tolistPoz[itemList[_i]];
		ar[0] = [arg.shape[0][0]*_m2,arg.shape[0][1]*_m2,arg.shape[0][2]];
		if(_i == clickeded && clicked_n < 5){
			var _sp2:Sprite =  item_array[_i];
			_sp2.getChildAt(1).scaleX = _sp2.getChildAt(1).scaleY = 1;
			_sp2.getChildAt(0).scaleX = _sp2.getChildAt(0).scaleY = 1;
			_sp2.getChildAt(1).x = 75;
			_sp2.getChildAt(0).x = 0;
			_sp2.getChildAt(0).y = 0;			
			_sp2.getChildAt(2).visible = false;
		}

	}	

	var _poz:Array = new Array(arg.poz[0]+poz[0],arg.poz[1]+poz[1],arg.poz[2]+poz[2],arg.poz[3]+poz[3],arg.poz[4]+poz[4],arg.poz[5]+poz[5]);
	if(_i == clicked){
		cPoz =  _affine(ar,_poz);
		toPoz = [cPoz[0][0]*0.06+toPoz[0]*0.94,cPoz[0][1]*0.06+toPoz[1]*0.94,cPoz[0][2]*0.06+toPoz[2]*0.94];
	}
	return _pertrans(_affine2(_affine(ar,_poz),[-toPoz[0],-toPoz[1],-toPoz[2]]));
}

function tween(_n:Number):Number{
	return _n*_n*_n*_n;
}
function tween2(_n:Number):Number{
	return 1-_n*_n*_n*_n;
}


var _sp_array:Array = new Array();
function iniMakeSprite(arg_i:int):void{
	for (var i:int = 0; i < arg_i; i++) {
		var sp:Sprite = new Sprite();
		stage.addChild(sp);
		_sp_array.push(sp);
	}
}

iniMakeSprite(cubes_array.length);

function _pertrans(arg_array:Array):Array{
	var _length:int = arg_array.length;
	var ar:Array = new Array(_length);
	for (var i:int = 0; i<_length; i++) {
		var _per:Number = 1000/(1000+arg_array[i][2]);
		ar[i] = [arg_array[i][0]*_per,arg_array[i][1]*_per,_per];
	}
	return ar;
}

function _affine2(data_array:Array,arg_array:Array):Array {
	return [[data_array[0][uint(0)]+arg_array[uint(0)],data_array[0][uint(1)]+arg_array[uint(1)],data_array[0][uint(2)]+arg_array[uint(2)]]];
}
function _affine(data_array:Array,arg_array:Array):Array {
	var n_cx:Number = Math.cos(arg_array[uint(3)]);
	var n_sx:Number = Math.sin(arg_array[uint(3)]);
	var n_cy:Number = Math.cos(arg_array[uint(4)]);
	var n_sy:Number = Math.sin(arg_array[uint(4)]);
	var n_cz:Number = Math.cos(arg_array[uint(5)]);
	var n_sz:Number = Math.sin(arg_array[uint(5)]);
	var d_x:Number = arg_array[uint(0)];
	var d_y:Number = arg_array[uint(1)];
	var d_z:Number = arg_array[uint(2)];
	var af_xx:Number = n_cz*n_cy+n_sx*n_sy*n_sz;
	var af_xy:Number = n_sx*n_sy*n_cz-n_sz*n_cy;
	var af_xz:Number = n_sy*n_cx;
	var af_yx:Number = n_cx*n_sz;
	var af_yy:Number = n_cx*n_cz;
	var af_yz:Number = -n_sx;
	var af_zx:Number = n_cy*n_sx*n_sz-n_sy*n_cz;
	var af_zy:Number = n_sy*n_sz+n_cy*n_sx*n_cz;
	var af_zz:Number = n_cx*n_cy;
	var af_x:Number = data_array[uint(0)][uint(0)];
	var af_y:Number = data_array[uint(0)][uint(1)];
	var af_z:Number = data_array[uint(0)][uint(2)];
	return [[af_x*af_xx+af_y*af_xy+af_z*af_xz+d_x,af_x*af_yx+af_y*af_yy+af_z*af_yz+d_y,af_x*af_zx+af_y*af_zy+af_z*af_zz+d_z]];
}

function _render(sp:Sprite,arg:Array,argObj:Object):void {
	sp.graphics.clear();
	sp.graphics.beginFill(argObj.fillColor,0.8);
	sp.graphics.moveTo(arg[arg.length-1][0],arg[arg.length-1][1]);
	for (var i:int= 1; i<arg.length; i++) {
		sp.graphics.lineTo(arg[i][0],arg[i][1]);
	}
	sp.x = 400;
	sp.y = 300;
}



		}
		
	}
}


import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.SimpleButton;

class Create{
    public static var defaultTextFormat:TextFormat = new TextFormat();
    
    public static function newSimpleButton(x_y_w_h_txt:Array = null,property:Array=null,graphics:Array=null):SimpleButton{
        
        var _x:Number = x_y_w_h_txt[0];
        var _y:Number = x_y_w_h_txt[1];
        var _width:Number = x_y_w_h_txt[2];
        var _height:Number = x_y_w_h_txt[3];
        var _text:String = x_y_w_h_txt[4];
        
        var upState:Sprite = newSprite({x:_x,y:_y},{graphics:toDrawRect({color:0xCCCCCC,width:_width,height:_height,round:8})});
        upState.addChild(newShape({x:2,y:2},{graphics:toDrawRect({color:0xE5E5E5,width:_width-4,height:_height-4,round:6})}));
        var overState:Sprite = newSprite({x:_x,y:_y},{graphics:toDrawRect({color:0xBBBBBB,width:_width,height:_height,round:8})});
        overState.addChild(newShape({x:2,y:2},{graphics:toDrawRect({color:0xEEEEEE,width:_width-4,height:_height-4,round:6})}));
        var downState:Sprite = newSprite({x:_x,y:_y},{graphics:toDrawRect({color:0xAAAAAA,width:_width,height:_height,round:8})});
        downState.addChild(newShape({x:2,y:2},{graphics:toDrawRect({color:0xDDDDDD,width:_width-4,height:_height-4,round:6})}));
        var hitTestState:Shape = newShape({x:_x,y:_y},{graphics:toDrawRect({width:_width,height:_height,round:8})});
        if(x_y_w_h_txt[4]){
            upState.addChild(newTextField({x:0,y:2,width:x_y_w_h_txt[2],height:x_y_w_h_txt[3]-2,text:x_y_w_h_txt[4],setTextFormat:[{font:"_sans",align:"center"}]}));
            overState.addChild(newTextField({x:0,y:2,width:x_y_w_h_txt[2],height:x_y_w_h_txt[3]-2,text:x_y_w_h_txt[4],setTextFormat:[{font:"_sans",align:"center"}]}));
            downState.addChild(newTextField({x:0,y:3,width:x_y_w_h_txt[2],height:x_y_w_h_txt[3]-3,text:x_y_w_h_txt[4],setTextFormat:[{font:"_sans",align:"center"}]}));
        }
        var sb:SimpleButton = new SimpleButton(upState,overState,downState,hitTestState);
        return sb;
    }
    public static function toDrawRect(... args):Array{
        var _x:Number = args[0]["x"]?args[0]["x"]:0;
        var _y:Number = args[0]["y"]?args[0]["y"]:0;
        var _width:Number = args[0]["width"]?args[0]["width"]:100;
        var _height:Number = args[0]["height"]?args[0]["height"]:100;
        var _color:Number = args[0]["color"]?args[0]["color"]:0xFF0000;
        var _alpha:Number = args[0]["alpha"]?args[0]["alpha"]:1;
        var _round:Number = args[0]["round"]?args[0]["round"]:0;
        var _lineSize:Number = args[0]["lineSize"]?args[0]["lineSize"]:0;
        var _lineColor:Number = args[0]["lineColor"]?args[0]["lineColor"]:0;
        var _lineAlpha:Number = args[0]["lineAlpha"]?args[0]["lineAlpha"]:0;
        var _ellipseWidth:Number = args[0]["ellipseWidth"]?args[0]["ellipseWidth"]:_round;
        var _ellipseHeight:Number = args[0]["ellipseHeight"]?args[0]["ellipseHeight"]:_ellipseWidth;
        return [{beginFill:[_color,_alpha]},{drawRoundRect:[_x,_y,_width,_height,_ellipseWidth,_ellipseHeight]}];
    }
    public static function drawRect(... args):Object{
        var _x:Number = args[0]["x"]?args[0]["x"]:0;
        var _y:Number = args[0]["y"]?args[0]["y"]:0;
        var _width:Number = args[0]["width"]?args[0]["width"]:100;
        var _height:Number = args[0]["height"]?args[0]["height"]:100;
        var _color:Number = args[0]["color"]?args[0]["color"]:0xFF0000;
        var _alpha:Number = args[0]["alpha"]?args[0]["alpha"]:1;
        var _round:Number = args[0]["round"]?args[0]["round"]:0;
        var _lineSize:Number = args[0]["lineSize"]?args[0]["lineSize"]:0;
        var _lineColor:Number = args[0]["lineColor"]?args[0]["lineColor"]:0;
        var _lineAlpha:Number = args[0]["lineAlpha"]?args[0]["lineAlpha"]:1;
        var _ellipseWidth:Number = args[0]["ellipseWidth"]?args[0]["ellipseWidth"]:_round;
        var _ellipseHeight:Number = args[0]["ellipseHeight"]?args[0]["ellipseHeight"]:_ellipseWidth;
        var resultObj:Object;
		var _array:Array = [];
		_array.push({ beginFill:[_color, _alpha] });
		if (_lineSize > 0) {
			_array.push( { lineStyle:[_lineSize,_lineColor,_lineAlpha] } );
		}
        if(_round || _ellipseWidth || _ellipseHeight){
			_array.push( { drawRoundRect:[_x, _y, _width, _height, _ellipseWidth, _ellipseHeight] } );
        }else {
			_array.push( { drawRect:[_x, _y, _width, _height] } );
        }
		for (var i:int = 1; i < args.length; i++) {
			_array.push(args[i]);
		}
		resultObj = { graphics:_array };
        return resultObj;
    }
    public static function drawCircle(... args):Object{
        var _x:Number = args[0]["x"]?args[0]["x"]:0;
        var _y:Number = args[0]["y"]?args[0]["y"]:0;
        var _color:Number = args[0]["color"]?args[0]["color"]:0xFF0000;
        var _alpha:Number = args[0]["alpha"]?args[0]["alpha"]:1;
        var _r:Number = args[0]["r"]?args[0]["r"]:100;
        var _radius:Number = args[0]["radius"]?args[0]["radius"]:_r;
        var _width:Number = args[0]["width"]?args[0]["width"]:_radius;
        var _height:Number = args[0]["height"]?args[0]["height"]:_radius;
        var _lineSize:Number = args[0]["lineSize"]?args[0]["lineSize"]:0;
        var _lineColor:Number = args[0]["lineColor"]?args[0]["lineColor"]:0;
        var _lineAlpha:Number = args[0]["lineAlpha"]?args[0]["lineAlpha"]:0;
        var resultObj:Object;
        if(_width == _height){
            resultObj = { graphics:[ { beginFill:[_color, _alpha] }, { drawCircle:[_x, _y, _radius] } ] };
        }else {
            resultObj = { graphics:[ { beginFill:[_color, _alpha] }, { drawEllipse:[_x, _y, _width, _height] } ] };
        }
        return resultObj;
    }
    public static function newShape(... args):Shape{
        var sp:Shape;
        var _str:String;
        var _length:int = args.length;
        for (var i:int = 0; i < _length; i++) {
            var _obj:Object = args[i];
            if(i == 0){
                if(_obj.Shape){
                    sp = _obj.Shape;
                }else{
                    sp = new Shape();
                }
            }
            if(_obj.graphics){
                for (var j:int = 0; j < _obj.graphics.length; j++) {
                    if(_obj.graphics[j]){
                        for (_str in _obj.graphics[j]) {
                            //trace(_str,_obj.graphics[j][_str])
                            sp.graphics[_str].apply(null, _obj.graphics[j][_str]);
                        }
                    }
                }
            }
            for (_str in _obj) {
                if(_str != "Shape" && _str != "graphics"){
                    sp[_str] = _obj[_str];
                }
            }
        }
        return sp;
    }
    public static function newSprite(... args):Sprite{
        var sp:Sprite;
        var _str:String;
        var _length:int = args.length;
        for (var i:int = 0; i < _length; i++) {
            var _obj:Object = args[i];
            if(i == 0){
                if(_obj.Sprite){
                    sp = _obj.Sprite;
                }else{
                    sp = new Sprite();
                }
            }
            if(_obj.graphics){
                for (var j:int = 0; j < _obj.graphics.length; j++) {
                    if(_obj.graphics[j]){
                        for (_str in _obj.graphics[j]) {
                            sp.graphics[_str].apply(null, _obj.graphics[j][_str]);
                        }
                    }
                }
            }
            for (_str in _obj) {
                if(_str != "Sprite" && _str != "graphics" && _str != "addChild"){
                    sp[_str] = _obj[_str];
                }
            }
            if(_obj.addChild){
                sp.addChild(_obj.addChild);
            }
        }
        return sp;
    }
    public static function newTextField(... args):TextField{
        var ta:TextField = new TextField();
        ta.defaultTextFormat = defaultTextFormat;
        var _length:int = args.length;
        for (var i:int = 0; i < _length; i++) {
            var _obj:Object = args[i];
            for (var _str:String in _obj) {
                if(_str != "setTextFormat"){
                    ta[_str] = _obj[_str];
                }
            }
            if(_obj.setTextFormat){
                var format:TextFormat = new TextFormat();
                if(_obj.setTextFormat[0] is TextFormat){
                    format = _obj.setTextFormat[0];
                }else{
                    for (var tf_str:String in _obj.setTextFormat[0]) {
                        format[tf_str] = _obj.setTextFormat[0][tf_str];
                    }
                }
                ta.setTextFormat(format,isNaN(_obj.setTextFormat[1])?-1:_obj.setTextFormat[1],isNaN(_obj.setTextFormat[2])?-1:_obj.setTextFormat[2]);
            }
        }
        return ta;
    }
}


import flash.display.Loader;
import flash.net.URLRequest;
import flash.display.Sprite;
class arrayLoader {
	public function loadImg(arg_array:Array):Array {
		var _length:int = arg_array.length;
		var return_array:Array = new Array();
		var _n:int;
		for (var j:int=0; j<_length; j++) {
			var loader_obj:Loader = new Loader();
			var url:URLRequest = new URLRequest(arg_array[j]);
			loader_obj.load(url);
			loader_obj.name = String(j);
			var _sp:Sprite = new Sprite();
			_sp.addChild(loader_obj);
			return_array[_n] = _sp;
			_n ++;
		}
		return return_array;
	}
}


import flash.display.Sprite;
import flash.geom.Matrix;
import flash.display.*;
import flash.geom.*;
class render{
	public static var staV:uint=10;
	public static const VERSION:String = "beta1.2";
	public static function staTest():void {
		trace("staV=" + staV);
	}
	public var v:Number=0;
	public const K:Number =1.3;

	public function xRender(sp:Sprite,arg:Array,argObj:Object,isOnOff:Boolean,n:int):void {
		if(argObj.type == "fill"){
			fillRender(sp,arg,argObj);
		}else if(argObj.type == "item"){
			itemRender(sp,arg,argObj,n,isOnOff);
		}else if(argObj.type == "circle"){
			circleRender(sp,arg,argObj,isOnOff);
		}
	}
	private function itemRender(sp:Sprite,arg:Array,argObj:Object,n:int,isOnOff:Boolean):void {
		sp.graphics.clear();
		argObj.item.visible = isOnOff;
		if(!isOnOff){
			return;
		}
		sp = argObj.item;
		var _n:Number
		if(arg[0][2]<1){
			_n = (1-arg[0][2])*255
		}else{
			_n = 0;
		}
			var color:ColorTransform = new ColorTransform(1,1,1,1,_n,_n,_n,0);
			sp.transform.colorTransform = color;
		sp.x = 400+arg[0][0]-75/2;
		sp.y = 250+arg[0][1]-75/2;
		sp.scaleX = sp.scaleY = arg[0][2]/2;
		//swapChildren
		//stage.addChildAt(ap ,n);
	}
	private function fillRender(sp:Sprite,arg:Array,argObj:Object):void {
		sp.graphics.clear();
		sp.graphics.beginFill(argObj.fillColor,0.7);
		//sp.graphics.lineStyle(2, 0xcccccc,1);
		var _length:int = arg.length;
		sp.graphics.moveTo(arg[_length-1][0],arg[_length-1][1]);
		for (var i:int= 1; i<_length; i++) {
			sp.graphics.lineTo(arg[i][0],arg[i][1]);
		}
		sp.x = 400;
		sp.y = 250;
	}
	private function circleRenderG(sp:Sprite,arg:Array,argObj:Object,isOnOff:Boolean):void {
		sp.graphics.clear();
		if(!isOnOff){
			return;
		}
		var p_x:Number = arg[0][0];	// 中心座標
		var p_y:Number = arg[0][1];
		
		var radius:Number = arg[0][2]*8;	// 線の太さ
		
		
		var scale:Number = 1.0 / 1638.4 * radius * 2;
		var m : Matrix = new Matrix();
		m.identity();		// 正規化
		m.scale(scale , scale);	// 行列 *= スケーリング
		m.translate( p_x,p_y);	// 行列 *= 平行移動
		var ratios:Array;
		var alphas:Array;
		if(argObj.n < 5){
			alphas = [1.0,0.9,0];
			ratios = [0x64,0xc2,0xff];
		}else{
			alphas = [1,0.8,0];
			ratios = [0x0,0xc2,0xff];
			//ratios = [0x64,0xd2,0xff];
		}
		//sp.graphics.lineStyle (1, 0x000000, 1.0);	// 線のスタイル
		sp.graphics.beginGradientFill (		// 面のスタイル
			GradientType.RADIAL,
			[argObj.fillColor , argObj.fillColor , argObj.fillColor],alphas,ratios,m);
		
		sp.graphics.drawCircle (p_x, p_y , radius);
		sp.x = 400;
		sp.y = 250;
	}
	private function circleRender(sp:Sprite,arg:Array,argObj:Object,isOnOff:Boolean):void {
		sp.graphics.clear();
		if(!isOnOff){
			return;
		}
		sp.graphics.beginFill(argObj.fillColor,1);
		//sp.graphics.lineStyle(2, 0xcccccc,1);
		sp.graphics.drawCircle(arg[0][0],arg[0][1],arg[0][2]*6);
		sp.x = 400;
		sp.y = 250;
	}
}
import flash.system.Security;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.display.Loader;
//import flash.display.LoaderInfo;
class MultiLoaderClass extends Sprite{
	
	private var onComplete:Function = function(arg:Array=null):void{};
	//private var onOpen:Function = function():void{};
	private var loadNum:int;
	private var loadCompNum:int;
	private var error_array:Array = new Array();
	private var URLs_array:Array = new Array();
	public var _uniqueParam:String = "";
	
	public function set uniqueParam(uStr:String):void {
		if (uStr) {
			if (uStr.substr(0,2) == "?=") {
				_uniqueParam = uStr;
			}else {
				_uniqueParam = "?=" + uStr;
			}
		}else {
			_uniqueParam = "";
		}
	}
	public function get uniqueParam():String {
		return _uniqueParam;
	}
	
	public function MultiLoaderClass(_str:String = null,uStr:String = null){
		if(_str){
			Security.loadPolicyFile(_str);
		}
		uniqueParam = uStr;
	}
	
	public function setLoad(__item_array:Array = null, _onComp:Function = null):Array {
		//trace(__item_array)	
		loadCompNum = loadNum = 0;
		if(_onComp != null){
			onComplete = _onComp;
		}
		if (__item_array.length == 0) {
			loadNum ++;
			onComplete();
		}
		
		URLs_array = __item_array.concat();
		error_array = new Array();
		//trace(__item_array.length)
		//onOpen = _onOpen;
		var _array:Array = new Array();
		var _length:int = __item_array.length;
		for (var i:int = 0; i < _length; i++) {
			error_array[i] = false;
			if (__item_array[i] == null) { continue };
			var _extension:String = __item_array[i].substr(-4,4).toLowerCase();//拡張子を取り出す。
			if (_extension == ".xml" || _extension == "html") {
			//trace("**",__item_array[i]);	
				loadNum ++;
				_array[i] = fnURLLoader(__item_array[i] + uniqueParam);
			}else if(_extension == ".jpg" || _extension == ".gif" || _extension == ".png" || _extension == ".swf"){
				loadNum ++;
				_array[i] = img(__item_array[i] + uniqueParam);
			}else if(_extension == ".bin"){
				loadNum ++;
				__item_array[i] = __item_array[i].substr(0, __item_array[i].length - 4);
				_array[i] = binaryFromURL(__item_array[i] + uniqueParam);
			}else{
				//_array[i] = null;
			}
		}
		
		return _array;
	}
	private function binaryFromURL(__url:String):URLLoader{
		var _loader:URLLoader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY;
		_loader.addEventListener(Event.COMPLETE,completeHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_loader.load(new URLRequest(__url));
		return _loader;
	}
	
	private function fnURLLoader(__url:String):URLLoader{
		var _loader:URLLoader = new URLLoader();
		_loader.addEventListener(Event.COMPLETE,completeHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//_loader.addEventListener(Event.OPEN,openHandler);
		_loader.load(new URLRequest(__url));
		//trace(_loader.loaderInfo);//.loaderURL
		return _loader;
	}
	
	private function img(__url:String):Loader{
		var _loader:Loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//_loader.contentLoaderInfo.addEventListener(Event.OPEN,openHandler);
		_loader.load(new URLRequest(__url));
		//_loader.name = __url;
		
		return _loader;
	}
	
	private function completeHandler(event:Event = null):void {
		loadCompNum ++;
		if(loadCompNum == loadNum){
			onComplete(error_array);
		}
		//var loaderInfo:LoaderInfo=event.currentTarget as LoaderInfo;
		//var loader:Loader=loaderInfo.loader;
		//addChild(loader);
	}
	private function openHandler (event:Event):void {
		if(Math.random()>0.95){
			trace ("読み込みを開始した");
			//event.currentTarget.contentLoaderInfo.close();
			var str:String = event.currentTarget.toString().substr(8);
			if(str == "LoaderInfo]"){
				//event.currentTarget.contentLoaderInfo.close();
				//event.target.contentLoaderInfo.close();
				//event.currentTarget.close();
				//event.target.close();
			}else if(str == "URLLoader]"){
				event.currentTarget.close();
				completeHandler();
			}
			
			//completeHandler();
			//onOpen();
		}
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void {
		//event.text = "Error #2035: URL が見つかりません。 URL: file:///~~~~~";
		//event.text = "Error #2036: 読み込みが未完了です。 URL: http://~~~~~";
		//から、URLのみを取り出す。
		//trace(String(event.text).substr(String(event.text).indexOf(" URL: ")+6),"*****");
		for (var i:int = 0; i < URLs_array.length; i++) {
			var _str:String = String(event.text).substr(String(event.text).indexOf(" URL: ")+6).substr(-URLs_array[i].length);
			if(URLs_array[i] == _str){
				error_array[i] = true;
				//trace("これだ",i,_str)
			}
		}

		//URLs_array
		completeHandler();
	}
}	
////////////////////////////////////////////////////////////////