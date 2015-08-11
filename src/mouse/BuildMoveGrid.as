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
    private var _matrix:Array;

    public function BuildMoveGrid(p:Sprite, w:int, h:int) {
        _parent = p;
        W = w;
        H = h;
        _source = new Sprite();
        _parent.addChildAt(_source, 0);
        fillMatrix();
    }

    private function fillMatrix():void {
        var tile:BuildMoveGridTile;
        _matrix = [];
        for (var i:int = 0; i < W +4; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < H + 4; j++) {
                tile = new BuildMoveGridTile(i, j);
                _matrix[i][j] = tile;
                if (i == 0 || j == 0) {

                }
            }
        }
    }
}
}
