/**
 * Created by user on 12/2/15.
 */
package manager {
import starling.filters.BlurFilter;
import starling.utils.Color;

public class ManagerFilters {
    public static var RED_STROKE:BlurFilter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
    public static var GREEN_STROKE:BlurFilter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
    public static var YELLOW_STROKE:BlurFilter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);

    public static var SHADOW:BlurFilter = BlurFilter.createDropShadow(1, 0.785, 0, 1, 1.0, 0.5);
    public static var SHADOW_TOP:BlurFilter = BlurFilter.createDropShadow(1, 0.285, 0, 1, 1.0, 0.5);

    public static var TEXT_BROWN:int = 0x593b02;
}
}
