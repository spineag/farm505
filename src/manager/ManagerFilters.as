/**
 * Created by user on 12/2/15.
 */
package manager {
import flash.filters.GlowFilter;

import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

public class ManagerFilters {
    public static var RED_STROKE:BlurFilter = BlurFilter.createGlow(Color.RED, 4, 2, 1);
    public static var GREEN_STROKE:BlurFilter = BlurFilter.createGlow(Color.GREEN, 4, 2, 1);
    public static var YELLOW_STROKE:BlurFilter = BlurFilter.createGlow(Color.YELLOW, 4, 2, 1);
    public static var WHITE_STROKE:BlurFilter = BlurFilter.createGlow(Color.WHITE, 4, 2, 1);
    public static var BUILD_STROKE:BlurFilter = BlurFilter.createGlow(0xeffd98, 4, 2, 1);

    public static var SHADOW:BlurFilter = BlurFilter.createDropShadow(2, .8, 0, 1, 1.0, 0.5);
    public static var SHADOW_LIGHT:BlurFilter = BlurFilter.createDropShadow(2, .8, 0, .7, .5, 0.5);
    public static var SHADOW_TINY:BlurFilter = BlurFilter.createDropShadow(1, 0.8, 0, .5, .5, 0.5);
    public static var SHADOW_TOP:BlurFilter = BlurFilter.createDropShadow(1, -.8, 0, 1, 1.0, 0.5);

    public static var TEXT_BROWN:int = 0x593b02;
    public static var TEXT_ORANGE:int = 0xd06d0a;
    public static var TEXT_GREEN:int = 0x10650a;
    public static var TEXT_YELLOW:int = 0xa37b01;
    public static var TEXT_BLUE:int = 0x0659b6;
    public static var TEXT_LIGHT_BLUE:int = 0x1377ab;
    public static var TEXT_GRAY_HARD:int = 0x444444;

    public static var TEXT_STROKE_ORANGE:Array = [new GlowFilter(TEXT_ORANGE, 1, 3, 3, 5)];
    public static var TEXT_STROKE_GREEN:Array = [new GlowFilter(TEXT_GREEN, 1, 3, 3, 5)];
    public static var TEXT_STROKE_YELLOW:Array = [new GlowFilter(TEXT_YELLOW, 1, 3, 3, 5)];
    public static var TEXT_STROKE_BLUE:Array = [new GlowFilter(TEXT_BLUE, 1, 3, 3, 5)];
    public static var TEXT_STROKE_LIGHT_BLUE:Array = [new GlowFilter(TEXT_LIGHT_BLUE, 1, 3, 3, 5)];
    public static var TEXT_STROKE_WHITE:Array = [new GlowFilter(Color.WHITE, 1, 3, 3, 5)];
    public static var TEXT_STROKE_BROWN:Array = [new GlowFilter(TEXT_BROWN, 1, 3, 3, 5)];
    public static var TEXT_STROKE_RED:Array = [new GlowFilter(Color.RED, 1, 3, 3, 5)];
    public static var TEXT_STROKE_GRAY:Array = [new GlowFilter(TEXT_GRAY_HARD, 1, 3, 3, 5)];
    public static var TEXT_STROKE_BROWN_BIG:Array = [new GlowFilter(TEXT_BROWN, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BLUE_BIG:Array = [new GlowFilter(TEXT_BLUE, 1, 4, 4, 5)];
    public static var TEXT_STROKE_GREEN_BIG:Array = [new GlowFilter(TEXT_GREEN, 1, 4, 4, 5)];


    public static var BUILDING_HOVER_FILTER:ColorMatrixFilter;
    public static var BUTTON_HOVER_FILTER:ColorMatrixFilter;
    public static var BUTTON_CLICK_FILTER:ColorMatrixFilter;
    public static var BUTTON_DISABLE_FILTER:ColorMatrixFilter;
    public static var YELLOW_TINT_FILTER:ColorMatrixFilter;
    public static var RED_TINT_FILTER:ColorMatrixFilter;
    public static var RED_LIGHT_TINT_FILTER:ColorMatrixFilter;

    public function ManagerFilters() {
        BUTTON_DISABLE_FILTER = new ColorMatrixFilter();
        BUTTON_DISABLE_FILTER.adjustSaturation(-.95);

        BUTTON_HOVER_FILTER = new ColorMatrixFilter();
        BUTTON_HOVER_FILTER.adjustBrightness(.07);

        BUTTON_CLICK_FILTER = new ColorMatrixFilter();
        BUTTON_CLICK_FILTER.adjustBrightness(-.07);

        YELLOW_TINT_FILTER = new ColorMatrixFilter();
        YELLOW_TINT_FILTER.tint(Color.YELLOW, .5);

        RED_TINT_FILTER = new ColorMatrixFilter();
        RED_TINT_FILTER.tint(Color.RED, 1);

        RED_LIGHT_TINT_FILTER = new ColorMatrixFilter();
        RED_LIGHT_TINT_FILTER.tint(Color.RED, .4);

        BUILDING_HOVER_FILTER = new ColorMatrixFilter();
        BUILDING_HOVER_FILTER.adjustBrightness(.1);
    }
}
}
