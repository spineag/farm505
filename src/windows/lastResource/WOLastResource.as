/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {
import starling.display.Image;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOLastResource extends Window{
    private var _contBtnYes:CSprite;
    private var _contBtnNo:CSprite;
    private var _imageItem:Image;
    private var _txtHeader:TextField;
    private var _txtText:TextField;
    public function WOLastResource() {
        super();
        createTempBG(300, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x = 150;
        _btnExit.y -= 150;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _txtHeader = new TextField(100,50,"Будьте Внимательны","Arial",14,Color.BLACK);
        _txtHeader.x = -50;
        _txtHeader.y = -100;
        _txtText = new TextField(150,50,"После использования у вас не останется семян для посадки","Arial",12,Color.BLACK);
        _txtText.x = -75;
        _source.addChild(_txtHeader);
        _source.addChild(_txtText);
    }

    private function onClickExit():void {
        hideIt();
    }

    public function showItMenu(ob:int):void {
            _imageItem = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
            _imageItem.x = -25;
            _imageItem.y = -50;
            MCScaler.scale(_imageItem,70,70);
            _source.addChild(_imageItem);
            showIt();
            fillBtn();
            trace("ok");

    }

    private function fillBtn():void {
        var im:Image;
        var txt:TextField;
        _contBtnYes = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('btn4'));
        txt = new TextField(50,50,"ДА","Arial",12,Color.BLACK);
        _contBtnYes.addChild(im);
        _contBtnYes.addChild(txt);
        _contBtnYes.x = -140;
        _contBtnYes.y = 70;
        _source.addChild(_contBtnYes);
        _contBtnYes.hoverCallback = function():void { _contBtnYes.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contBtnYes.outCallback = function():void { _contBtnYes.filter = null };
        _contBtnYes.endClickCallback = function():void {onClick('yes')};

        _contBtnNo = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('btn4'));
        txt = new TextField(50,50,"НЕТ","Arial",12,Color.BLACK);
        _contBtnNo.addChild(im);
        _contBtnNo.addChild(txt);
        _contBtnNo.x = 50;
        _contBtnNo.y = 70;
        _source.addChild(_contBtnNo);
        _contBtnNo.hoverCallback = function():void { _contBtnNo.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contBtnNo.outCallback = function():void { _contBtnNo.filter = null };
        _contBtnNo.endClickCallback = function():void {onClick('no')};
    }


    private function onClick(reason:String):void {
        switch (reason) {
            case 'yes':
                break;
            case 'no':
                break;
        }
    }
}
}
