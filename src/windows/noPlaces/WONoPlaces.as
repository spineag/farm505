/**
 * Created by user on 10/6/15.
 */
package windows.noPlaces {
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WONoPlaces extends Window{

    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _imageBtn:Image;
    private var _imageHard:Image;
    private var _imageBg:Image;
    private var _txtCost:TextField;

    public function WONoPlaces() {
        super();
        createTempBG(500, 500, Color.GRAY);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 250;
        _btnExit.y -= 250;
        _contBtn = new CSprite();
        _contBtn.x =-100;
        _contBtn.y = 150;
        _source.addChild(_contBtn);
        _contBtn.endClickCallback = onClick;
        _txtText = new TextField(100,100,"Недостаточна места","Arial",14,Color.BLACK);
        _txtText.x = -50;
        _txtText.y = - 200;
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn3"));
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("diamont"));
        MCScaler.scale(_imageHard,35,35);
        _imageHard.x = 10;
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("tempItemBG"));
        _imageBg.x = -50;
        _imageBg.y = -100;
        _txtCost = new TextField(50,50,"6","Arial",14,Color.BLACK);
        _txtCost.x = 50;
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_txtCost);
        _contBtn.addChild(_imageHard);
        _source.addChild(_imageBg);
        _source.addChild(_txtText);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    public function showItMenu():void {
        showIt();
    }

    private function onClick():void {
        g.userInventory.addMoney(1,int(_txtCost.text));
        hideIt();
    }
}
}
