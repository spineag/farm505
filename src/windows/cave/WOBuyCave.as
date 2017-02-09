/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WindowMine;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCave extends WindowMain {
    private var _btn:CButton;
    private var _txt:CTextField;
    private var _priceTxt:CTextField;
    private var _callback:Function;
    private var _dataObject:Object;
    private var _nameImage:String;

    public function WOBuyCave() {
        super();
        _windowType = WindowsManager.WO_BUY_CAVE;
        _callbackClickBG = hideIt;
        _btn = new CButton();
        _btn.addButtonTexture(250, 35, CButton.BLUE, true);
        _btn.y = 165;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im,25,25);
        im.x = 215;
        im.y = 7;
        _btn.addChild(im);
        _priceTxt = new CTextField(217, 30, '');
        _priceTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _priceTxt.y = 5;
        _btn.addChild(_priceTxt);
        _source.addChild(_btn);
        _btn.clickCallback = onClickBuy;
        _txt = new CTextField(300, 30, '');
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE);
        _txt.x = -150;
        _txt.y = -20;
        _source.addChild(_txt);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _nameImage].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var im:Image;
        im = new Image(tex);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _woWidth = im.width;
        _woHeight = im.height;
        createExitButton(hideIt);
        _source.addChildAt(im,0);
        super.showIt();
//        _image = new Image(tex);
//        _image.pivotX = _image.width/2;
//        _image.pivotY = _image.height/2;
//        _source.addChild(_image);
//        _btn = new CButton();
//        _btn.addButtonTexture(200, 45, CButton.BLUE, true);
//        _btn.clickCallback = onClick;
//        txt = new CTextField(120,30,'Рассказать');
//        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        txt.x = 5;
//        txt.y = 7;
//        _btn.addChild(txt);
//        txt = new CTextField(50,50,'200');
//        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        txt.x = 119;
//        txt.y = -2;
//        _btn.addChild(txt);
//        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
//        im.x = 165;
//        im.y = 8;
//        _btn.addChild(im);
//        _btn.y = 240;
//        _source.addChild(_btn);
//        createExitButton(hideIt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataObject = params[0];
        _callback = callback;
        _btn.visible = true;
        var st:String;
        switch (params[2]) {
            case 'cave':
                _priceTxt.text = 'Отремонтировать ' + String(_dataObject.cost);
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/mine_window.png';
                g.load.loadImage(st + 'imageWindows/mine_window.png',onLoad);
                break;
            case 'house':
                _btn.visible = false;
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/hobbit_house_window.png';
                g.load.loadImage(st + 'imageWindows/hobbit_house_window.png',onLoad);
                break;
            case 'train':
                _priceTxt.text = 'Отремонтировать ' + String(_dataObject.cost);
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/aerial_tram_window.png';
                g.load.loadImage(st + 'imageWindows/aerial_tram_window.png',onLoad);
                break;
        }
    }
    
    private function onClickBuy(callob:Object = null, cost:int = 0):void {
        if (g.user.softCurrencyCount < _dataObject.cost) {
            var ob:Object = {};
            ob.currency = 2;
            ob.count = _dataObject.cost - g.user.softCurrencyCount;
            g.windowsManager.cashWindow = this;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuy, 'money', ob);
            return;
        }
        if (_callback != null) {
            _callback.apply();
        }
        if (isCashed) {
            g.windowsManager.uncasheWindow();
        } else {
            hideIt();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        if (_priceTxt) {
            _btn.removeChild(_priceTxt);
            _priceTxt.deleteIt();
            _priceTxt = null;
        }
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _dataObject = null;
        _nameImage = '';
        super.deleteIt();
    }

    override public function releaseFromCash():void {
        isCashed = false;
        deleteIt();
    }
}
}
