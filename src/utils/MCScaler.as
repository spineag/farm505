/**
 * Created by ndy on 30.07.2014.
 */
package utils {
import starling.display.DisplayObject;

;

public class MCScaler {
    static public function scale(graphics:DisplayObject, heightMax:int, widthMax:int):void {
        var s:Number;

        if (graphics.height < 2 || graphics.width < 2) {
            return;
        }

        s = Math.min(1, widthMax / graphics.width, heightMax / graphics.height);
        graphics.width = s * graphics.width;
        graphics.height = s * graphics.height;
    }
}
}
