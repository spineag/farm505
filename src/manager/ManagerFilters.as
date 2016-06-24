/**
 * Created by user on 12/2/15.
 */
package manager {
import flash.filters.GlowFilter;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

public class ManagerFilters {
    private static var _RED_STROKE:BlurFilter;
    private static var _GREEN_STROKE:BlurFilter;
    private static var _YELLOW_STROKE:BlurFilter;
    private static var _WHITE_STROKE:BlurFilter;
    private static var _BUILD_STROKE:BlurFilter;

    private static var _SHADOW:BlurFilter;
    private static var _SHADOW_LIGHT:BlurFilter;
    private static var _SHADOW_TINY:BlurFilter;
    private static var _SHADOW_TOP:BlurFilter;

    public static var TEXT_BROWN_COLOR:int = 0x593b02;
    public static var TEXT_ORANGE_COLOR:int = 0xd06d0a;
    public static var TEXT_GREEN_COLOR:int = 0x10650a;
    public static var TEXT_YELLOW_COLOR:int = 0xa37b01;
    public static var TEXT_BLUE_COLOR:int = 0x0659b6;
    public static var TEXT_LIGHT_BLUE_COLOR:int = 0x1377ab;
    public static var TEXT_GRAY_HARD_COLOR:int = 0x444444;
    public static var TEXT_BLUE_HARD:int = 0x0184df;

    public static var TEXT_STROKE_ORANGE:Array = [new GlowFilter(TEXT_ORANGE_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_GREEN:Array = [new GlowFilter(TEXT_GREEN_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_YELLOW:Array = [new GlowFilter(TEXT_YELLOW_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BLUE:Array = [new GlowFilter(TEXT_BLUE_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_LIGHT_BLUE:Array = [new GlowFilter(TEXT_LIGHT_BLUE_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_WHITE:Array = [new GlowFilter(Color.WHITE, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BROWN:Array = [new GlowFilter(TEXT_BROWN_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_RED:Array = [new GlowFilter(Color.RED, 1, 4, 4, 5)];
    public static var TEXT_STROKE_GRAY:Array = [new GlowFilter(TEXT_GRAY_HARD_COLOR, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BROWN_BIG:Array = [new GlowFilter(TEXT_BROWN_COLOR, 1, 6, 6, 5)];
    public static var TEXT_STROKE_BLUE_BIG:Array = [new GlowFilter(TEXT_BLUE_COLOR, 1, 6, 6, 5)];
    public static var TEXT_STROKE_GREEN_BIG:Array = [new GlowFilter(TEXT_GREEN_COLOR, 1, 6, 6, 5)];


    private static var _BUILDING_HOVER_FILTER:ColorMatrixFilter;
    private static var _BUTTON_HOVER_FILTER:ColorMatrixFilter;
    private static var _BUTTON_CLICK_FILTER:ColorMatrixFilter;
    private static var _BUTTON_DISABLE_FILTER:ColorMatrixFilter;
    private static var _YELLOW_TINT_FILTER:ColorMatrixFilter;
    private static var _RED_TINT_FILTER:ColorMatrixFilter;
    private static var _RED_LIGHT_TINT_FILTER:ColorMatrixFilter;

    public function ManagerFilters() {}

    public static function get SHADOW():BlurFilter {
        if (!_SHADOW) _SHADOW = BlurFilter.createDropShadow(2, .8, 0, 1, 1.0, 0.5);
        return _SHADOW;
    }

    public static function get NEW_SHADOW():BlurFilter {
        return BlurFilter.createDropShadow(2, .8, 0, 1, 1.0, 0.5);
    }

    public static function get SHADOW_LIGHT():BlurFilter {
        if (!_SHADOW_LIGHT) _SHADOW_LIGHT = BlurFilter.createDropShadow(2, .8, 0, .7, .5, 0.5);
        return _SHADOW_LIGHT;
    }

    public static function get SHADOW_TINY():BlurFilter {
        if (!_SHADOW_TINY) _SHADOW_TINY = BlurFilter.createDropShadow(1, 0.8, 0, .5, .5, 0.5);
        return _SHADOW_TINY;
    }

    public static function get SHADOW_TOP():BlurFilter {
        if (!_SHADOW_TOP) _SHADOW_TOP = BlurFilter.createDropShadow(1, -.8, 0, 1, 1.0, 0.5);
        return _SHADOW_TOP;
    }

    public static function get RED_STROKE():BlurFilter {
        if (!_RED_STROKE) _RED_STROKE = BlurFilter.createGlow(Color.RED, 4, 2, 1);
        return _RED_STROKE;
    }

    public static function get GREEN_STROKE():BlurFilter {
        if (!_GREEN_STROKE) _GREEN_STROKE = BlurFilter.createGlow(Color.GREEN, 4, 2, 1);
        return _GREEN_STROKE;
    }

    public static function get YELLOW_STROKE():BlurFilter {
        if (!_YELLOW_STROKE) _YELLOW_STROKE = BlurFilter.createGlow(Color.YELLOW, 4, 2, 1);
        return _YELLOW_STROKE;
    }

    public static function get WHITE_STROKE():BlurFilter {
        if (!_WHITE_STROKE) _WHITE_STROKE = BlurFilter.createGlow(Color.WHITE, 4, 2, 1);
        return _WHITE_STROKE;
    }

    public static function get BUILD_STROKE():BlurFilter {
        if (!_BUILD_STROKE) _BUILD_STROKE = BlurFilter.createGlow(0xeffd98, 4, 2, 1);
        return _BUILD_STROKE;
    }

    public static function get BUTTON_CLICK_FILTER():ColorMatrixFilter {
        if (!_BUTTON_CLICK_FILTER) {
            _BUTTON_CLICK_FILTER = new ColorMatrixFilter();
            _BUTTON_CLICK_FILTER.adjustBrightness(-.07);
        }
        return _BUTTON_CLICK_FILTER;
    }

    public static function get BUTTON_DISABLE_FILTER():ColorMatrixFilter {
        if (!_BUTTON_DISABLE_FILTER) {
            _BUTTON_DISABLE_FILTER = new ColorMatrixFilter();
            _BUTTON_DISABLE_FILTER.adjustSaturation(-.95);
        }
        return _BUTTON_DISABLE_FILTER;
    }

    public static function get BUTTON_HOVER_FILTER():ColorMatrixFilter {
        if (!_BUTTON_HOVER_FILTER) {
            _BUTTON_HOVER_FILTER = new ColorMatrixFilter();
            _BUTTON_HOVER_FILTER.adjustBrightness(.04);
        }
        return _BUTTON_HOVER_FILTER;
    }

    public static function get YELLOW_TINT_FILTER():ColorMatrixFilter {
        if (!_YELLOW_TINT_FILTER) {
            _YELLOW_TINT_FILTER = new ColorMatrixFilter();
            _YELLOW_TINT_FILTER.tint(Color.YELLOW, .5);
        }
        return _YELLOW_TINT_FILTER;
    }

    public static function get RED_TINT_FILTER():ColorMatrixFilter {
        if (!_RED_TINT_FILTER) {
            _RED_TINT_FILTER = new ColorMatrixFilter();
            _RED_TINT_FILTER.tint(Color.RED, 1);
        }
        return _RED_TINT_FILTER;
    }

    public static function get RED_LIGHT_TINT_FILTER():ColorMatrixFilter {
        if (!_RED_LIGHT_TINT_FILTER) {
            _RED_LIGHT_TINT_FILTER = new ColorMatrixFilter();
            _RED_LIGHT_TINT_FILTER.tint(Color.RED, .4);
        }
        return _RED_LIGHT_TINT_FILTER;
    }

    public static function get BUILDING_HOVER_FILTER():ColorMatrixFilter {
        if (!_BUILDING_HOVER_FILTER) {
            _BUILDING_HOVER_FILTER = new ColorMatrixFilter();
            _BUILDING_HOVER_FILTER.adjustBrightness(.1);
        }
        return _BUILDING_HOVER_FILTER;
    }
}
}
