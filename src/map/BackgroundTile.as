/**
 * Created by user on 5/18/15.
 */
package map {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;

public class BackgroundTile {
    private var _graphicsSource:Image;
    private var _type:int;
    public var posX:Number;
    public var posY:Number;
    private var _isInGame:Boolean;

    protected var g:Vars = Vars.getInstance();

    public function BackgroundTile(type:int, isInGame:Boolean = false) {
        _type = type;
        _isInGame = isInGame;

        switch (_type) {
            case 1:
               _graphicsSource = new Image(g.mapAtlas.getTexture("tile1"));
                break;
            case 2:
               _graphicsSource = new Image(g.mapAtlas.getTexture("tile2"));
                break;
        }

        if (_graphicsSource) {
            if (!_isInGame) _graphicsSource.visible = false;
//        _graphicsSource.alpha = .2;
            _graphicsSource.visible = false;
        } else {
            Cc.error('BackgroundTile:: no _graphicsSource for type: ' + _type);
        }

    }

    public function get graphicsSource():Image {
        return _graphicsSource;
    }
}
}
