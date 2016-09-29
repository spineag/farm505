/**
 * Created by user on 11/27/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.BlendMode;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import utils.CTextField;

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

    private var _txt:CTextField;
    private var _width:int;
    private var _height:int;
    private var _bg:Sprite;
    public var inSprite:Sprite;
    private var g:Vars = Vars.getInstance();

    public function HintBackground(wt:int, ht:int, typeTriangle:int = NONE_TRIANGLE, trianglePosition:int = 0) {
        var te:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (wt%2) wt++;
        if (ht%2) ht++;
        _width = wt;
        _height = ht;
        createBG(_width, _height, te);
        if (typeTriangle == NONE_TRIANGLE) {
            addChild(_bg);
        } else {
            var im:Image;
            var h:int;
            if (typeTriangle == SMALL_TRIANGLE) {
                im = new Image(te.getTexture('hint_tooth_small'));
                h = small_height;
            } else if (typeTriangle == LONG_TRIANGLE) {
                im = new Image(te.getTexture('hint_tooth_long'));
                h = long_height;
            } else if (typeTriangle == BIG_TRIANGLE) {
                im = new Image(te.getTexture('hint_tooth_big'));
                h = big_height;
            }

            im.pivotX = im.width/2;
            im.pivotY = im.height;
            switch (trianglePosition) {
                case TOP_LEFT:
                    im.scaleY = -1;
                    _bg.x = int(-16 - im.width/2);
                    _bg.y = h;
                    break;
                case TOP_CENTER:
                    im.scaleY = -1;
                    _bg.x = int(-_width/2);
                    _bg.y = h;
                    break;
                case TOP_RIGHT:
                    im.scaleY = -1;
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = h;
                    break;
                case BOTTOM_LEFT:
                    _bg.x = int(-16-im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case BOTTOM_CENTER:
                    _bg.x = int(-_width/2);
                    _bg.y = int(-h-_height);
                    break;
                case BOTTOM_RIGHT:
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case LEFT_TOP:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-16-im.height/2);
                    break;
                case LEFT_CENTER:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-ht/2);
                    break;
                case LEFT_BOTTOM:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-_height+16+im.height/2);
                    break;
                case RIGHT_TOP:
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-16-im.height/2);
                    break;
                case RIGHT_CENTER:
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-_height/2);
                    break;
                case RIGHT_BOTTOM:
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

    private function createBG(w:int, h:int, tex:TextureAtlas):void {
        var im:Image;
        var arr:Array = [];
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
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.x = arr[0].width;
        im.tileGrid = im.tileGrid;
        _bg.addChildAt(im, 0);
        im = new Image(tex.getTexture('hint_down'));
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width + 2;
        im.x = arr[0].width - 1;
        im.y = h - im.height;
        im.tileGrid = im.tileGrid;
        _bg.addChildAt(im, 0);

        // left and right
        im = new Image(tex.getTexture('hint_left'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[1].height;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        _bg.addChildAt(im, 0);
        im = new Image(tex.getTexture('hint_right'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[1].height;
        im.x = w - im.width;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        _bg.addChildAt(im, 0);

        im = new Image(tex.getTexture('hint_center'));
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.height = h - arr[0].height - arr[1].height;
        im.x = arr[0].width;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        _bg.addChildAt(im, 0);

        arr.length = 0;
    }

    public function addShadow():void {
        _bg.filter = ManagerFilters.SHADOW_LIGHT;
    }


    public function flipTxt(v:Boolean):void {
        if (!v) {
            _txt.x = _bg.x + 5;
            _txt.y = _bg.y + 5;
            _txt.width = 1;
        } else {
            _txt.x = _bg.x + _bg.width - 5;
            _txt.y = _bg.y + _bg.height - 5;
            _txt.width = -1;
        }
    }

    public function addTextField(size:int):void {
        deleteTextField();
        var s:String;
        if (size >= 20) s = CTextField.BOLD24;
        else if (size > 14) s = CTextField.BOLD18;
        else s = CTextField.BOLD18;
        _txt = new CTextField(_width - 10, _height - 20,'');
        _txt.setFormat(s, size, ManagerFilters.BLUE_COLOR);
        _txt.x = _bg.x + 5;
        _txt.y = _bg.y + 5;
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

    public function deleteIt():void {
        dispose();
        _txt = null;
        _bg = null;
        inSprite = null;
    }
}
}
