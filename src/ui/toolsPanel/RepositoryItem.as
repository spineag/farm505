/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import build.AreaObject;
import build.AreaObject;
import build.WorldObject;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.OwnEvent;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.events.Event;
import starling.filters.BlurFilter;
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
    private var _arrDbIds:Array;

    private var g:Vars = Vars.getInstance();

    public function RepositoryItem() {
        source = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('decor_cell'));
        im.width = im.height = 60;
        source.addChild(im);
    }

    public function fillIt(data:Object, count:int, arrIds:Array, box:RepositoryBox):void {
        if (!data) {
            Cc.error('RepoItem:: empty data');
            g.woGameError.showIt();
            return;
        }
        _data = data;
        _count = count;
        _box = box;
        _arrDbIds = arrIds;
        var im:Image = new Image(g.allData.atlas[_data.url].getTexture(_data.image));
        MCScaler.scale(im, 55, 55);
        im.x = 30 - im.width/2;
        im.y = 30 - im.height/2;
        source.addChild(im);

        _txtCount = new TextField(30,20,String(_count),g.allData.fonts['BloggerMedium'],14, ManagerFilters.TEXT_BROWN);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        _txtCount.x = 30;
        _txtCount.y = 40;
        source.addChild(_txtCount);
        source.endClickCallback = onClick;
    }

    public function clearIt():void {
        source.endClickCallback = null;
        while (source.numChildren) source.removeChildAt(0);
        _txtCount.dispose();
        _txtCount = null;
        _data = null;
        _arrDbIds.length = 0;
    }

    private function onClick():void {
        var build:AreaObject = g.townArea.createNewBuild(_data, _arrDbIds[0]);
        g.selectedBuild = build;
        if (_data.buildType == BuildType.DECOR_TAIL) {
            g.toolsModifier.startMoveTail(build, g.townArea.afterMoveFromInventory, true);
        } else {
            g.toolsModifier.startMove(build, g.townArea.afterMoveFromInventory, true);
        }
    }

//    private function afterMove(build:AreaObject, _x:Number, _y:Number):void {
//        var dbId:int = g.userInventory.removeFromDecorInventory(_data.id);
//        g.townArea.pasteBuild(build, _x, _y);
//        var p:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
//        g.directServer.removeFromInventory(dbId, p.x, p.y, null);
//        _count--;
//        g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
//    }
}
}
