/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOWaitFreeCats extends Window{

    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _txtBtn:TextField;
    private var _imageBtn:Image;

    public function WOWaitFreeCats() {
        super();
        createTempBG(300, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 150;
        _btnExit.y -= 150;
        _txtText = new TextField(300,200,"Свободных работников нет, подождите пока окончания другого производства","Arial",18,Color.BLACK);
        _txtText.x = -150;
        _txtText.y = -100;
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn3"));
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        _contBtn.addChild(_imageBtn);
        _contBtn.x =-_contBtn.width/2;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        _txtBtn = new TextField(_contBtn.width,_contBtn.height,"ОК","Arial",20,Color.BLACK);
        _contBtn.addChild(_txtBtn);
        _source.addChild(_txtText);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function onClick():void {
        hideIt();
    }
}
}
