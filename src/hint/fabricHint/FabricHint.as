/**
 * Created by user on 7/13/15.
 */
package hint.fabricHint {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class FabricHint {
    private var _imageItem:Image;
    private var _txtName:CTextField;
    private var _txtCreate:CTextField;
    private var _txtTimeCreate:CTextField;
    private var _txtOnSklad:CTextField;
    private var _txtItem:CTextField;
    private var _txtTime:CTextField;
    private var _source:Sprite;
    private var _arrCells:Array;
    private var _contImage:Sprite;
    private var _data:Object;
    private var _timer:int;
    private var _newX:int;
    private var _newY:int;

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

        _txtName = new CTextField(240,70,'');
        _txtName.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.LIGHT_BLUE_COLOR);
        _txtName.y = 5;
        _txtName.x = -20;
        _source.addChild(_txtName);

        _txtCreate = new CTextField(200, 30 ,'Для изготовления требуется:');
        _txtCreate.setFormat(CTextField.REGULAR18, 14, ManagerFilters.BLUE_COLOR);
        _txtCreate.y = 50;
        _source.addChild(_txtCreate);

        _txtTimeCreate = new CTextField(50, 30 ,'Время:');
        _txtTimeCreate.setFormat(CTextField.REGULAR18, 14, ManagerFilters.BLUE_COLOR);
        _txtTimeCreate.x = 20;
        _txtTimeCreate.y = 130;
        _txtOnSklad = new CTextField(100, 30 ,'На складе:');
        _txtOnSklad.setFormat(CTextField.REGULAR18, 14, ManagerFilters.BLUE_COLOR);
        _txtOnSklad.x = 100;
        _txtOnSklad.y = 130;
        _txtItem = new CTextField(50, 40 ,'');
        _txtItem.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.LIGHT_BLUE_COLOR);
        _txtItem.alignH = Align.LEFT;
        _txtItem.x = 163;
        _txtItem.y = 150;
        _txtTime = new CTextField(100, 40 ,'');
        _txtTime.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        _txtTime.x = 50;
        _txtTime.y = 150;
        _source.addChild(_txtTimeCreate);
        _source.addChild(_txtOnSklad);
        _source.addChild(_txtItem);
        _source.addChild(_txtTime);

        _contImage = new Sprite();
        _contImage.y = 50;
        _source.addChild(_contImage);
        _source.pivotX = bg.width/2;
        _source.touchable = false;
//        _source.pivotY = bg.height/2;
    }

    private function onTimer():void {
//        _timer--;
//        if (_timer <=0) {
//            g.gameDispatcher.removeFromTimer(onTimer);

//        }
    }

    public function showIt(da:Object, sX:int, sY:int):void {
        _data = da;
        _newX = sX;
        _newY = sY;
        if (_data && g.allData.resource[_data.idResource]) {
            _txtName.text = String(g.allData.resource[_data.idResource].name);
            _txtName.visible = false;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.resource[_data.idResource].buildTime);
            _txtItem.text = String(g.userInventory.getCountResourceById(_data.idResource));
            createList();
            _source.removeChild(_imageItem);
            if (g.allData.resource[_data.idResource].buildType == BuildType.PLANT)
                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_data.idResource].imageShop + '_icon'));
            else
                _imageItem = new Image(g.allData.atlas[g.allData.resource[_data.idResource].url].getTexture(g.allData.resource[_data.idResource].imageShop));
            if (!_imageItem) {
                Cc.error('FabricHint showIt:: no such image: ' + g.allData.resource[_data.idResource].imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHint');
                return;
            }
            _imageItem.x = 120;
            _imageItem.y = 150;
            MCScaler.scale(_imageItem, 40,40);
            _source.addChild(_imageItem);
            _source.x = _newX + 50;
            _source.y = _newY + 80;
            g.cont.hintCont.addChild(_source);

            _source.scaleX = _source.scaleY = 0;
            var tween:Tween = new Tween(_source, 0.15);
            tween.scaleTo(1);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _txtName.visible = true;
            };
            g.starling.juggler.add(tween);
        } else {
            Cc.error('FabricHint showIt with empty data or g.dataResource.objectResources[data.idResource] = null');
        }
    }
    
    public function updateItem():void {
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].updateCount();
        }
    }

    public function hideIt():void {
        _source.removeChild(_imageItem);
        g.cont.hintCont.removeChild(_source);

        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _arrCells.length = 0;
        g.gameDispatcher.removeFromTimer(onTimer);
        _txtName.text = '';
    }

    private function createList():void {
        if (!_data) {
            Cc.error('FabricHint createList:: empty data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHint');
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
