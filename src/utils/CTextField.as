/**
 * Created by andy on 9/2/16.
 */
package utils {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.filters.GlowFilter;
import starling.styles.DistanceFieldStyle;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
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

    private var _txt:TextField;
    private var _format:TextFormat;
    private var _style:DistanceFieldStyle;
    private var _text:String;
    private var _width:int;
    private var _height:int;
    private var _deltaOwnX:int = 0;
    private var _deltaOwnY:int = 0;
    private var _useBitmapFont:Boolean = true;
    private var _colorStroke:uint;
    private var _cacheIt:Boolean = true;

    public function CTextField(width:int, height:int, text:String="") {
        if (!text) {
            text = '';
        }
        _width = width;
        _height = height;
        _text = text;
        _txt = new TextField(_width, _height, _text);
        this.addChild(_txt);
        if (text.length < 20 && _useBitmapFont) _txt.batchable = true;
        this.touchable = false;
        _txt.touchable = false;
        _txt.autoScale = true;
    }

    public function set text(s:String):void {
        if (!s) return;
        if (_useBitmapFont) _txt.batchable = false;
        _text = s;
        if (_txt.filter && _cacheIt) {
            _txt.filter.clearCache();
        }
        _txt.text = _text;
        if (_txt.filter && _cacheIt) _txt.filter.cache();
        if (s.length < 20 && _useBitmapFont) _txt.batchable = true;
    }

    public function setFormat(type:String = 'BloggerBold24', size:int = 24, color:uint = Color.WHITE, colorStroke:uint = 0xabcdef):void {
        _colorStroke = colorStroke;
        _format = new TextFormat();
        if (_useBitmapFont) {
            _format.font = type;
            _format.size = size;
            _format.color = color;
            _txt.format = _format;
            if (colorStroke == 0xabcdef) {
                setEmptyStyle();
            } else {
                setStrokeStyle(colorStroke);
            }
        } else {
            var fontName:String;
            if (type == BOLD18 || type == BOLD24 || type == BOLD30 || type == BOLD72) {
                fontName = 'BloggerBold';
            } else if (type == MEDIUM18 || type == MEDIUM24 || type == MEDIUM30) {
                fontName = 'BloggerMedium';
            } else fontName = 'BloggerRegular';
            if (size <17 && colorStroke != 0xabcdef) {
                color = colorStroke;
                colorStroke = 0xabcdef;
                size += 2;
            }
            _colorStroke = colorStroke;
            _format.font = fontName;
            _format.size = size;
            _format.color = color;
            _txt.format = _format;
            if (colorStroke != 0xabcdef) {
                _txt.filter = new GlowFilter(colorStroke, 5, .7, 1);
                if (_cacheIt) _txt.filter.cache();
            }
        }
    }

    private function setStrokeStyle(color:uint):void {
        var u:Number = .25;
        // fix x and y position for text with distance
        if (_format.size < 17) {
            deltaOwnX = -7;
            deltaOwnY = -2;
            u = .2;
        } else if (_format.size < 20) {
            deltaOwnX = -5;
            deltaOwnY = -3;
            u = .25;
        } else if (_format.size <= 24) {
            deltaOwnX = -5;
            deltaOwnY = -3;
            u = .3;
        } else if (_format.size < 32) {
            deltaOwnX = -4;
            deltaOwnY = -3;
            u = .4;
        } else {
            deltaOwnX = -2;
            u = .5;
        }

        _style = new DistanceFieldStyle(.175, .5);
        _style.setupOutline(u, color);
        _txt.style = _style;
    }

    public function updateStrokePower(u:Number):void {
//        _style.setupBasic();
        _style.setupOutline(u, _colorStroke);
    }

    private function setEmptyStyle():void {
        var s:Number = .125;
        // fix x and y position for text with distance
        if (_format.size < 17) {
            deltaOwnX = -7;
            deltaOwnY = -2;
            s = .25;
        } else if (_format.size < 21) {
            deltaOwnX = -5;
            deltaOwnY = -2;
            s = .175;
        } else if (_format.size < 25) {
            deltaOwnX = -4;
            deltaOwnY = -3;
            s = .2;
        } else if (_format.size < 32) {
            deltaOwnX = -4;
            deltaOwnY = -3;
            s = .25;
        } else {
            deltaOwnX = -2;
        }
        _style = new DistanceFieldStyle(s, .5);
        _txt.style = _style;
    }

    public function set alignH(value:String): void { _format.horizontalAlign = value; _txt.format.horizontalAlign = value; }
    public function set alignV(value:String): void { _format.verticalAlign = value; _txt.format.verticalAlign = value; }
    public function set deltaOwnX(v:int):void { _deltaOwnX = v; _txt.x = v; }
    public function set deltaOwnY(v:int):void { _deltaOwnY = v; _txt.y = v; }
    public function deleteIt():void {
        _txt.dispose();
        _format = null;
        _style = null;
    }
    public function get textBounds():Rectangle { return _txt.textBounds; }
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle { return _txt.getBounds(targetSpace, out); }
    public override function set width(value:Number):void { _width = value; _txt.width = value; }
    public override function set height(value:Number):void { _height = value; _txt.height = value; }
    public override function get width():Number { return _width; }
    public override function get height():Number { return _height; }
    public function get text():String { return _text; }
    public function get autoScale():Boolean { return _txt.autoScale; }
    public function set autoScale(value:Boolean):void { _txt.autoScale = value; }
    public function get autoSize():String { return _txt.autoSize; }
    public function set autoSize(value:String):void { _txt.autoSize = value; }
    public function get style():MeshStyle { return _txt.style; }
    public function set style(value:MeshStyle):void { _txt.style = value; }
    public function get format():TextFormat { return _format; }
    public function set format(value:TextFormat):void { _format = value; _txt.format = _format; }
    public override function set touchable(value:Boolean):void { _txt.touchable = value; super.touchable = value; }
    public function set changeTextColor(color:uint):void { _txt.format.color = color; _format.color = color; }
    public function set changeSize(v:int):void { _txt.format.size = v; _format.size = v; }
    public function set leading(v:int):void { _txt.format.leading = v; _format.leading = v; }
    public function set border(v:Boolean):void { _txt.border = v; }
    public function set cacheIt(v:Boolean):void {
        _cacheIt = v;
        if (_useBitmapFont || _colorStroke == 0xabcdef) return;
        if (v) {
            if (_txt.filter) _txt.filter.cache();
        } else {
            if (_txt.filter) _txt.filter.clearCache();
        }
    }
}
}
