/**
 * Created by user on 1/27/16.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;

public class MarketHint {
    private var _source:Sprite;
    private var _txtName:TextField;
    private var _txtText:TextField;
    private var _txtCount:TextField;
    private var _imageItem:Image;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
    private var objAnimals:Object;
    private var g:Vars = Vars.getInstance();

    public function MarketHint() {
        var obj:Object;
        _source = new Sprite();
        _source.touchable = false;

        objTrees = [];
        objCave = [];
        obj = g.dataBuilding.objectBuilding;
        for (var id:String in obj) {
            if (obj[id].buildType == BuildType.TREE)
                objTrees.push(obj[id]);
            else if (obj[id].buildType == BuildType.CAVE)
                objCave = obj[id].idResource;
        }

        objAnimals = [];
        obj = g.dataAnimal.objectAnimal;
        for (id in obj) {
            objAnimals[obj[id].idResource] = obj[id];
        }

        objRecipes = {};
        obj = g.dataRecipe.objectRecipe;
        for (id in obj) {
            objRecipes[obj[id].idResource] = obj[id];
        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite,bol:Boolean = false): void {
        var wText:int = 0;
        var wName:int = 0;
        if (!g.dataResource.objectResources[_dataId]) {
            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.woGameError.showIt();
            return;
        }
        var start:Point = new Point(int(sX), int(sY));
        start = source.parent.localToGlobal(start);
        _source.x = start.x + source.width/2;
        _source.y = start.y + source.height + 5;
        if (g.dataResource.objectResources[_dataId].blockByLevel > g.user.level) {
            _txtText = new TextField(200,100,"Будет доступно на: " + g.dataResource.objectResources[_dataId].blockByLevel + ' уровне', g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = -5;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            _source.x = start.x;
            _source.y = start.y;
            return;
        }
        if (g.dataResource.objectResources[_dataId].buildType == BuildType.PLANT) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop + '_icon'));
            _imageItem.y = 70;
            _imageItem.x = -30;
            _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200,100,'',g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;

            if(bol) {
                _source.x = start.x;
                _source.y = start.y;
                _txtText.text = 'Время роста:';
            } else {
                _txtText.text = "Растет на грядке";
                _source.x = start.x + source.width/2;
                _source.y = start.y + source.height + 5;
            }
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.dataResource.objectResources[_dataId].buildType == BuildType.INSTRUMENT) {
            _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
            _imageItem.y = 70;
            _imageItem.x = -30;
            _txtText = new TextField(200,100,String(g.dataResource.objectResources[_dataId].opys),g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 15;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (bol) {
                if (wText > wName) bg = new HintBackground(wText, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                else bg = new HintBackground(wName, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                _source.x = start.x + source.width/2;
                _source.y = start.y - 5;
                _txtName.x = -75;
                _txtName.y = -110;
                _txtText.x = -76;
                _txtText.y = -105;
            } else {
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_dataId == objTrees[i].craftIdResource) {
                _imageItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageItem.y = 70;
                _imageItem.x = -30;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtText = new TextField(200,100,"Растет на: " + objTrees[i].name,g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -100;
                _txtText.y = 5;

                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_imageItem);
                _source.flatten();
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        for (i=0; i<objCave.length; i++) {
            if (_dataId == int(objCave[i])) {
//                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
//                _imageClock.y = 70;
//                _imageClock.x = -30;
                _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -100;
                _txtName.y = 20;
//                _txtTime = new TextField(50,50,TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_dataId].buildTime),g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
//                _txtTime.x = -10;
//                _txtTime.y = 60;
                _txtText = new TextField(200,100,"Место производства: Пещера",g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -100;
                _txtText.y = 5;

                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
//                _source.addChild(_txtTime);
//                _source.addChild(_imageClock);
                _source.flatten();
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (objRecipes[_dataId]) {
            _imageItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageItem.y = 70;
            _imageItem.x = -30;
            _txtName = new TextField(200, 30, String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200, 100, "Место производства: " + g.dataBuilding.objectBuilding[objRecipes[_dataId].buildingId].name, g.allData.fonts['BloggerBold'], 12, Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;

            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (objAnimals[_dataId]) {
            _imageItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageItem.y = 70;
            _imageItem.x = -30;
            _txtName = new TextField(200, 30, String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200, 100, "Место производства: " + g.dataBuilding.objectBuilding[objAnimals[_dataId].buildId].name, g.allData.fonts['BloggerBold'], 12, Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;

            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        Cc.error('Resource hint:: can"t find for resourceId= ' + _dataId);
    }
    public function hideIt():void {
        _source.unflatten();
        if (bg) bg.clearIt();
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.cont.hintCont.removeChild(_source);
    }
}
}
