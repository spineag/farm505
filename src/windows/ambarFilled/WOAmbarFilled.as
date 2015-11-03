/**
 * Created by user on 8/19/15.
 */
package windows.ambarFilled {
import starling.animation.Tween;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOAmbarFilled extends Window{

    private var _contBtn:CSprite;
    private var _imageAmbar:Image;
    private var _imageAmbarArrow:Image;
    private var _imageBtn:Image;
    private var _txtBtn:TextField;
    private var _txtAmbarFilled:TextField;
    private var _txtCount:TextField;
    private var _bol:Boolean;

    public function WOAmbarFilled() {
        super ();
        createTempBG(400, 300, Color.GRAY);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 200;
        _btnExit.y -= 150;
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn2"));
        _txtBtn = new TextField(150,50,"","Arial",12,Color.BLACK);
        _txtBtn.y = -10;
        _txtBtn.x = -10;
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_txtBtn);
        _contBtn.x = -50;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        _imageAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture("ambar_plawka"));
        _imageAmbar.x = -198;
        _imageAmbar.y = -100;
        _imageAmbarArrow = new Image(g.allData.atlas['interfaceAtlas'].getTexture("ambar_plawka_arrow"));
        _txtAmbarFilled = new TextField(100,50,"","Arial",14,Color.BLACK);
        _txtAmbarFilled.x = -50;
        _txtAmbarFilled.y = -150;
        _txtCount = new TextField(200,50,"","Arial",14,Color.BLACK);
        _txtCount.x = -80;
        _source.addChild(_txtAmbarFilled);
        _source.addChild(_txtCount);
        _source.addChild(_imageAmbar);
        _source.addChild(_imageAmbarArrow);
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    private function onClick():void {
        hideIt();
        if (_bol == true) {
            g.woAmbar.showUpdate();
        } else {
            g.woSklad.showUpdate();
        }

    }

    public function showAmbarFilled(isAmbar:Boolean):void {
        var tween:Tween;
        _bol = isAmbar;
        if (isAmbar == true){
            _imageAmbarArrow.x = _imageAmbar.x;
            _imageAmbarArrow.y = _imageAmbar.y;
            showIt();
            tween= new Tween(_imageAmbarArrow, 0.5);
            tween.moveTo(_imageAmbar.width - 200 - _imageAmbarArrow.width, _imageAmbar.y);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
            };
            g.starling.juggler.add(tween);
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInAmbar) + "/" + String(g.user.ambarMaxCount) + "КГ.";
            _txtAmbarFilled.text = "АМБАР ЗАПОЛНЕН";
            _txtBtn.text = "Увеличть Амбар";
        } else if(isAmbar == false) {
            _imageAmbarArrow.x = _imageAmbar.x;
            _imageAmbarArrow.y = _imageAmbar.y;
            showIt();
            tween = new Tween(_imageAmbarArrow, 0.5);
            tween.moveTo(_imageAmbar.width - 200 - _imageAmbarArrow.width, _imageAmbar.y);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
            };
            g.starling.juggler.add(tween);
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInSklad) + "/" + String(g.user.skladMaxCount) + "КГ.";
            _txtAmbarFilled.text = "СКЛАД ЗАПОЛНЕН";
            _txtBtn.text = "Увеличть Склад";
        }

    }
}
}
