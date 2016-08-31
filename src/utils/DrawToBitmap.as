package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;

import starling.core.Starling;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Stage;
import starling.rendering.Painter;
import starling.textures.RenderTexture;
import starling.textures.Texture;

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

    public static function copyToBitmapDataFromFlashSprite(fsp:flash.display.Sprite, s:Number = 1):BitmapData {
        var m:Matrix = new Matrix();
        var bounds:Rectangle = fsp.getBounds(fsp);
        m.translate(-bounds.x, -bounds.y);
        if (s!=1) m.scale(s, s);
        var bd:BitmapData = new BitmapData(bounds.width*s, bounds.height*s);
        bd.draw(fsp, m);
        return bd;
    }

    public static function getTextureFromStarlingDisplayObject(disp:DisplayObject, scale:Number=1):Texture {
        var texture:RenderTexture = new RenderTexture(disp.width, disp.height, true, scale);
        texture.draw(disp);
        return texture;
    }

    public static function getBitmapFromTextureBitmapAndTextureXML(b:Bitmap, xml:XML, name:String):BitmapData {
        var resultBD:BitmapData;
        var xl:XML;
        for each (var prop:XML in xml.SubTexture) {
            if (prop.@name==name) {
                xl = prop;
                break;
            }
        }
        if (xl) {
            resultBD = new BitmapData(int(xl.@width), int(xl.@height));
            var m:Matrix = new Matrix();
            m.translate(-int(xl.@x), -int(xl.@y));
            resultBD.draw(b, m);
        }
        return resultBD;
    }
    
}
}


//var texture:RenderTexture = new RenderTexture(100, 100);
//texture.draw(sprite);
//
//var image:Image = new Image(texture);
//addChild(image);
