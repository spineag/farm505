/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import build.lockedLand.LockedLand;

import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;

import starling.display.Sprite;

import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.HintBackground;
import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOLockedLand extends Window{
    private var _dataLand:Object;
    private var _land:LockedLand;
    private var _arrItems:Array;
    private var _btnOpen:CSprite;
    private var _woBG:WindowBackground;

    public function WOLockedLand() {
        super();
        _arrItems = [];
        _woWidth = 550;
        _woHeight = 540;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;
        new Birka('Новая территория', _source, _woWidth, _woHeight);

        var c:CartonBackground = new CartonBackground(460, 320);
        c.x = -_woWidth/2 + 47;
        c.y = -_woHeight/2 + 180;
        _source.addChild(c);

        _btnOpen = new CSprite();
        var t:Sprite = new WOButtonTexture(158, 46, WOButtonTexture.BLUE);
        _btnOpen.addChild(t);
        var txt:TextField = new TextField(158,46,'Открыть участок',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnOpen.addChild(txt);
        _btnOpen.x = -_btnOpen.width/2;
        _btnOpen.y = -_woHeight/2 + 492;
        _source.addChild(_btnOpen);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.x = -_woWidth/2 + 61;
        im.y = -_woHeight/2 + 44;
        _source.addChild(im);
        var pl:HintBackground = new HintBackground(310, 97, HintBackground.LONG_TRIANGLE, HintBackground.LEFT_CENTER);
        pl.x = -_woWidth/2 + 159;
        pl.y = -_woHeight/2 + 109;
        pl.addShadow();
        _source.addChild(pl);
        txt = new TextField(310,97,'Выполните следующие задания, чтобы открыть этот участок',g.allData.fonts['BloggerMedium'], 18, ManagerFilters.TEXT_BLUE);
        pl.inSprite.addChild(txt);
    }

    public function onClickExit(e:Event=null):void {
        hideIt();
        clearIt();
        _btnOpen.endClickCallback = null;
    }

    public function showItWithParams(dataLand:Object, land:LockedLand):void {
        _dataLand = dataLand;
        _land = land;

        if (!_dataLand || !_land) {
            Cc.error('WOLockedLand showIt:: bad _dataLand or _land');
            g.woGameError.showIt();
            return;
        }

        var item:LockedLandItem;
        if (_dataLand.friendsCount > 0) {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -_woHeight/2 + 195;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = -_woHeight/2 + 300;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithFriends(_dataLand.friendsCount);
            item.source.y = -_woHeight/2 + 405;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);
        } else {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -_woHeight/2 + 245;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = -_woHeight/2 + 360;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
        checkBtn();
        super.showIt();
    }

    private function clearIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
            _source.removeChild(_arrItems[i].source);
        }
        _arrItems.length = 0;
    }

    private function checkBtn():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isGood) return;
        }
        _btnOpen.endClickCallback = onBtnOpen;
    }

    private function onBtnOpen():void {
        _land.openIt();
        onClickExit();
    }

}
}
