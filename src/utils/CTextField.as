/**
 * Created by andy on 9/2/16.
 */
package utils {
import flash.display.Bitmap;
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.GlowFilter;
import starling.styles.DistanceFieldStyle;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;
import starling.utils.Color;

public class CTextField extends DisplayObjectContainer {
    public static var BOLD18:String = 'BloggerBold18';
    public static var BOLD24:String = 'BloggerBold24';
    public static var BOLD30:String = 'BloggerBold30';
    public static var BOLD72:String = 'BloggerBold72';
    public static var MEDIUM18:String = 'BloggerMedium18';
    public static var MEDIUM24:String = 'BloggerMedium24';
    public static var MEDIUM30:String = 'BloggerMedium30';
    public static var REGULAR18:String = 'BloggerRegular18';
    public static var REGULAR24:String = 'BloggerRegular24';
    public static var REGULAR30:String = 'BloggerRegular30';

    private var g:Vars = Vars.getInstance();
    private var _txt:TextField;
    private var _format:TextFormat;
    private var _style:DistanceFieldStyle;
    private var _text:String;
    private var _width:int;
    private var _height:int;
    private var _deltaOwnX:int = 0;
    private var _deltaOwnY:int = 0;
    private var _colorStroke:uint;
    private var _cacheIt:Boolean = true;
    private var _needCheckForASCIIChars:Boolean = false;
    private var _useArialVectorFont:Boolean = false;
    private var _imageText:Sprite;

    public function CTextField(width:int, height:int, text:String='') {
        if (!text) text = '';
        _width = width;
        _height = height;
        _text = text;
        _txt = new TextField(_width, _height, _text);
        this.addChild(_txt);
        if (text.length < 20) _txt.batchable = true;
        this.touchable = false;
        _txt.touchable = false;
        _txt.autoScale = true;
    }

    public function setFormat(type:String = 'BloggerBold24', size:int = 24, color:uint = Color.WHITE, colorStroke:uint = 0xabcdef):void {
        _colorStroke = colorStroke;
        _format = new TextFormat();
        _format.font = type;
        _format.size = size;
        _format.color = color;
        if (_txt) _txt.format = _format;
        if (_colorStroke == 0xabcdef) setEmptyStyle();
        else setStrokeStyle(_colorStroke);
    }

    private function setStrokeStyle(color:uint):void { // also fix x and y position for text with distance
        var u:Number = .25;
        if (_format.size < 17) {         deltaOwnX = -7;  deltaOwnY = -2;  u = .2;
        } else if (_format.size < 20) {  deltaOwnX = -5;  deltaOwnY = -3;  u = .25;
        } else if (_format.size <= 24) { deltaOwnX = -5;  deltaOwnY = -3;  u = .3;
        } else if (_format.size < 32) {  deltaOwnX = -4;  deltaOwnY = -3;  u = .4;
        } else { deltaOwnX = -2;  u = .5; }
        _style = new DistanceFieldStyle(.175, .5);
        _style.setupOutline(u, color);
        if (_txt) _txt.style = _style;
    }

    private function setEmptyStyle():void { // also fix x and y position for text with distance
        var s:Number = .125;
        if (_format.size < 17) {         deltaOwnX = -7;   deltaOwnY = -2;   s = .25;
        } else if (_format.size < 21) {  deltaOwnX = -5;   deltaOwnY = -2;   s = .175;
        } else if (_format.size < 25) {  deltaOwnX = -4;   deltaOwnY = -3;   s = .2;
        } else if (_format.size < 32) {  deltaOwnX = -4;   deltaOwnY = -3;   s = .25;
        } else { deltaOwnX = -2; }
        _style = new DistanceFieldStyle(s, .5);
        if (_txt) _txt.style = _style;
    }

    public function set text(s:String):void {
        if (!s) return;
        _text = s;
        if (_needCheckForASCIIChars && !_useArialVectorFont) checkForASCII();
        if (_useArialVectorFont) {
            if (_txt) {
                this.removeChild(_txt);
                _txt.dispose();
                _txt = null;
            }
            createImageText();
        } else {
            if (!_txt) return;
            _txt.batchable = false;
            if (_txt.filter && _cacheIt) _txt.filter.clearCache();
            _txt.text = _text;
            if (_txt.filter && _cacheIt) _txt.filter.cache();
            if (s.length < 20) _txt.batchable = true;
        }
    }

    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle {  if (_txt) return _txt.getBounds(targetSpace, out);  else return new Rectangle(_width, _height); }
    public function set needCheckForASCIIChars(v:Boolean):void { _needCheckForASCIIChars = v; }
    public function updateStrokePower(u:Number):void { _style.setupOutline(u, _colorStroke); }
    public function set alignH(value:String): void { _format.horizontalAlign = value; if (_txt) _txt.format.horizontalAlign = value; }
    public function set alignV(value:String): void { _format.verticalAlign = value; if (_txt) _txt.format.verticalAlign = value; }
    public function set deltaOwnX(v:int):void { _deltaOwnX = v; if (_txt) _txt.x = v; }
    public function set deltaOwnY(v:int):void { _deltaOwnY = v; if (_txt) _txt.y = v; }
    public function get textBounds():Rectangle { return _txt.textBounds; }
    public override function set width(value:Number):void { _width = value; if (_txt) _txt.width = value; }
    public override function set height(value:Number):void { _height = value; if (_txt) _txt.height = value; }
    public override function get width():Number { return _width; }
    public override function get height():Number { return _height; }
    public function get text():String { return _text; }
    public function get autoScale():Boolean { return _txt.autoScale; }
    public function set autoScale(value:Boolean):void { if (_txt) _txt.autoScale = value; }
    public function get autoSize():String { return _txt.autoSize; }
    public function set autoSize(value:String):void { if (_txt) _txt.autoSize = value; }
    public function get style():MeshStyle { return _txt.style; }
    public function set style(value:MeshStyle):void { if (_txt) _txt.style = value; }
    public function get format():TextFormat { return _format; }
    public function set format(value:TextFormat):void { _format = value;if (_txt)  _txt.format = _format; }
    public override function set touchable(value:Boolean):void { if (_txt) _txt.touchable = value; super.touchable = value; }
    public function set changeTextColor(color:uint):void { if (_txt) _txt.format.color = color; _format.color = color; }
    public function set changeSize(v:int):void { if (_txt) _txt.format.size = v; _format.size = v; }
    public function set leading(v:int):void { if (_txt) _txt.format.leading = v; _format.leading = v; }
    public function set border(v:Boolean):void { if (_txt) _txt.border = v; }

    public function set cacheIt(v:Boolean):void {
        _cacheIt = v;
        if (_colorStroke == 0xabcdef) return;
        if (!_txt) return;
        if (v) { if (_txt.filter) _txt.filter.cache();
        } else { if (_txt.filter) _txt.filter.clearCache(); }
    }

    public function deleteIt():void {
        _format = null;
        _style = null;
        dispose();
    }

    private function checkForASCII():void {
        var ar:Array = _text.split('');
        var count:int=0;
        for (var i:int=0; i<ar.length; i++) {
            if (!ASCIIchars.isCharInBitmapFont(ar[i])) {
//                trace('no symbol: ' + ar[i]);
                count++;
            }
        }
        if (count > 0) _useArialVectorFont = true;
    }

    private function createImageText():void {
        if (_imageText) {
            this.removeChild(_imageText);
            _imageText.dispose();
            _imageText = null;
        }
        _imageText = new Sprite();
        this.addChild(_imageText);
        var t:TextField = new TextField(_width, _height, _text);
        if (!_format) _format = new TextFormat();
        t.format.setTo('Arial Bold', _format.size, _format.color, _format.horizontalAlign);
        t.autoScale = true;
        if (_colorStroke != 0xabcdef) t.filter = new GlowFilter(_colorStroke, 3);
        var s:Sprite = new Sprite();
        s.addChild(t);
        var bd:Bitmap = DrawToBitmap.drawToBitmap(g.starling, s);
        var im:Image = new Image(Texture.fromBitmap(bd));
        _imageText.addChild(im);
        bd = null;
        s.dispose();
    }

}
}
