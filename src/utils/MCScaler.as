/**
 * Created by ndy on 30.07.2014.
 */
package utils {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.DisplayObject;

public class MCScaler {
    static public function scale(graphics:DisplayObject, heightMax:int, widthMax:int):void {
        var s:Number;

        if (!graphics) {
            Cc.error('MCScaler:: graphics == null');
            Vars.getInstance().woGameError.showIt();
            return;
        }

        if (graphics.height < 2 || graphics.width < 2) {
            return;
        }

        s = Math.min(1, widthMax / graphics.width, heightMax / graphics.height);
        graphics.width = s * graphics.width;
        graphics.height = s * graphics.height;
    }

    static public function scaleMin(graphics:DisplayObject, heightMin:int, widthMin:int):void {
        var s:Number;

        if (!graphics) {
            Cc.error('MCScaler:: graphics == null');
            Vars.getInstance().woGameError.showIt();
            return;
        }

        if (graphics.height < 2 || graphics.width < 2) {
            return;
        }

        if (graphics.width > graphics.height) {
            s = heightMin/graphics.height;
        } else {
            s = widthMin/graphics.width;
        }

        graphics.width = s * graphics.width;
        graphics.height = s * graphics.height;
    }
}
}
