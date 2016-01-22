/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOWaitFreeCats extends Window{

    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _txtBtn:TextField;
    private var _woBG:WindowBackground;

    public function WOWaitFreeCats() {
        super();
        _woWidth = 320;
        _woHeight = 300;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtText = new TextField(300,200,"У вас нет незанятых работников, подождите пока не закончится другое производство!",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtText.x = -150;
        _txtText.y = -100;
        var bg:WOButtonTexture = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        _contBtn.addChild(bg);
        _contBtn.x =-_contBtn.width/2;
        _contBtn.y = 70;
        _source.addChild(_contBtn);
        _txtBtn = new TextField(_contBtn.width,_contBtn.height,"ОК",g.allData.fonts['BloggerMedium'],20,Color.WHITE);
        _txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
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
