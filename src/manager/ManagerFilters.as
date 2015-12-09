/**
 * Created by user on 12/2/15.
 */
package manager {
import flash.filters.GlowFilter;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class ManagerFilters {
    public static var RED_STROKE:BlurFilter = BlurFilter.createGlow(Color.RED, 4, 2, 1);
    public static var GREEN_STROKE:BlurFilter = BlurFilter.createGlow(Color.GREEN, 4, 2, 1);
    public static var YELLOW_STROKE:BlurFilter = BlurFilter.createGlow(Color.YELLOW, 4, 2, 1);
    public static var WHITE_STROKE:BlurFilter = BlurFilter.createGlow(Color.WHITE, 4, 2, 1);

    public static var SHADOW:BlurFilter = BlurFilter.createDropShadow(1, 0.785, 0, 1, 1.0, 0.5);
    public static var SHADOW_TOP:BlurFilter = BlurFilter.createDropShadow(1, 0.285, 0, 1, 1.0, 0.5);

    public static var TEXT_BROWN:int = 0x593b02;
    public static var TEXT_ORANGE:int = 0xd06d0a;
    public static var TEXT_GREEN:int = 0x10650a;
    public static var TEXT_YELLOW:int = 0xa37b01;
    public static var TEXT_BLUE:int = 0x0659b6;

    public static var TEXT_STROKE_ORANGE:Array = [new GlowFilter(TEXT_ORANGE, 1, 4, 4, 5)];
    public static var TEXT_STROKE_GREEN:Array = [new GlowFilter(TEXT_GREEN, 1, 4, 4, 5)];
    public static var TEXT_STROKE_YELLOW:Array = [new GlowFilter(TEXT_YELLOW, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BLUE:Array = [new GlowFilter(TEXT_BLUE, 1, 4, 4, 5)];
    public static var TEXT_STROKE_WHITE:Array = [new GlowFilter(Color.WHITE, 1, 4, 4, 5)];
    public static var TEXT_STROKE_BROWN:Array = [new GlowFilter(TEXT_BROWN, 1, 4, 4, 5)];
    public static var TEXT_STROKE_RED:Array = [new GlowFilter(Color.RED, 1, 4, 4, 5)];
}
}
