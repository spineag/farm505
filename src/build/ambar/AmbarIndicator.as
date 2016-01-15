/**
 * Created by user on 12/8/15.
 */
package build.ambar {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

public class AmbarIndicator {
    public var source:Sprite;
    private var _cont:Sprite;
    private var _maxY:int = 25; // ambar is full
    private var _minY:int = 260; // ambar is empty
    private var imLenta:Image;
    private var imBant:Image;
    private var g:Vars = Vars.getInstance();

    public function AmbarIndicator() {
        _maxY *= g.scaleFactor;
        _minY *= g.scaleFactor;
        source = new Sprite();
        _cont = new Sprite();
        _cont.clipRect = new flash.geom.Rectangle(0, 0, 74, 272);
        source.addChild(_cont);
        imLenta = new Image(g.allData.atlas['buildAtlas'].getTexture('ambar_indicator_main' ));
        imLenta.pivotX = imLenta.width/2;
        imLenta.x = 38 * g.scaleFactor;
        _cont.addChild(imLenta);
        _cont.y = _maxY;
        imBant  = new Image(g.allData.atlas['buildAtlas'].getTexture('ambar_indicator_top'));
        imBant.pivotX = imBant.width/2;
        imBant.pivotY = imBant.height/2;
        imBant.x = imLenta.x;
        imBant.y = _maxY;
        source.addChild(imBant);
    }

    public function updateProgress():void {
        var percent:Number = g.userInventory.currentCountInAmbar/g.user.ambarMaxCount;
        _cont.y = _maxY + (1-percent)*(_minY - _maxY);
        imLenta.y = -(1-percent)*(_minY - _maxY);
        imBant.y = _cont.y;
    }
}
}
