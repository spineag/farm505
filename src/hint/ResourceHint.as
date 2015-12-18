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
import utils.TimeUtils;

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
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite,ridge:Boolean = false):void {
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
        _source.x = start.x + source.width/2;
        _source.y = start.y + source.height + 5;
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (g.dataResource.objectResources[_dataId].blockByLevel > g.user.level) {
                _txtText = new TextField(150,100,"Будет доступно на: " + g.dataResource.objectResources[_dataId].blockByLevel + ' уровне', g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -76;
                _txtText.y = -5;
                w = _txtText.textBounds.width + 40;
                bg = new HintBackground(w, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtText);
                g.cont.hintCont.addChild(_source);
                _source.x = start.x;
                _source.y = start.y;
                return;
            }
            if (_dataId == obj[id].craftIdResource) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _imageClock.x = -30;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtTime.x = -10;
                _txtTime.y = 60;
                _txtText = new TextField(150,100,"Растет на: " + obj[id].name,g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -76;
                _txtText.y = 5;

                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(w, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.PLANT) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _imageClock.x = -30;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtTime.x = -10;
                _txtTime.y = 60;
                _txtText = new TextField(150,100,'',g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -76;
                _txtText.y = 5;

                if(ridge) {
                    _source.x = start.x;
                    _source.y = start.y;
                     _txtText.text = 'Время роста:';
                } else {
                    _txtText.text = "Растет на грядке";
                    _source.x = start.x + source.width/2;
                    _source.y = start.y + source.height + 5;
                }
                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(w, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);

                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.INSTRUMENT) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _imageClock.x = -30;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtTime.x = -10;
                _txtTime.y = 60;
                _txtText = new TextField(150,100,String(g.dataResource.objectResources[_dataId].opys),g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -76;
                _txtText.y = 5;

                _imageClock.visible = false;
                _txtTime.visible = false;
                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(w, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
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
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _imageClock.x = -30;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtTime.x = -10;
                _txtTime.y = 60;
                _txtText = new TextField(150,100,"Место производства: " + g.dataBuilding.objectBuilding[obj[id].buildingId].name,g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -76;
                _txtText.y = 5;

                w = _txtName.textBounds.width + 40;
                bg = new HintBackground(w, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -30;
            _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtName.x = -75;
            _txtName.y = 20;
            _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtTime.x = -10;
            _txtTime.y = 60;
            _txtText = new TextField(150,100,"Место производства: Пещера",g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -76;
            _txtText.y = 5;

            w = _txtName.textBounds.width + 40;
            bg = new HintBackground(w, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_txtTime);
            _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
        }
    }

    public function hideIt():void {
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.cont.hintCont.removeChild(_source);
    }
}
}
