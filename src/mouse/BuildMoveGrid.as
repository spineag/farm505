/**
 * Created by yusjanja on 11.08.2015.
 */
package mouse {
import starling.display.Sprite;

public class BuildMoveGrid {
    private var _parent:Sprite;
    private var W:int;
    private var H:int;
    private var _source:Sprite;
    private var _arrCell:Array;

    public function BuildMoveGrid(p:Sprite, w:int, h:int) {
        _parent = p;
        W = w;
        H = h;
        _source = new Sprite();
        _parent.addChildAt(_source, 0);
    }
}
}
