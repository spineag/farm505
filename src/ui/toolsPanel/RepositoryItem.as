/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class RepositoryItem {
    public var source:CSprite;
    private var _data:Object;
    private var _count:int;
    private var _txtCount:TextField;
    private var _box:RepositoryBox;

    private var g:Vars = Vars.getInstance();

    public function RepositoryItem() {
        source = new CSprite();
        var q:Quad = new Quad(90, 90, Color.OLIVE);
        q.alpha = .2 + Math.random()*.8;
        source.addChild(q);
    }

    public function fillIt(data:Object, count:int, box:RepositoryBox):void {
        if (!data) {
            Cc.error('RepoItem:: empty data');
            g.woGameError.showIt();
            return;
        }
        _data = data;
        _count = count;
        _box = box;
        var im:Image = new Image(g.tempBuildAtlas.getTexture(_data.image));
        MCScaler.scale(im, 90, 90);
        im.x = 45 - im.width/2;
        im.y = 45 - im.y/2;
        source.addChild(im);

        _txtCount = new TextField(30, 30, String(_count),"Arial", 18, Color.WHITE);
        _txtCount.x = 50;
        _txtCount.y = 65;
        source.addChild(_txtCount);
        source.endClickCallback = onClick;
    }

    public function clearIt():void {
        source.endClickCallback = null;
        while (source.numChildren) source.removeChildAt(0);
        _data = null;
    }

    private function onClick():void {
        if (_data.buildType == BuildType.DECOR_TAIL) {
            g.toolsModifier.startMoveTail(_data, afterMove, true);
        } else {
            g.toolsModifier.startMove(_data, afterMove, 1, true);
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        var dbId:int = g.userInventory.removeFromDecorInventory(_data.id);
        g.townArea.createNewBuild(_data, _x, _y, true, dbId);
        var p:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
        g.directServer.removeFromInventory(dbId, p.x, p.y, null);
        _count--;
        if (_count <= 0) {
            _box.visible = true;
        } else {
            _txtCount.text = String(_count);
        }
    }
}
}
