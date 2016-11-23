/**
 * Created by user on 12/2/15.
 */
package manager {

import flash.filters.BlurFilter;

import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.filters.DropShadowFilter;
import starling.filters.GlowFilter;
import starling.styles.DistanceFieldStyle;
import starling.text.TextField;
import starling.utils.Color;

public class ManagerFilters {
    public static var BROWN_COLOR:int = 0x593b02;
    public static var ORANGE_COLOR:int = 0xd06d0a; 
    public static var LIGHT_GREEN_COLOR:int = 0x40f61c;  
    public static var HARD_GREEN_COLOR:int = 0x10650a;
    public static var GREEN_COLOR:int = 0x29b21d;
    public static var YELLOW_COLOR:int = 0xa37b01;
    public static var HARD_YELLOW_COLOR:int = 0x72590c;
    public static var LIGHT_YELLOW_COLOR:int = 0xeffd98;
    public static var LIGHT_BLUE_COLOR:int = 0x1377ab;
    public static var GRAY_HARD_COLOR:int = 0x444444;
    public static var BLUE_COLOR:int = 0x0968b1;
    public static var LIGHT_BROWN:int = 0xa57728;

    public function ManagerFilters() {}

    public static function get SHADOW():DropShadowFilter {
        return new DropShadowFilter(2, .8, 0, 1, 1.0, 0.5);
    }

    public static function get SHADOW_LIGHT():DropShadowFilter {
        return new DropShadowFilter(2, .8, 0, .7, .5, 0.5);
    }

    public static function get SHADOW_TINY():DropShadowFilter {
        return new DropShadowFilter(1, 0.8, 0, .5, .5, 0.5);
    }

    public static function get SHADOW_TOP():DropShadowFilter {
        return new DropShadowFilter(1, -.8, 0, 1, 1.0, 0.5);
    }

    public static function get RED_STROKE():GlowFilter {
        return new GlowFilter(Color.RED, 3);
    }

    public static function get YELLOW_STROKE():GlowFilter {
        return new GlowFilter(Color.YELLOW, 3);
    }

    public static function get WHITE_STROKE():GlowFilter {
        return new GlowFilter(Color.WHITE, 3);
    }

    public static function get BUILD_STROKE():GlowFilter {
        return new GlowFilter(LIGHT_YELLOW_COLOR, 3);
    }

    public static function getButtonClickFilter():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustBrightness(-.07);
        return f;
    }

    public static function getButtonDisableFilter():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustSaturation(-.95);
        return f;
    }

    public static function getButtonHoverFilter():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustBrightness(.04);
        return f;
    }

    public static function get BUTTON_CLICK_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustBrightness(-.07);
        return f;
    }

    public static function get BUTTON_DISABLE_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustSaturation(-.95);
        return f;
    }

    public static function get BUTTON_HOVER_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustBrightness(.04);
        return f;
    }

    public static function get RED_TINT_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.tint(Color.RED, 1);
        return f;
    }

    public static function get RED_LIGHT_TINT_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.tint(Color.RED, .4);
        return f;
    }

    public static function get BUILDING_HOVER_FILTER():ColorMatrixFilter {
        var f:ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustBrightness(.1);
        return f;
    }

    public static function get HARD_BLUR():starling.filters.BlurFilter  {
        var f:starling.filters.BlurFilter = new starling.filters.BlurFilter(2, 2);
        return f;
    }
    
}
}
