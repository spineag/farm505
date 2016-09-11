/**
 * Created by andy on 9/9/16.
 */
package quest {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import flash.display.Bitmap;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import utils.CSprite;

public class QuestIcon {
    private var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var _clickCallback:Function;
    private var _onLoadCallback:Function;
    private var _source:CSprite;
    private var _parent:Sprite;
    private var _positionInList:int;
    private var _imageQuest:Image;
    private var _isOnHover:Boolean;

    public function QuestIcon(qData:Object, click:Function, onLoadCallback:Function) {
        _isOnHover = false;
        _data = qData;
        _clickCallback = click;
        _onLoadCallback = onLoadCallback;
        _source = new CSprite();
        g.load.loadImage(g.dataPath.getQuestIconPath() + _data.iconUrl, onLoad);
    }

    private function onLoad(b:Bitmap):void {
        _imageQuest = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getQuestIconPath() + _data.iconUrl].create() as Bitmap));
        _imageQuest.x = - _imageQuest.width/2;
        _imageQuest.y = - _imageQuest.height/2;
        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        if (_onLoadCallback != null) {
            _onLoadCallback.apply();
            _onLoadCallback = null;
        } else {
            _source.addChild(_imageQuest);
        }
    }

    private function onHover():void {
        if (_isOnHover) return;
        g.hint.showIt(_data.text);
    }

    private function onOut():void {
        if (!_isOnHover) return;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data]);
        }
    }

    public function setPosition(p:Sprite, pos:int):void {
        _parent = p;
        _positionInList = pos;
        _source.y = _positionInList * ManagerQuest.DELTA_ICONS + 50;
        _parent.addChild(_source);
    }

    public function get pos():int {
        return _positionInList;
    }

    public function showAnimate(delay:Number):void {
        _source.addChild(_imageQuest);
        _source.scale = .3;
        _source.alpha = 0;
        new TweenMax(_source, .2, {scaleX:1.2, scaleY:1.2, alpha:1, ease:Linear.easeIn, onComplete:showIt1, delay: delay});
    }

    private function showIt1():void {
        new TweenMax(_source, .2, {scaleX:.9, scaleY:.9, ease:Linear.easeIn, onComplete:showIt2});
    }

    private function showIt2():void {
        new TweenMax(_source, .2, {scaleX:1, scaleY:1, ease:Linear.easeIn});
    }
}
}
