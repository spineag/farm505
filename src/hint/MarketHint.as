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

import utils.MCScaler;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class MarketHint {
    private var _source:Sprite;
    private var _txtName:TextField;
    private var _txtText:TextField;
    private var _txtCount:TextField;
    private var _txtSklad:TextField;
    private var _imageItem:Image;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
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

        objRecipes = {};
        obj = g.dataRecipe.objectRecipe;
        for (id in obj) {
            objRecipes[obj[id].idResource] = obj[id];
        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite): void {
        var wText:int = 0;
        var wName:int = 0;
        if (!g.dataResource.objectResources[_dataId]) {
            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'MarketHint');
            return;
        }
        isShowed = true;
        var start:Point = new Point(int(sX), int(sY - 15));
        start = source.parent.localToGlobal(start);
        _source.x = start.x + source.width/2;
        _source.y = start.y + source.height;
        if (g.dataResource.objectResources[_dataId].buildType == BuildType.PLANT) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop + '_icon'));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 10;
            _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200,100,'',g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;
            _txtText.text = "Растет на грядке";
            _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
            _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 30;
            _txtCount.y = 70;
            _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
            _txtSklad.x = -55;
            _txtSklad.y = 75;
            _source.x = start.x + source.width/2;
            _source.y = start.y + source.height + 5;
            wText = _txtText.textBounds.width + 40;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.dataResource.objectResources[_dataId].buildType == BuildType.INSTRUMENT) {
            _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 80;
            _imageItem.x = 10;
            _txtText = new TextField(200,100,String(g.dataResource.objectResources[_dataId].opys),g.allData.fonts['BloggerBold'],12,Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 15;
            _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
            _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 30;
            _txtCount.y = 80;
            _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
            _txtSklad.x = -60;
            _txtSklad.y = 85;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 80;
//            if (bol) {
//                if (wText > wName) bg = new HintBackground(wText, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
//                else bg = new HintBackground(wName, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
//                _source.x = start.x + source.width/2;
//                _source.y = start.y - 5;
//                _txtName.x = -75;
//                _txtName.y = -110;
//                _txtText.x = -76;
//                _txtText.y = -105;
//            } else {
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
//            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_dataId == objTrees[i].craftIdResource) {
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
                MCScaler.scale(_imageItem,30,30);
                _imageItem.y = 70;
                _imageItem.x = 10;
                _txtName = new TextField(150,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -75;
                _txtName.y = 20;
                _txtText = new TextField(200,100,"Растет на: " + objTrees[i].name,g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -100;
                _txtText.y = 5;
                _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
                _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.x = 30;
                _txtCount.y = 70;
                _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
                _txtSklad.x = -55;
                _txtSklad.y = 75;
                wText = _txtText.textBounds.width + 40;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_imageItem);
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
                _source.flatten();
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        for (i=0; i<objCave.length; i++) {
            if (_dataId == int(objCave[i])) {
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
                MCScaler.scale(_imageItem,30,30);
                _imageItem.y = 70;
                _imageItem.x = 15;
                _txtName = new TextField(200,30,String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BLUE);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText = new TextField(200,100,"Место производства: Пещера",g.allData.fonts['BloggerBold'],12,Color.WHITE);
                _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _txtText.x = -100;
                _txtText.y = 5;
                _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
                _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.x = 35;
                _txtCount.y = 70;
                _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
                _txtSklad.x = -50;
                _txtSklad.y = 75;
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 65, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                _source.addChild(_imageItem);
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
                _source.flatten();
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (objRecipes[_dataId]) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 15;
            _txtName = new TextField(200, 30, String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200, 100, "Место производства: " + g.dataBuilding.objectBuilding[objRecipes[_dataId].buildingId].name, g.allData.fonts['BloggerBold'], 12, Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;
            _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
            _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 35;
            _txtCount.y = 70;
            _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
            _txtSklad.x = -50;
            _txtSklad.y = 75;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (objAnimals[_dataId]) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_dataId].imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 70;
            _imageItem.x = 15;
            _txtName = new TextField(200, 30, String(g.dataResource.objectResources[_dataId].name), g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BLUE);
            _txtName.x = -100;
            _txtName.y = 20;
            _txtText = new TextField(200, 100, "Место производства: " + g.dataBuilding.objectBuilding[objAnimals[_dataId].buildId].name, g.allData.fonts['BloggerBold'], 12, Color.WHITE);
            _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtText.x = -100;
            _txtText.y = 5;
            _txtCount = new TextField(30,30,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
            _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
            _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
            _txtCount.x = 35;
            _txtCount.y = 70;
            _txtSklad = new TextField(70,20,'На складе:',g.allData.fonts['BloggerBold'],12,ManagerFilters.TEXT_LIGHT_BLUE);
            _txtSklad.x = -50;
            _txtSklad.y = 75;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            _source.flatten();
            g.cont.hintCont.addChild(_source);
            return;
        }

        Cc.error('Resource hint:: can"t find for resourceId= ' + _dataId);
    }
    public function hideIt():void {
        _source.unflatten();
        if (bg) bg.deleteIt();
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.cont.hintCont.removeChild(_source);
        isShowed = false;
    }
}
}
