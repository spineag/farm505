/**
 * Created by user on 1/27/16.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class MarketHint {
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _txtText:CTextField;
    private var _txtCount:CTextField;
    private var _txtSklad:CTextField;
    private var _imageItem:Image;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
//    private var objRecipes:Object;
    private var objAnimals:Object;
    public var isShowed:Boolean;
    private var g:Vars = Vars.getInstance();

    public function MarketHint() {
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

//        objRecipes = {};
//        obj = g.dataRecipe.objectRecipe;
//        for (id in obj) {
//            objRecipes[obj[id].idResource] = obj[id];
//        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite,noResource:Boolean = false): void {
        var wText:int = 0;
        var wName:int = 0;
        if (!g.allData.resource[_dataId]) {
            Cc.error('MarketHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'MarketHint');
            return;
        }
//        isShowed = true;
        var start:Point;
        if (!noResource) {
            start = new Point(int(sX - 5), int(sY - 23));
            start = source.parent.localToGlobal(start);
        } else {
            start = new Point(int(sX-8), int(sY-5));
            start = source.parent.localToGlobal(start);
        }
        _source.x = int(start.x + source.width/2);
        _source.y = int(start.y + source.height);
        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.2);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _txtName = new CTextField(200,30,'');
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtText = new CTextField(200,100,'');
        _txtText.setFormat(CTextField.BOLD18, 12, ManagerFilters.BLUE_COLOR);
        _txtText.leading = -5;
        _txtCount = new CTextField(30,30,'');
        _txtCount.setFormat(CTextField.BOLD18, 14, ManagerFilters.LIGHT_BLUE_COLOR);
        _txtSklad = new CTextField(70,20,'');
        _txtSklad.setFormat(CTextField.BOLD18, 12, ManagerFilters.LIGHT_BLUE_COLOR);
        
        if (g.allData.resource[_dataId].buildType == BuildType.PLANT) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_dataId].imageShop + '_icon'));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 10;
            _txtName.text = g.allData.resource[_dataId].name;
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText.text = 'Растет на грядке';
            _txtText.x = -100;
            _txtText.y = 5;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 30;
            _txtCount.y = 70;
            _txtSklad.text = 'На складе:';
            _txtSklad.x = -55;
            _txtSklad.y = 75;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.allData.resource[_dataId].buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(g.allData.resource[_dataId].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.resource[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 80;
            _imageItem.x = 10;
            _txtText.text = String(g.allData.resource[_dataId].opys);
            _txtText.x = -100;
            _txtText.y = 15;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 30;
            _txtCount.y = 80;
            _txtSklad.text = 'На складе:';
            _txtSklad.x = -60;
            _txtSklad.y = 85;
            wText = int(_txtText.textBounds.width + 20);
            wName = int(_txtName.textBounds.width + 80);
            if (wText > wName) bg = new HintBackground(wText, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_dataId == objTrees[i].craftIdResource) {
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_dataId].imageShop));
                MCScaler.scale(_imageItem,30,30);
                _imageItem.y = 70;
                _imageItem.x = 10;
                _txtName.text = g.allData.resource[_dataId].name;
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText.text = "Растет на: " + objTrees[i].name;
                _txtText.x = -100;
                _txtText.y = 5;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.x = 30;
                _txtCount.y = 70;
                _txtSklad.text = 'На складе:';
                _txtSklad.x = -55;
                _txtSklad.y = 75;
                wText = int(_txtText.textBounds.width + 40);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_imageItem);
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        for (i=0; i<objCave.length; i++) {
            if (_dataId == int(objCave[i])) {
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_dataId].imageShop));
                MCScaler.scale(_imageItem,30,30);
                _imageItem.y = 70;
                _imageItem.x = 15;
                _txtName.text = String(g.allData.resource[_dataId].name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText.text = "Место производства: Пещера";
                _txtText.x = -100;
                _txtText.y = 5;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.x = 35;
                _txtCount.y = 70;
                _txtSklad.text = 'На складе:';
                _txtSklad.x = -50;
                _txtSklad.y = 75;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_imageItem);
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (g.allData.recipe[_dataId]) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 15;
            _txtName.text = String(g.allData.resource[_dataId].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[g.allData.recipe[_dataId].buildingId].name;
            _txtText.x = -100;
            _txtText.y = 5;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 35;
            _txtCount.y = 70;
            _txtSklad.text = 'На складе:';
            _txtSklad.x = -50;
            _txtSklad.y = 75;
            wText = int(_txtText.textBounds.width + 20);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (objAnimals[_dataId]) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 15;
            _txtName.text = String(g.allData.resource[_dataId].name);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[objAnimals[_dataId].buildId].name;
            _txtText.x = -100;
            _txtText.y = 5;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 35;
            _txtCount.y = 70;
            _txtSklad.text = 'На складе:';
            _txtSklad.x = -50;
            _txtSklad.y = 75;
            wText = int(_txtText.textBounds.width + 20);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 96, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            g.cont.hintCont.addChild(_source);
            return;
        }

        Cc.error('Market Hint:: can"t find for resourceId= ' + _dataId);
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
