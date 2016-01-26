/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOLastResource extends Window{
    private var _contBtnYes:CButton;
    private var _contBtnNo:CButton;
    private var _imageItem:Image;
    private var _txtHeader:TextField;
    private var _txtText:TextField;
    private var _data:Object;
    private var _woBG:WindowBackground;

    public function WOLastResource() {
        super();
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtHeader = new TextField(150,50,"ВНИМАНИЕ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        _txtHeader.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtHeader.x = -150;
        _txtHeader.y = -160;
        _txtText = new TextField(150,50,"Вы подтверждаете использование этого ресурса? После этого у вас не останется семян для посадки!",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtText.x = -120;
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
        if (_data.buildType == BuildType.PLANT)
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
        else
            _imageItem = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
        if (!_data) {
            Cc.error('WOLastResource showItMenu:: no such image: ' + _data.imageShop);
            g.woGameError.showIt();
            return;
        }
        var txt:TextField = new TextField(50,50,String(g.userInventory.getCountResourceById(_data.id)),g.allData.fonts['BloggerBold'],18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 20;
        txt.y = -70;
        _source.addChild(txt);
        _imageItem.x = -25;
        _imageItem.y = -50;
//        MCScaler.scale(_imageItem,70,70);
        _source.addChild(_imageItem);
        showIt();
        fillBtn();
    }

    private function fillBtn():void {
        var im:Image;
        var txt:TextField;
        _contBtnYes = new CButton();
        txt = new TextField(50,50,"ДА",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _contBtnYes.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contBtnYes.addChild(txt);
        _contBtnYes.x = -140;
        _contBtnYes.y = 70;
        _source.addChild(_contBtnYes);
        _contBtnYes.clickCallback = function():void {onClick('yes')};

        _contBtnNo = new CButton();
        txt = new TextField(50,50,"НЕТ",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _contBtnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contBtnNo.addChild(txt);
        _contBtnNo.x = 50;
        _contBtnNo.y = 70;
        _source.addChild(_contBtnNo);
        _contBtnNo.clickCallback = function():void {onClick('no')};
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
