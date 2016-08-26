package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;

import starling.core.Starling;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.rendering.Painter;

public class DrawToBitmap {
    private static var g:Vars = Vars.getInstance();

    public static function drawToBitmap(starling:Starling, displayObject:DisplayObject):Bitmap {
        var resultBitmap:Bitmap = new Bitmap(copyToBitmapData(starling, displayObject));
        return resultBitmap;
    }

    public static function copyToBitmapData(starling:Starling, disp:DisplayObject):BitmapData {
        var bounds:Rectangle = disp.getBounds(disp);
        var result:BitmapData = new BitmapData(bounds.width, bounds.height, true);
        var stage:Stage = g.mainStage;
        var painter:Painter = starling.painter;

        painter.pushState();
        painter.state.renderTarget = null;
        painter.state.setProjectionMatrix(bounds.x, bounds.y, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
        painter.clear();
        disp.setRequiresRedraw();
        disp.render(painter);
        painter.finishMeshBatch();
        painter.context.drawToBitmapData(result);
        painter.context.present();
        painter.popState();

        return result;
    }
    
}
}

