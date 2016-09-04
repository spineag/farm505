/**
 * Created by andy on 9/2/16.
 */
package utils {
import manager.ManagerFilters;
import manager.Vars;

import starling.filters.FragmentFilter;

import starling.styles.DistanceFieldStyle;
import starling.text.TextField;
import starling.text.TextFormat;

public class CTextField extends TextField {
    public static var BOLD14:String = 'BloggerBold14';
    public static var BOLD18:String = 'BloggerBold18';
    public static var BOLD24:String = 'BloggerBold24';
    public static var BOLD30:String = 'BloggerBold30';
    public static var BOLD72:String = 'BloggerBold72';
    public static var MEDIUM14:String = 'BloggerMedium14';
    public static var MEDIUM18:String = 'BloggerMedium18';
    public static var MEDIUM24:String = 'BloggerMedium24';
    public static var MEDIUM30:String = 'BloggerMedium30';
    public static var REGULAR14:String = 'BloggerRegular14';
    public static var REGULAR18:String = 'BloggerRegular18';
    public static var REGULAR24:String = 'BloggerRegular24';
    public static var REGULAR30:String = 'BloggerRegular30';

    private var _deltaOwnX:int = 0;
    private var _deltaOwnY:int = 0;
    private var g:Vars = Vars.getInstance();

    public function CTextField(width:int, height:int, text:String="", format:TextFormat=null) {
        super(width, height, text, format);
        super.touchable = false;
        super.autoScale = true;
    }

    public function setFormat(type:String, size:int, color:uint, colorStroke:uint = 0xabcdef):void {
        if (!g.allData.bFonts[type]) type = 'BloggerBold24';
        super.format.setTo(g.allData.bFonts[type], size, color);
        if (colorStroke == 0xabcdef) {
            setEmptyStyle();
        } else {
            setStrokeStyle(colorStroke);
        }
    }

    private function setStrokeStyle(color:uint):void {
        var s:DistanceFieldStyle = new DistanceFieldStyle(.5, .2);
        s.setupOutline(.5, color);
        super.style = s;
        // fix x and y position for text with distance
        if (format.size < 18) {
            deltaOwnX = -7;
            deltaOwnY = -2;
        } else if (format.size < 22) {
            deltaOwnX = -5;
            deltaOwnY = -2;
        } else if (format.size < 32) {
            deltaOwnX = -4;
            deltaOwnY = -3;
        } else {
            deltaOwnX = -2;
        }
//        txt.border = true;
    }

    private function setEmptyStyle():void {
        var s:DistanceFieldStyle = new DistanceFieldStyle(.5, .25);
        super.style = s;
        // fix x and y position for text with distance
        if (format.size < 18) {
            deltaOwnX = -7;
            deltaOwnY = -2;
        } else if (format.size < 22) {
            deltaOwnX = -5;
            deltaOwnY = -2;
        } else if (format.size < 32) {
            deltaOwnX = -4;
            deltaOwnY = -3;
        } else {
            deltaOwnX = -2;
        }
//        txt.border = true;
    }

    // own adds by spineag
    public function set deltaOwnX(v:int):void { _deltaOwnX = v; this.x = x}
    public function set deltaOwnY(v:int):void { _deltaOwnY = v; this.y = y}

    override public function set x(value:Number):void {
        value += _deltaOwnX;
        super.x=value;
    }
    override public function set y(value:Number):void {
        value += _deltaOwnY;
        super.y=value;
    }

    override public function set filter(value:FragmentFilter):void {
        super.filter = value;
    }
}
}
