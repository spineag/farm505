/**
 * Created by user on 9/14/15.
 */
package windows.train {
import build.train.TrainCell;

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class WOTrainOrderItem {
    public var source:CSprite;
    private var _im:Image;
    private var _index:int;
    private var _info:TrainCell;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOTrainOrderItem() {
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _onHover = false;
    }

    public function fillIt(t:TrainCell, i:int):void {
        _index = i;
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainOrderItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        _im = _info.getImage();
        if (!_im) {
            Cc.error('WOTrainOrderItem fillIt:: no such image: ' + g.dataResource.objectResources[_info.id].imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        var _bg:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_green'));
        _bg.width = 100;
        source.addChild(_bg);
        MCScaler.scale(_im, 80, 80);
        _im.x = 50 - _im.width/2;
        _im.y = 45 - _im.height/2;
        source.addChild(_im);
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.resourceHint.showIt(_info.id,source.x,source.y,source);
    }

    private function onOut():void {
        _onHover = false;
        g.resourceHint.hideIt();
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }
}
}
