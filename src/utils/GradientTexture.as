package utils
{
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;
import starling.textures.Texture;

public class GradientTexture {

    static public function createRadilGradientInCircle(r:int, colors:Array, alphas:Array):Texture {
        var s:Shape = new Shape();
        var mtx:Matrix = new Matrix();
        mtx.createGradientBox(r*2, r*2, 0, 0, 0);
        s.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, [0,255], mtx);
        s.graphics.drawCircle(r,r,r);
        s.graphics.endFill();
        var bitmapData:BitmapData = new BitmapData(r*2, r*2, true, 0x00ABCDEF);
        bitmapData.draw(s);
        return Texture.fromBitmapData(bitmapData);
    }
}
}