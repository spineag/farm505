/**
 * Created by user on 8/19/15.
 */
package windows.ambarFilled {
import manager.ManagerFilters;

import starling.animation.Tween;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.ProgressBarComponent;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;
import windows.ambar.WOAmbars;

public class WOAmbarFilled extends Window{

    private var _contBtn:CSprite;
    private var _woBG:WindowBackground;
    private var _imageAmbar:Image;
    private var _txtBtn:TextField;
    private var _txtAmbarFilled:TextField;
    private var _txtCount:TextField;
    private var _bol:Boolean;
    private var _imAmbarSklad:Image;
    private var _bar:ProgressBarComponent;

    public function WOAmbarFilled() {
        super ();
        _woWidth = 400;
        _woHeight = 300;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;

        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        var bg:WOButtonTexture = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        bg.x = -10;
        _txtBtn = new TextField(150,50,"",g.allData.fonts['BloggerBold'],12,Color.WHITE);
        _txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtBtn.y = -5;
        _txtBtn.x = -20;
        _contBtn.addChild(bg);
        _contBtn.addChild(_txtBtn);
        _contBtn.x = -50;
        _contBtn.y = 75;
        _source.addChild(_contBtn);
        _imageAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture("storage_window_pr"));
        _imageAmbar.x = -160;
        _imageAmbar.y = -25;
        MCScaler.scale(_imageAmbar,49,320);
        _txtAmbarFilled = new TextField(200,50,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtAmbarFilled.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtAmbarFilled.x = -90;
        _txtAmbarFilled.y = -120;
        _txtCount = new TextField(200,50,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCount.x = -95;
        _txtCount.y = 20;
        _source.addChild(_txtAmbarFilled);
        _source.addChild(_txtCount);
        _source.addChild(_imageAmbar);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 308);
        _bar.x = _imageAmbar.x + 5;
        _bar.y = _imageAmbar.y + 5;
        _source.addChild(_bar);

    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        _source.removeChild(_imAmbarSklad);
    }

    private function onClick():void {
        hideIt();
        _source.removeChild(_imAmbarSklad);
        if (_bol == true) {
            g.woAmbars.showItWithParams(WOAmbars.AMBAR);
        } else {
            g.woAmbars.showItWithParams(WOAmbars.SKLAD);
        }
    }

    public function showAmbarFilled(isAmbar:Boolean):void {
        _bol = isAmbar;
        if (isAmbar == true){
            showIt();
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInAmbar) + "/" + String(g.user.ambarMaxCount);
            _txtAmbarFilled.text = "АМБАР ЗАПОЛНЕН";
            _txtBtn.text = "Увеличть Амбар";
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
            _imAmbarSklad.x = -5;
            _imAmbarSklad.y = _imageAmbar.y - 40;
            MCScaler.scale(_imAmbarSklad, 60, 60);
            _bar.progress = 1;
            _source.addChild(_imAmbarSklad);
        } else if(isAmbar == false) {
            showIt();
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInSklad) + "/" + String(g.user.skladMaxCount);
            _txtAmbarFilled.text = "СКЛАД ЗАПОЛНЕН";
            _txtBtn.text = "Увеличть Склад";
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
            _imAmbarSklad.x = -5;
            _imAmbarSklad.y = _imageAmbar.y - 40;
            MCScaler.scale(_imAmbarSklad, 60, 60);
            _bar.progress = 1;
            _source.addChild(_imAmbarSklad);
        }
    }
}
}