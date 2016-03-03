/**
 * Created by user on 11/27/15.
 */
package windows.WOComponents {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.textures.TextureAtlas;

public class HintBackground extends Sprite {
    public static const NONE_TRIANGLE:int = 1;
    public static const SMALL_TRIANGLE:int = 2;
    public static const LONG_TRIANGLE:int = 3;
    public static const BIG_TRIANGLE:int = 4;

    private const long_height:int = 28;
    private const big_height:int = 37;
    private const small_height:int = 17;

    public static const LEFT_TOP:int = 5;
    public static const LEFT_CENTER:int = 6;
    public static const LEFT_BOTTOM:int = 7;
    public static const TOP_LEFT:int = 8;
    public static const TOP_CENTER:int = 9;
    public static const TOP_RIGHT:int = 10;
    public static const RIGHT_TOP:int = 11;
    public static const RIGHT_CENTER:int = 12;
    public static const RIGHT_BOTTOM:int = 13;
    public static const BOTTOM_LEFT:int = 14;
    public static const BOTTOM_CENTER:int = 15;
    public static const BOTTOM_RIGHT:int = 16;

    private var _txt:TextField;
    private var _width:int;
    private var _height:int;
    private var _bg:Sprite;
    public var inSprite:Sprite;
    private var g:Vars = Vars.getInstance();

    public function HintBackground(wt:int, ht:int, typeTriangle:int = NONE_TRIANGLE, trianglePosition:int = 0) {
        if (wt%2) wt++;
        if (ht%2) ht++;
        _width = wt;
        _height = ht;
        createBG(_width, _height);
        if (typeTriangle == NONE_TRIANGLE) {
            addChild(_bg);
        } else {
            var im:Image;
            var h:int;
            if (typeTriangle == SMALL_TRIANGLE) {
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_tooth_small'));
                h = small_height;
            } else if (typeTriangle == LONG_TRIANGLE) {
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_tooth_long'));
                h = long_height;
            } else if (typeTriangle == BIG_TRIANGLE) {
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_tooth_big'));
                h = big_height;
            }

            switch (trianglePosition) {
                case TOP_LEFT:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.scaleY = -1;
                    _bg.x = int(-16 - im.width/2);
                    _bg.y = h;
                    break;
                case TOP_CENTER:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.scaleY = -1;
                    _bg.x = int(-_width/2);
                    _bg.y = h;
                    break;
                case TOP_RIGHT:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.scaleY = -1;
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = h;
                    break;
                case BOTTOM_LEFT:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    _bg.x = int(-16-im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case BOTTOM_CENTER:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    _bg.x = int(-_width/2);
                    _bg.y = int(-h-_height);
                    addChildAt(_bg, 0);
                    break;
                case BOTTOM_RIGHT:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case LEFT_TOP:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-16-im.height/2);
                    addChildAt(_bg, 0);
                    break;
                case LEFT_CENTER:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-ht/2);
                    break;
                case LEFT_BOTTOM:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-_width+16+im.height/2);
                    break;
                case RIGHT_TOP:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-16-im.height/2);
                    break;
                case RIGHT_CENTER:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-_height/2);
                    break;
                case RIGHT_BOTTOM:
                    im.pivotX = im.width/2;
                    im.pivotY = im.height;
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-_height+16+im.height/2);
                    break;
            }
            addChild(im);
            addChildAt(_bg, 0);
        }

        inSprite = new Sprite();
        inSprite.x = _bg.x;
        inSprite.y = _bg.y;
        addChild(inSprite);
    }

    private function createBG(w:int, h:int):void {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;

        _bg = new Sprite();
        //top left
        im = new Image(tex.getTexture('hint_left_up'));
        im.x = 0;
        im.y = 0;
        _bg.addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('hint_left_down'));
        im.x = 0;
        im.y = h - im.height;
        _bg.addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('hint_right_up'));
        im.x = w - im.width;
        im.y = 0;
        _bg.addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('hint_right_down'));
        im.x = w - im.width;
        im.y = h - im.height;
        _bg.addChild(im);
        arr.push(im);

        //top center and bottom center
        im = new Image(tex.getTexture('hint_up'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/(im.width-1));
        countW += 2;
        for (i=0; i<=countW; i++) {
            im = new Image(tex.getTexture('hint_up'));
            im.x = arr[0].x + arr[0].width + i*(im.width-1) - 1;
            im.y = 0;
            _bg.addChildAt(im, 0);
            im = new Image(tex.getTexture('hint_down'));
            im.x = arr[1].x + arr[1].width + i*(im.width-1) - 1;
            im.y = h - im.height;
            _bg.addChildAt(im, 0);
        }

        // left and right
        im = new Image(tex.getTexture('hint_left'));
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*im.height < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<=countH; i++) {
            im = new Image(tex.getTexture('hint_left'));
            im.y = arr[0].y + arr[0].height + i*im.height;
            im.x = 0;
            _bg.addChildAt(im, 0);
            im = new Image(tex.getTexture('hint_right'));
            im.y = arr[2].y + arr[2].height + i*im.height;
            im.x = w - im.width;
            _bg.addChildAt(im, 0);
        }

        im = new Image(tex.getTexture('hint_center'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/(im.width-1)) + 2;
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        for (i=0; i<countW; i++) {
            for (var j:int=0; j<countH; j++) {
                im = new Image(tex.getTexture('hint_center'));
                im.x = arr[0].x + arr[0].width + i*(im.width-1) - 1;
                im.y = arr[0].y + arr[0].height + j*im.height;
                _bg.addChildAt(im, 0);
            }
        }

        arr.length = 0;
        _bg.flatten();
    }

    public function addShadow():void {
        _bg.filter = ManagerFilters.SHADOW_LIGHT;
    }

    public function flipIt(v:Boolean):void {

    }

    public function flipTxt(v:Boolean):void {

    }

    public function addTextField():void {
        deleteTextField();
        _txt = new TextField(_bg.width, _bg.height,'',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN);
        _txt.x = _bg.x;
        _txt.y = _bg.y;
        addChild(_txt);
    }

    public function setText(st:String):void {
        _txt.text = st;
    }

    private function deleteTextField():void {
        if (_txt) {
            removeChild(_txt);
            _txt.dispose();
            _txt = null;
        }
    }

    public function clearIt():void {
        deleteTextField();
        _bg.filter = null;
        while (numChildren) removeChildAt(0);
        _bg.unflatten();
        while (_bg.numChildren) _bg.removeChildAt(0);
        _bg.dispose();
        while (inSprite.numChildren) inSprite.removeChildAt(0);
        inSprite.dispose();
        dispose();
    }
}
}
