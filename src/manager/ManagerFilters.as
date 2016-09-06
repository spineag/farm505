/**
 * Created by user on 12/2/15.
 */
package manager {

import starling.filters.ColorMatrixFilter;
import starling.filters.DropShadowFilter;
import starling.filters.GlowFilter;
import starling.styles.DistanceFieldStyle;
import starling.text.TextField;
import starling.utils.Color;

public class ManagerFilters {
    public static var TEXT_BROWN_COLOR:int = 0x593b02;
    public static var TEXT_ORANGE_COLOR:int = 0xd06d0a; 
    public static var TEXT_LIGHT_GREEN_COLOR:int = 0x40f61c;  
    public static var TEXT_GREEN_COLOR:int = 0x10650a;
    public static var TEXT_USUAL_GREEN_COLOR:int = 0x367f30;
    public static var TEXT_YELLOW_COLOR:int = 0xa37b01;
    public static var LIGHT_YELLOW_COLOR:int = 0xeffd98;
    public static var TEXT_LIGHT_BLUE_COLOR:int = 0x1377ab;
    public static var TEXT_GRAY_HARD_COLOR:int = 0x444444;
    public static var TEXT_BLUE_COLOR:int = 0x0968b1;
    public static var TEXT_LIGHT_BROWN:int = 0xa57728;

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
        return new GlowFilter(Color.RED);
    }

    public static function get YELLOW_STROKE():GlowFilter {
        return new GlowFilter(Color.YELLOW);
    }

    public static function get WHITE_STROKE():GlowFilter {
        return new GlowFilter(Color.WHITE);
    }

    public static function get BUILD_STROKE():GlowFilter {
        return new GlowFilter(LIGHT_YELLOW_COLOR);
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
    
}
}
