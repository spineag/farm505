/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {

import com.junkbyte.console.Cc;

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
    private var _data:Object;

    public function WOLastResource() {
        super();
        _woWidth = 300;
        _woHeight = 300;
        createTempBG();
        createExitButton(onClickExit);
        _txtHeader = new TextField(100,50,"Будьте Внимательны","Arial",14,Color.BLACK);
        _txtHeader.x = -50;
        _txtHeader.y = -100;
        _txtText = new TextField(150,50,"После использования у вас не останется семян для посадки","Arial",12,Color.BLACK);
        _txtText.x = -75;
        _source.addChild(_txtHeader);
        _source.addChild(_txtText);
        callbackClickBG = onClickExit;
    }

    private function onClickExit():void {
        hideIt();
        _source.removeChild(_imageItem);
    }

    public function showItMenu(ob:Object):void {
        _data = ob;
        if (!_data) {
            Cc.error('WOLastResource showItMenu:: empty _data');
            g.woGameError.showIt();
            return;
        }
        _imageItem = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
        if (!_data) {
            Cc.error('WOLastResource showItMenu:: no such image: ' + _data.imageShop);
            g.woGameError.showIt();
            return;
        }
        _imageItem.x = -25;
        _imageItem.y = -50;
        MCScaler.scale(_imageItem,70,70);
        _source.addChild(_imageItem);
        showIt();
        fillBtn();
    }

    private function fillBtn():void {
        var im:Image;
        var txt:TextField;
        _contBtnYes = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('btn4'));
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
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('btn4'));
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
                    g.managerPlantRidge.addPlant(_data);
                    onClickExit();
                break;
            case 'no':
                onClickExit();
                break;
        }
    }
}
}
