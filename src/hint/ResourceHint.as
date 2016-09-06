/**
 * Created by user on 7/23/15.
 */
package hint {
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import flash.utils.getTimer;
import manager.ManagerFilters;
import manager.Vars;

import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;
import utils.TimeUtils;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class ResourceHint {
    private var _source:Sprite;
    private var _imageClock:Image;
    private var _txtName:CTextField;
    private var _txtTime:CTextField;
    private var _txtText:CTextField;
    public var isShowed:Boolean;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
    private var objAnimals:Object;
    private var _timer:int;
    private var _callback:Function;
    private var _id:int;
    private var _newY:int;
    private var _newX:int;
    private var _newSource:Sprite;
    private var _fabrickBoo:Boolean;
    private var _bool:Boolean;

    private var g:Vars = Vars.getInstance();
    public function ResourceHint() {
        var obj:Object;
        _source = new Sprite();
        _source.touchable = false;
        isShowed = false;

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
    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite,bol:Boolean = false, fabr:Boolean = false):void {
        _id = _dataId;
        _newX = sX;
        _newY = sY;
        _newSource = source;
        _bool = bol;
        _fabrickBoo = fabr;
        _timer --;
        var wText:int = 0;
        var wName:int = 0;
        var hText:int = 0;
//        if (!g.dataResource.objectResources[_id]) {
//            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'resourceHint');
//            return;
//        }
        var start:Point = new Point(int(_newX-2), int(_newY - 20));
        start = _newSource.parent.localToGlobal(start);
        _source.x = start.x + _newSource.width/2;
        _source.y = start.y + _newSource.height;

        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.2);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _txtText = new CTextField(200,100,'');
        _txtText.setFormat(CTextField.MEDIUM14, 14, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtText.leading = -5;
        _txtName = new CTextField(200, 30, '');
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtTime = new CTextField(80, 50, '');
        _txtTime.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        
        if (_fabrickBoo) {
            _txtText.text = "Будет доступно на: " + g.dataRecipe.objectRecipe[_id].blockByLevel + ' уровне';
            _txtText.x = -100;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            _source.x = start.x;
            _source.y = start.y;
            return;
        }
        if (g.dataResource.objectResources[_id].blockByLevel > g.user.level) {
            _txtText.text = "Будет доступно на: " + g.dataResource.objectResources[_id].blockByLevel + ' уровне';
            _txtText.x = -100;
            _txtText.y = -5;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            _source.x = start.x;
            _source.y = start.y;
            return;
        }
        if (g.dataResource.objectResources[_id].buildType == BuildType.PLANT) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -40;
            _txtName.text = String(g.dataResource.objectResources[_id].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_id].buildTime);
//            _txtTime.x = 20;
            _txtTime.y = 60;
            _txtText.x = -100;
            _txtText.y = 5;
            if(_bool) {
                _source.x = start.x;
                _source.y = start.y;
                _txtText.text = 'Время роста:';
            } else {
                _txtText.text = "Растет на грядке";
                _source.x = start.x + _newSource.width/2;
                _source.y = start.y + _newSource.height + 5;
            }
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_txtTime);
            _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.dataResource.objectResources[_id].buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(g.dataResource.objectResources[_id].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtName.leading = -5;
            _txtText.text = String(g.dataResource.objectResources[_id].opys);
            _txtText.x = -100;
            _txtText.y = 18;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (_bool) {
                if (wText > wName) bg = new HintBackground(wText, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                else bg = new HintBackground(wName, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                _source.x = start.x + _newSource.width/2;
                _source.y = start.y + 30;
                _txtName.x = -100;
                _txtName.y = -90;
                _txtText.x = -100;
                _txtText.y = -90;
            } else {
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_id == objTrees[i].craftIdResource) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _txtName.text = String(g.dataResource.objectResources[_id].name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtTime.text = TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_id].buildTime);
//                _txtTime.x = -10;
                _txtTime.y = 60;
                _txtText.text = "Растет на: " + objTrees[i].name;
                _txtText.x = -100;
                _txtText.y = 5;
                if (_txtTime.textBounds.width >= 40) {
                    _imageClock.x = -35;
                }else {
                    _imageClock.x = -30;
                }
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_txtTime);
                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        for (i=0; i<objCave.length; i++) {
            if (_id == int(objCave[i])) {
                _txtName.text = String(g.dataResource.objectResources[_id].name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText.text = "Место производства: Пещера";
                _txtText.x = -100;
                _txtText.y = 8;
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (objRecipes[_id]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.x = -30;
            _txtName.text = String(g.dataResource.objectResources[_id].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_id].buildTime);
            _txtTime.x = 20;
            _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[objRecipes[_id].buildingId].name;
            _txtText.x = -100;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            hText = _txtText.textBounds.height;
            if ( hText >= 25) {
                if (wText > wName) bg = new HintBackground(wText, 110, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 110, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _imageClock.y = 85;
                _txtTime.y = 75;
                _txtText.y = 15;
                _txtTime.x = 0;
                _imageClock.x = -45;
            } else {
                if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _imageClock.y = 70;
                _txtTime.y = 60;
                _txtText.y = 5;
            }

            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_txtTime);
            _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (objAnimals[_id]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -30;
            _txtName.text = String(g.dataResource.objectResources[_id].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_id].buildTime);
//            _txtTime.x = -10;
            _txtTime.y = 60;
            _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[objAnimals[_id].buildId].name;
            _txtText.x = -100;
            _txtText.y = 5;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_txtTime);
            _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
            return;
        }
        Cc.error('Resource hint:: can"t find for resourceId= ' + _id);
    }


    public function hideIt():void {
        if (bg) bg.deleteIt();
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.cont.hintCont.removeChild(_source);
        isShowed = false;
    }
}
}
