/**
 * Created by user on 6/9/15.
 */
package hint {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class FarmHint {
    public var source:CSprite;
    private var _isOnHover:Boolean;
    private var _textureHint:Image;
    private var _animal:Image;
    private var _countTxt:TextField;
    private var _nameTxt:TextField;
    private var _callback:Function;
    private var g:Vars = Vars.getInstance();

    public function FarmHint() {
        _isOnHover = false;
        source = new CSprite();
        source.nameIt = 'farmHint';
        _textureHint = new Image(g.allData.atlas['interfaceAtlas'].getTexture("popup_farm"));
        source.addChild(_textureHint);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        var quad:Quad = new Quad(source.width, source.height,Color.WHITE);
        quad.alpha = 0;
        source.addChildAt(quad,0);
        source.hoverCallback = onHover;
        source.outCallback = outHover;
        source.endClickCallback = onClick;

        _countTxt = new TextField(50,30," ");
        _countTxt.format.setTo(g.allData.bFonts['BloggerRegular18'], 18, Color.WHITE);
        _nameTxt = new TextField(70,30," ");
        _nameTxt.format.setTo(g.allData.bFonts['BloggerRegular14'], 14, Color.BLACK);
        _nameTxt.x = 10;
        _nameTxt.y = 65;
        source.addChild(_nameTxt);
        _countTxt.x = 85;
        _countTxt.y = 50;
        source.addChild(_countTxt);
    }

    public function showIt(x:int, y:int, dataAnimal:Object, f:Function):void {
        g.managerHelpers.onUserAction();
        hideIt();

        if (!dataAnimal) {
            Cc.error('FarmHint showIt:: empty dataAnimal');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'farmHint');
            return;
        }

        _callback = f;
        source.x = x;
        source.y = y;
        _animal = new Image(g.allData.atlas[dataAnimal.url].getTexture(dataAnimal.image));
        if (!_animal) {
            Cc.error('FarmHint showIt: no such image ' + dataAnimal.image);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'farmHint');
            return;
        }
        _animal.scaleX = _animal.scaleY = 2;
        MCScaler.scale(_animal, 50, 50);
        _animal.x = 20;
        _animal.y = 20;
        source.addChild(_animal);
        _nameTxt.text = String(dataAnimal.name);
        _countTxt.text = String(dataAnimal.cost);
        g.cont.hintGameCont.addChild(source);
    }

    public function hideIt():void {
        if (_isOnHover) return;

        if (g.cont.hintGameCont.contains(source)) {
            g.cont.hintGameCont.removeChild(source);
        }
        if (_animal) {
            source.removeChild(_animal);
            _animal = null;
        }
        _nameTxt.text = '';
        _countTxt.text = '';
        _callback = null;
    }

    private function onHover():void {
        _isOnHover = true;
    }

    private function outHover():void {
        _isOnHover = false;
        hideIt();
    }

    private function onClick():void {
        if (_callback != null) {
            _callback.apply();
        }
    }
}
}