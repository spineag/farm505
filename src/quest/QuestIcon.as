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
    private var _galo4ka:Image;

    public function QuestIcon(qData:Object, click:Function, onLoadCallback:Function) {
        _isOnHover = false;
        _data = qData;
        _data.questIcon = this;
        _clickCallback = click;
        _onLoadCallback = onLoadCallback;
        _source = new CSprite();
        g.load.loadImage(g.dataPath.getQuestIconPath() + _data.iconUrl, onLoad);
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _galo4ka.x = 35 - int(_galo4ka.width/2);
        _galo4ka.y = 40 - int(_galo4ka.height/2);
        _source.addChild(_galo4ka);
        updateInfo();
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
            _source.addChildAt(_imageQuest, 0);
        }
    }

    private function onHover():void {
        if (_isOnHover) return;
        _isOnHover = true;
        g.hint.showIt(_data.text);
    }

    private function onOut():void {
        if (!_isOnHover) return;
        _isOnHover = false;
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

    public function get position():int {
        return _positionInList;
    }

    public function showAnimate(delay:Number):void {
        _source.addChildAt(_imageQuest, 0);
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

    public function updateInfo():void {
        _galo4ka.visible = _data.isDone;
    }
    
    public function moveToNewPosition(pos:int):void {
        _positionInList = pos;
        TweenMax.to(_source, .5, {y: _positionInList * ManagerQuest.DELTA_ICONS + 50});
    }
    
    public function deleteIt():void {
        _parent.removeChild(_source);
        _parent = null;
        _source.deleteIt();
    }
}
}
