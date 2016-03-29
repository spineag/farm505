/**
 * Created by user on 7/23/15.
 */
package windows.dailyBonusWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Quad;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.MCScaler;
import windows.WindowMain;
import windows.WindowsManager;

public class WODailyBonus extends WindowMain {
    private var _koleso:Sprite;
    private var _arrItems:Array;
    private var _btnFree:CButton;
    private var _btnBuy:CButton;
    private var _txtBtnBuy:TextField;
    private var _isAnimate:Boolean;
    private var _curActivePosition:int;

    public function WODailyBonus() {
        super();
        _windowType = WindowsManager.WO_DAILY_BONUS;
        _woWidth = 538;
        _woHeight = 500;
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        createKoleso();
    }

    private function onClickExit(e:Event=null):void {
        if (_isAnimate) return;
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _koleso.rotation = 0;
        _curActivePosition = 0;
        fillItems();
        checkBtns();
        super.showIt();
    }

    override protected function deleteIt():void {
        clearItems();
        _source.removeChild(_btnBuy);
        _btnBuy.deleteIt();
        _btnBuy = null;
        _source.removeChild(_btnFree);
        _btnFree.deleteIt();
        _btnFree = null;
        super.deleteIt();
    }

    private function createKoleso():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wheels_of_fortune_disk'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _koleso = new Sprite();
        _koleso.addChild(im);
        _koleso.x = 0;
        _koleso.y = 14;
        _source.addChild(_koleso);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wheels_of_fortune_text'));
        im.x = -186;
        im.y = -284;
        im.touchable = false;
        _source.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wheels_of_fortune _str'));
        im.x = -71;
        im.y = -238;
        im.touchable = false;
        _source.addChild(im);

        _btnFree = new CButton();
        _btnFree.addButtonTexture(146, 40, CButton.BLUE, true);
        var txt:TextField  = new TextField(146, 40, 'Вращать колесо', g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnFree.addChild(txt);
        _btnFree.y = 260;
        _source.addChild(_btnFree);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(200, 40, CButton.GREEN, true);
        _txtBtnBuy = new TextField(170, 40, 'Вращать колесо за 10', g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        _txtBtnBuy.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnBuy.addChild(_txtBtnBuy);
        _btnBuy.y = 260;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 30, 30);
        im.x = 163;
        im.y = 4;
        _btnBuy.addChild(im);
        _source.addChild(_btnBuy);
    }

    private function fillItems():void {
        var arr:Array = g.managerDailyBonus.dailyBonusItems;
        var item:WODailyBonusItem;
        _arrItems = [];
        for (var i:int=0; i<arr.length; i++) {
            item = new WODailyBonusItem(arr[i], i, _koleso);
            _arrItems.push(item);
        }
        _koleso.flatten();
    }

    private function clearItems():void {
        _koleso.unflatten();
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems = [];
    }

    private function checkBtns():void {
        _isAnimate = false;
        grayExitButton(false);
        if (g.managerDailyBonus.count <= 0) {
            _btnBuy.visible = false;
            _btnFree.visible = true;
            _btnFree.clickCallback = rotateKoleso;
        } else {
            _btnBuy.visible = true;
            _btnFree.visible = false;
            _btnBuy.clickCallback = rotateKoleso;
            _txtBtnBuy.text = 'Вращать колесо за ' + String(g.managerDailyBonus.count);
        }
    }

    private function rotateKoleso():void {
        if (g.managerDailyBonus.count > 0) {
            if (g.user.hardCurrency >= g.managerDailyBonus.count) {
                g.userInventory.addMoney(1, -g.managerDailyBonus.count);
            } else {
                onClickExit();
                g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                return;
            }
        }
        g.managerDailyBonus.updateCount();
        g.directServer.useDailyBonus(g.managerDailyBonus.count);

        _curActivePosition = int(Math.random()*12); // choose random item position as prise
        var angle:Number = -(Math.PI/6)*_curActivePosition - (3 + int(Math.random()*3))*Math.PI*2;
        var delta:Number = -Math.PI/9 + Math.random()*Math.PI/6;
        TweenMax.to(_koleso, 5, {rotation: angle - delta, ease: Quad.easeInOut, onComplete:completeRotateKoleso, onCompleteParams:[delta]});
        _btnBuy.visible = false;
        _btnFree.visible = false;
        _btnBuy.clickCallback = null;
        _btnFree.clickCallback = null;
        _isAnimate = true;
        grayExitButton(true);
    }

    private function completeRotateKoleso(delta:Number):void {
        TweenMax.to(_koleso, 1, {rotation: _koleso.rotation + delta, ease: Quad.easeInOut, onComplete:showGiftAnimation, delay:.2});
        _isAnimate = false;
        grayExitButton(false);
    }

    private function showGiftAnimation():void {
        new WODailyBonusCraftItem(g.managerDailyBonus.dailyBonusItems[_curActivePosition], _source, checkBtns);
    }

}
}
