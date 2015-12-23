/**
 * Created by user on 12/23/15.
 */
package utils {
import map.MatrixGrid;

import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

public class CreateTile{

    public static function createSimpleTile(w:int):Sprite {
        var s:Sprite = new Sprite();
        var realW:int = w*MatrixGrid.WIDTH_CELL;
        var q:Quad = new Quad(realW, realW, Color.BLUE);
        q.rotation = Math.PI/4;
        s.addChild(q);
        s.scaleY = 1/2;
        s.flatten();
        return s;
    }
}
}
