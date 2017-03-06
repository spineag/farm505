/**
 * Created by user on 2/19/16.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.StructureDataBuilding;

import flash.geom.Point;

import manager.ManagerFabricaRecipe;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;

public class LevelUpHint {
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

    private var g:Vars = Vars.getInstance();

    public function LevelUpHint() {
        var obj:Object;
        _source = new Sprite();
        _source.touchable = false;
        isShowed = false;

        objTrees = [];
        objCave = [];
        var arR:Array = g.allData.building;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.TREE)
                objTrees.push(arR[i]);
            else if (arR[i].buildType == BuildType.CAVE)
                objCave = arR[i].idResource;
        }

        objAnimals = [];
        arR = g.allData.animal;
        for (i = 0; i < arR.length; i++) {
            objAnimals[arR[i].idResource] = arR[i];
        }

        objRecipes = {};
        arR = g.allData.recipe;
        for (i = 0; i < arR.length; i++) {
              objRecipes[arR[i].idResource] = arR[i];
        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite, house:Boolean,animal:Boolean):void {
        var wText:int = 0;
        var wName:int = 0;
//        if (_dataId == 0 ) {
//            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
//            g.woGameError.showIt();
//            return;
//        }
        isShowed = true;
        var start:Point = new Point(int(sX-13), int(sY - 5));
        start = source.parent.localToGlobal(start);
        _source.x = int(start.x + source.width/2);
        _source.y = int(start.y + source.height);

        _txtName = new CTextField(200, 30, '');
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtText = new CTextField(200, 100, '');
//        _txtText.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtText.setFormat(CTextField.MEDIUM18, 14, ManagerFilters.BLUE_COLOR);
        _txtText.leading = -5;
        _txtTime = new CTextField(200,100,'');
//        _txtTime.setFormat(CTextField.BOLD14, 12, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtTime.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);

        if (_dataId == -1) {
            _txtName.text = 'Помощник';
            _txtName.x = -100;
            _txtName.y = 25;
            _txtText.text = 'Работает на ферме';
            _txtText.x = -100;
            _txtText.y = 10;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (_dataId == -2) {
            _txtName.text = 'Грядка';
            _txtName.x = -100;
            _txtName.y = 25;
            _txtText.text = 'На ней растут растения';
            _txtText.x = -100;
            _txtText.y = 10;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (animal) {
            _txtName.text = String(g.allData.getAnimalById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 25;
            _txtText.text = 'Производит: ' + g.allData.getResourceById(g.allData.getAnimalById(_dataId).idResource).name;
            _txtText.x = -100;
            _txtText.y = 10;
            _txtTime.leading = -5;
            _txtTime.text = 'Место жительства: ' + String(g.allData.getBuildingById(g.allData.getAnimalById(_dataId).buildId).name);
            _txtTime.x = -100;
            _txtTime.y = 30;
            wName = _txtTime.textBounds.width + 40;
            bg = new HintBackground(wName, 90, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_txtTime);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (house) {
            var b:StructureDataBuilding = g.allData.getBuildingById(_dataId);
            if (b.buildType == BuildType.FARM || b.buildType == BuildType.RIDGE || b.buildType == BuildType.FABRICA
                    || b.buildType == BuildType.TREE || b.buildType == BuildType.DECOR_FULL_FENСE || b.buildType == BuildType.DECOR_POST_FENCE
                    || b.buildType == BuildType.DECOR_TAIL || b.buildType == BuildType.DECOR || b.buildType == BuildType.DECOR_ANIMATION || b.buildType == BuildType.MARKET
                    || b.buildType == BuildType.ORDER || b.buildType == BuildType.DAILY_BONUS
                    || b.buildType == BuildType.CAVE || b.buildType == BuildType.PAPER || b.buildType == BuildType.TRAIN) {
                _txtName.text = String(b.name);
                _txtName.x = -100;
                _txtName.y = 25;
                wName = _txtName.textBounds.width + 40;
                bg = new HintBackground(wName, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }
        if (g.allData.getResourceById(_dataId).blockByLevel > g.user.level) {
            _txtText.text = "Будет доступно на: " + g.allData.getResourceById(_dataId).blockByLevel + ' уровне';
            _txtText.x = -100;
            _txtText.y = -5;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            _source.x = int(start.x);
            _source.y = int(start.y);
            return;
        }
        if (g.allData.getResourceById(_dataId).buildType == BuildType.PLANT) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -40;
            _txtName.text = String(g.allData.getResourceById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_dataId).buildTime);
            if (_txtTime.textBounds.width >= 50) {
                _txtTime.x = -80;
            } else {
                _txtTime.x = -90;
            }
            _txtTime.y = 33;
            _txtText.text = 'Растет на грядке';
            _txtText.x = -100;
            _txtText.y = 5;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
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
        if (g.allData.getResourceById(_dataId).buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(g.allData.getResourceById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText.text = String(g.allData.getResourceById(_dataId).opys);
            _txtText.x = -100;
            _txtText.y = 15;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_dataId == objTrees[i].craftIdResource) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
                _imageClock.y = 70;
                _txtName.text = String(g.allData.getResourceById(_dataId).name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_dataId).buildTime);
                _txtTime.x = -90;
                _txtTime.y = 33;
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
            if (_dataId == int(objCave[i])) {
                _txtName.text = String(g.allData.getResourceById(_dataId).name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText.text = "Место производства: Пещера";
                _txtText.x = -100;
                _txtText.y = 5;
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

        if (objRecipes[_dataId]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -30;
            _txtName.text = String(g.allData.getResourceById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_dataId).buildTime);
            if (_txtTime.textBounds.width >= 50) {
                _txtTime.x = -70;
            } else {
                _txtTime.x = -80;
            }
            _txtTime.y = 33;
            _txtText.text = "Место производства: " + g.allData.getBuildingById(objRecipes[_dataId].buildingId).name;
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

        if (objAnimals[_dataId]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
            _imageClock.y = 70;
            _imageClock.x = -30;
            _txtName.text = String(g.allData.getResourceById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_dataId).buildTime);
            _txtTime.x = -80;
            _txtTime.y = 33;
            _txtText.text = "Место производства: " + g.allData.getBuildingById(objAnimals[_dataId].buildId).name;
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

        Cc.error('Resource hint:: can"t find for resourceId= ' + _dataId);
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
