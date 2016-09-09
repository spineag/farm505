/**
 * Created by ndy on 30.07.2014.
 */
package utils {
import com.junkbyte.console.Cc;

import flash.geom.Matrix;

import manager.Vars;

import starling.display.DisplayObject;
import starling.textures.Texture;

import windows.WindowsManager;

public class MCScaler {
    static public function scale(graphics:DisplayObject, heightMax:int, widthMax:int):void {
        var s:Number;
        if (!graphics) {
            Cc.error('MCScaler:: graphics == null');
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
        if (!graphics) {
            Cc.error('MCScalerMin:: graphics == null');
            return;
        }
        if (graphics.height < 2 || graphics.width < 2) {
            return;
        }
        var s:Number;
        if (graphics.width > graphics.height) {
            s = heightMin/graphics.height;
        } else {
            s = widthMin/graphics.width;
        }

        graphics.width = s * graphics.width;
        graphics.height = s * graphics.height;
    }
    
    static public function scaleWithMatrix(graphics:DisplayObject, heightMax:int, widthMax:int):void {
        if (!graphics) {
            Cc.error('MCScalerWithMatrix:: graphics == null');
            return;
        }
        if (graphics.height < 2 || graphics.width < 2) {
            return;
        }
        var s:Number;
        s = Math.min(1, widthMax / graphics.width, heightMax / graphics.height);
        var matrix:Matrix = graphics.transformationMatrix;
//        matrix.translate(-graphics.width / 2, -graphics.height / 2);
//        matrix.rotate(3.14159);
        matrix.scale(s, s);
        graphics.transformationMatrix = matrix;
    }
}
}
