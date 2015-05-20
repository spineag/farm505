/**
 * Created by user on 5/20/15.
 */
package mouse {
import manager.Vars;

import starling.display.Image;

public class ToolsModifier {
    public static var NONE:int = 0;
    public static var MOVE:int = 1;

    private var _activeBuildingId:int;
    private var _imageForMove:Image;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
    }

    public function addMoveIcon(add:Boolean = true):void {
        // добавлення іконки пересування до мишки
    }

    public function startMove(buildingID:int, mouseX:Number, mouseY:Number):void {
        // реалізація пересування, поки тільки  для будівль

        addMoveIcon(false);
        _activeBuildingId = buildingID;
        switch (g.dataBuilding.objectBuilding[buildingID].image) {
            case "tile 3x3":
                _imageForMove = new Image(g.mapAtlas.getTexture("tile3x3"));
                break;
            case "tile 4x4":
                _imageForMove = new Image(g.mapAtlas.getTexture("tile4x4"));
                break;
        }

        _imageForMove.pivotX = _imageForMove.width/2;
        _imageForMove.pivotY = _imageForMove.height/2;
    }
}
}
