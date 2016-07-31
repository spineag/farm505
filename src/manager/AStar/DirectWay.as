/**
 * Created by andy on 7/30/16.
 */
package manager.AStar {
import com.junkbyte.console.Cc;

import flash.geom.Point;

public class DirectWay {
    public function DirectWay() {
    }

    public static function getDirectXYWay(pStartX:int, pStartY:int, pEndX:int, pEndY:int):Array {
        var way:Array = [];
        var p:Point = new Point(pStartX, pStartY);
        var i:int;
        var wayLength:int;
        way.push(p);
        // путь только по ординате или абсцисе
        if (pStartX == pEndX) {
            if (pStartY == pEndY) return way;
            if (pStartY > pEndY) {
                wayLength = pStartY - pEndY;
                for (i=0; i<wayLength; i++) {
                    p = new Point(pStartX, pStartY-1 - i);
                    way.push(p);
                }
            } else {
                wayLength = pEndY - pStartY;
                for (i=0; i<wayLength; i++) {
                    p = new Point(pStartX, pStartY+1 + i);
                    way.push(p);
                }
            }
        } else if (pStartY == pEndY) {
            if (pStartX == pEndX) return way;
            if (pStartX > pEndX) {
                wayLength = pStartX - pEndX;
                for (i=0; i<wayLength; i++) {
                    p = new Point(pStartX-1 - i, pStartY);
                    way.push(p);
                }
            } else {
                wayLength = pEndX - pStartX;
                for (i=0; i<wayLength; i++) {
                    p = new Point(pStartX+1 + i, pStartY);
                    way.push(p);
                }
            }
        } else Cc.error('wrong parameters for DirectWay:: getDirectWay');
        return way;
    }
}
}
