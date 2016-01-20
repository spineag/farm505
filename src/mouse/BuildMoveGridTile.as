/**
 * Created by yusjanja on 11.08.2015.
 */
package mouse {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

public class BuildMoveGridTile {
    public static const TYPE_IN:int = 1;
    public static const TYPE_BORDER:int = 2;
    public static const TYPE_BORDER_OUT:int = 3;
    private var indexX:int;
    private var indexY:int;
    public var source:Sprite;
    private var imGreen:Image;
    private var imRed:Image;
    private var _type:int;

    private var g:Vars = Vars.getInstance();

    public function BuildMoveGridTile(i:int, j:int) {
        indexX = i;
        indexY = j;
        source = new Sprite();
    }

    public function setType(a:int):void {
        _type = a;
        switch (a) {
            case TYPE_IN:
                imGreen = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_tile'));
                imRed = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_tile'));
                break;
            case TYPE_BORDER:
                imGreen = new Image(g.allData.atlas['interfaceAtlas'].getTexture('empty_green_tile'));
                imRed = new Image(g.allData.atlas['interfaceAtlas'].getTexture('empty_red_tile'));
                break;
            case TYPE_BORDER_OUT:
                imGreen = new Image(g.allData.atlas['interfaceAtlas'].getTexture('empty_green_tile'));
                imRed = new Image(g.allData.atlas['interfaceAtlas'].getTexture('empty_red_tile'));
                source.alpha = .7;
                break;
        }
        if (!imGreen || !imRed) {
            Cc.error('BuildMoveGridTile:: no image');
        }

        imGreen.pivotX = imGreen.width/2;
        imRed.pivotX = imRed.width/2;
        imGreen.scaleX = imGreen.scaleY = g.scaleFactor;
        imRed.scaleX = imRed.scaleY = g.scaleFactor;
        imGreen.y = imRed.y = 3;
        source.addChild(imGreen);
        source.addChild(imRed);
        imGreen.visible = false;
        imRed.visible = false;
    }

    public function setFree(value:Boolean):void {
        imGreen.visible = value;
        imRed.visible = !value;
    }

    public function get type():int {
        return _type;
    }

    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        imGreen.dispose();
        imRed.dispose();
        source = null;
        imGreen = null;
        imRed = null;
    }
}
}
