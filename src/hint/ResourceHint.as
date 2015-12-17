/**
 * Created by user on 7/23/15.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

import windows.WOComponents.HintBackground;

public class ResourceHint {
    private var _source:Sprite;
    private var _image:Image;
    private var _imageClock:Image;
    private var _txtName:TextField;
    private var _txtTime:TextField;
    private var _txtText:TextField;

    private var g:Vars = Vars.getInstance();
    public function ResourceHint() {
        _source = new Sprite();
        _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
        _imageClock.y = 30;
        _txtName = new TextField(150,30,"", g.allData.fonts['BloggerSans'],18,ManagerFilters.TEXT_BLUE);
        _txtName.x = 10;
        _txtName.y = -5;
        _txtTime = new TextField(50,50,"",g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
        _txtTime.x = 30;
        _txtTime.y = 20;
        _txtText = new TextField(150,100,"",g.allData.fonts['BloggerBold'],12,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtText.y = -20;
        _source.touchable = false;

    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite):void {
        var obj:Object;
        var id:String;
        var h:int = 0;
        var w:int = 0;
        var bg:HintBackground;
        if (!g.dataResource.objectResources[_dataId]) {
            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.woGameError.showIt();
            return;
        }

        var start:Point = new Point(int(sX), int(sY));
        start = source.parent.localToGlobal(start);
        _source.x = start.x - 25;
        _source.y = start.y - 60;
        _imageClock.visible = true;
        _txtTime.visible = true;
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (_dataId == obj[id].craftIdResource) {
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Растет на: " + obj[id].name;
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
//                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(100, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.PLANT) {
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Растет на грядке";
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
//                w = _txtName.textBounds.width + 40;
//                var rectangle:Rectangle = _txtName.textBounds;
                bg = new HintBackground(40, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.INSTRUMENT) {
                _imageClock.visible = false;
                _txtTime.visible = false;
                _txtText.text = String(g.dataResource.objectResources[_dataId].opys);
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
//                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(100, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                    g.cont.hintCont.addChild(_source);
                    return;
            }
        }
        obj = g.dataRecipe.objectRecipe;
        for (id in obj) {
            if (_dataId == obj[id].idResource){
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[obj[id].buildingId].name;
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
//                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(100, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Место производства: Пещера";
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
//                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(100, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
        }
    }

    public function hideIt():void {
//        while (_source.numChildren) {
//            _source.removeChildAt(0);
//        }
        g.cont.hintCont.removeChild(_source);
    }
}
}
