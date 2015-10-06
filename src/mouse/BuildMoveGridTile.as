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
                imGreen = new Image(g.interfaceAtlas.getTexture('green_tail'));
                imRed = new Image(g.interfaceAtlas.getTexture('red_tail'));
                source.alpha = .7;
                break;
            case TYPE_BORDER:
                imGreen = new Image(g.interfaceAtlas.getTexture('empty_green_tail'));
                imRed = new Image(g.interfaceAtlas.getTexture('empty_red_tail'));
                source.alpha = .5;
                break;
            case TYPE_BORDER_OUT:
                imGreen = new Image(g.interfaceAtlas.getTexture('empty_green_tail'));
                imRed = new Image(g.interfaceAtlas.getTexture('empty_red_tail'));
                source.alpha = .3;
                break;
        }
        if (!imGreen || !imRed) {
            Cc.error('BuildMoveGridTile:: no image');
        }

        imGreen.pivotX = imGreen.width/2;
        imRed.pivotX = imRed.width/2;
        imGreen.scaleX = imGreen.scaleY = 2;
        imRed.scaleX = imRed.scaleY = 2;
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
