/**
 * Created by user on 7/13/15.
 */
package hint.fabricHint {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.HintBackground;

public class FabricHint {
    private var _imageItem:Image;
    private var _txtName:TextField;
    private var _txtCreate:TextField;
    private var _txtTimeCreate:TextField;
    private var _txtOnSklad:TextField;
    private var _txtItem:TextField;
    private var _txtTime:TextField;
    private var _source:Sprite;
    private var _arrCells:Array;
    private var _contImage:Sprite;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function FabricHint() {
        _source = new Sprite();
        _arrCells = [];
        var bg:HintBackground = new HintBackground(200, 180, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
        bg.x = 100;
        _source.addChild(bg);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hint_clock"));
        im.x = 15;
        im.y = 155;
        _source.addChild(im);

        _txtName = new TextField(240,70,'',g.allData.fonts['BloggerBold'],22,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        _txtName.y = 5;
        _txtName.x = -20;
        _source.addChild(_txtName);

        _txtCreate = new TextField(200, 30 ,'Для изготовления требуется:', g.allData.fonts['BloggerRegular'], 14, ManagerFilters.TEXT_LIGHT_BLUE);
        _txtCreate.y = 50;
        _source.addChild(_txtCreate);

        _txtTimeCreate = new TextField(50, 30 ,'Время:', g.allData.fonts['BloggerRegular'], 14, ManagerFilters.TEXT_LIGHT_BLUE);
        _txtTimeCreate.x = 20;
        _txtTimeCreate.y = 130;
        _txtOnSklad = new TextField(100, 30 ,'На складе:', g.allData.fonts['BloggerRegular'], 14, ManagerFilters.TEXT_LIGHT_BLUE);
        _txtOnSklad.x = 100;
        _txtOnSklad.y = 130;
        _txtItem = new TextField(50, 40 ,'', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtItem.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        _txtItem.hAlign = HAlign.LEFT;
        _txtItem.x = 160;
        _txtItem.y = 150;
        _txtTime = new TextField(100, 40 ,'', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtTime.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        _txtItem.hAlign = HAlign.LEFT;
        _txtTime.x = 20;
        _txtTime.y = 150;
        _source.addChild(_txtTimeCreate);
        _source.addChild(_txtOnSklad);
        _source.addChild(_txtItem);
        _source.addChild(_txtTime);

        _contImage = new Sprite();
        _contImage.y = 50;
        _source.addChild(_contImage);
    }

    public function showIt(da:Object, sX:int, sY:int):void {
        _data = da;
        if (_data && g.dataResource.objectResources[_data.idResource]) {
            _txtName.text = String(g.dataResource.objectResources[_data.idResource].name);
            _txtTime.text = TimeUtils.convertSecondsForHint(g.dataResource.objectResources[_data.idResource].buildTime);
            _txtItem.text = String(g.userInventory.getCountResourceById(_data.idResource));
            createList();
            _source.removeChild(_imageItem);
            if (g.dataResource.objectResources[_data.idResource].buildType == BuildType.PLANT)
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_data.idResource].imageShop + '_icon'));
            else
                _imageItem = new Image(g.allData.atlas[g.dataResource.objectResources[_data.idResource].url].getTexture(g.dataResource.objectResources[_data.idResource].imageShop));
            if (!_imageItem) {
                Cc.error('FabricHint showIt:: no such image: ' + g.dataResource.objectResources[_data.idResource].imageShop);
                g.woGameError.showIt();
                return;
            }
            _imageItem.x = 120;
            _imageItem.y = 150;
            MCScaler.scale(_imageItem, 40,40);
            _source.addChild(_imageItem);
            _source.x = sX - 50;
            _source.y = sY + 80;
            g.cont.hintCont.addChild(_source);
        } else {
            Cc.error('FabricHint showIt with empty data or g.dataResource.objectResources[data.idResource] = null');
        }
    }

    public function hideIt():void {
        _source.removeChild(_imageItem);
        g.cont.hintCont.removeChild(_source);

        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _arrCells.length = 0;
    }

    private function createList():void {
        if (!_data) {
            Cc.error('FabricHint createList:: empty data');
            g.woGameError.showIt();
            return;
        }
        var im:FabricHintItem;
        for (var i:int = 0; i < _data.ingridientsId.length; i++) {
            im = new FabricHintItem(int(_data.ingridientsId[i]), int(_data.ingridientsCount[i]));
            im.source.x = int (i * 45);
            _arrCells.push(im);
            _contImage.addChild(im.source);
            switch (_data.ingridientsId.length) {
                case 1:
                    _contImage.x = 50;
                    break;
                case 2:
                    _contImage.x = 30;
                    break;
                case 3:
                    _contImage.x = 10;
                    break;
                case 4:
                    _contImage.x = -20;
                    break;
            }
        }
    }
}
}
