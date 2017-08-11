/**
 * Created by andy on 8/3/17.
 */
package windows.askGift {
import com.greensock.TweenMax;
import data.StructureDataResource;
import flash.events.Event;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOAskGift extends WindowMain {
    private var _woBG:WindowBackground;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _contMask:Sprite;
    private var _container:Sprite;
    private var _txtDescription:CTextField;
    private var _txtGift:CTextField;
    private var _blockChooseGift:Sprite;
    private var _arrItems:Array;
    private var _chooseForUser:Boolean;
    private var _userSprite:CSprite;
    private var _friendSprite:CSprite;

    public function WOAskGift() {
        _chooseForUser = true;
        _windowType = WindowsManager.WO_ASK_GIFT;
        _woWidth = 622;
        _woHeight = 562;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _blockChooseGift = new Sprite();
        _blockChooseGift.x = -_woWidth/2;
        _blockChooseGift.y = -_woHeight/2;
        _source.addChild(_blockChooseGift);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_2'));
        im.x = 24;
        im.y = 50;
        im.touchable = false;
        _blockChooseGift.addChild(im);
        _contMask = new Sprite();
        _contMask.x = _woWidth/2 - 180;
        _contMask.y = 147;
        _blockChooseGift.addChild(_contMask);
        _contMask.mask = new Quad(360, 360);
        _container = new Sprite();
        _contMask.addChild(_container);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_3'));
        im.scaleX = -1;
        im.x = 153;
        im.y = 100;
        im.touchable = false;
        _blockChooseGift.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_3'));
        im.x = 460;
        im.y = 100;
        im.touchable = false;
        _blockChooseGift.addChild(im);

        _txtGift = new CTextField(200, 60, "Подарки");
        _txtGift.setFormat(CTextField.BOLD30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _txtGift.x = 211;
        _txtGift.y = 18;
        _blockChooseGift.addChild(_txtGift);
        _txtDescription =  new CTextField(600, 40, "Выберите подарок, который хочете получить");
        _txtDescription.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = 11;
        _txtDescription.y = 75;
        _blockChooseGift.addChild(_txtDescription);

        _userSprite = new CSprite();
        _userSprite.x = 276;
        _userSprite.y = -170;
        _source.addChild(_userSprite);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_1'));
        im.touchable = false;
        _userSprite.addChild(im);
        var t:CTextField = new CTextField(90, 46, "Хочу подарок");
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        t.x = 11;
        t.y = 20;
        _userSprite.addChild(t);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_1'));
        im.y = 90;
        _userSprite.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_2'));
        im.y = 90;
        _userSprite.addChild(im);
        t = new CTextField(90, 46, "Подарок другу");
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        t.x = 13;
        t.y = 112;
        _userSprite.addChild(t);

        _friendSprite = new CSprite();
        _friendSprite.visible = false;
        _friendSprite.x = 276;
        _friendSprite.y = -170;
        _source.addChild(_friendSprite);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_1'));
        _friendSprite.addChild(im);
        t = new CTextField(90, 46, "Хочу подарок");
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        t.x = 11;
        t.y = 20;
        _friendSprite.addChild(t);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_1'));
        im.y = 90;
        im.touchable = false;
        _friendSprite.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tabs_bt_2'));
        _friendSprite.addChild(im);
        t = new CTextField(90, 46, "Подарок другу");
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        t.x = 13;
        t.y = 112;
        _friendSprite.addChild(t);

        _friendSprite.endClickCallback = function():void {
            _userSprite.visible = true;
            _friendSprite.visible = false;
            _chooseForUser = true;
            _txtDescription.text = "Выберите подарок, который хочете получить";
        };
        _userSprite.endClickCallback = function():void {
            _userSprite.visible = false;
            _friendSprite.visible = true;
            _chooseForUser = false;
            _txtDescription.text = "Выберите подарок, который хочете подарить";
        };
    }

    private function onClickExit(e:Event=null):void {
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        var arr:Array = g.managerAskGift.availableForGifts;
        var item:WOAskGiftItem;
        _arrItems = [];
        for (var i:int=0; i<arr.length; i++) {
            item = new WOAskGiftItem(arr[i], onChooseItem);
            item.source.x = int((i/2))*120;
            item.source.y = i%2 * 180;
            _container.addChild(item.source);
            _arrItems.push(item);
        }
        if (arr.length > 6) createArrows();
        super.showIt();
    }

    private function onChooseItem(d:StructureDataResource):void {
        onClickExit();
        g.windowsManager.openWindow(WindowsManager.WO_CHOOSE_GIFT_FRIEND, null, d, _chooseForUser);
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = 58;
        _leftArrow.y = 308;
        _blockChooseGift.addChild(_leftArrow);
        _leftArrow.clickCallback = onLeftClick;
        _leftArrow.isTouchable = false;
        _leftArrow.filter = ManagerFilters.BUTTON_DISABLE_FILTER;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 602;
        _rightArrow.y = 308;
        _blockChooseGift.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;
    }

    private function onRightClick():void {
        _leftArrow.isTouchable = true;
        _leftArrow.filter = null;
        _rightArrow.isTouchable = false;
        _rightArrow.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        TweenMax.to(_container, .2, {x:-240});
    }

    private function onLeftClick():void {
        _rightArrow.isTouchable = true;
        _rightArrow.filter = null;
        _leftArrow.isTouchable = false;
        _leftArrow.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        TweenMax.to(_container, .2, {x:0});
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_leftArrow);
        _leftArrow.deleteIt();
        _leftArrow = null;
        _source.removeChild(_rightArrow);
        _rightArrow.deleteIt();
        _rightArrow = null;
        _source.removeChild(_friendSprite);
        _friendSprite.deleteIt();
        _friendSprite = null;
        _source.removeChild(_userSprite);
        _userSprite.deleteIt();
        _userSprite = null;
        _source.removeChild(_txtDescription);
        _txtDescription.deleteIt();
        _txtDescription = null;
        _source.removeChild(_txtGift);
        _txtGift.deleteIt();
        _txtGift = null;
        for (var i:int=0; i<_arrItems.length; i++) {
            _container.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        super.deleteIt();
    }
}
}
