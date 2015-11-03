/**
 * Created by user on 5/25/15.
 */
package temp {

import manager.Vars;

import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class EditorButtonInterface {

    public var source:CSprite;
    private var _iconEditor:Sprite;
    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
        source = new CSprite();
        _iconEditor = new Sprite();
        source.y = - 10;
        var quad:Quad = new Quad(30, 50, Color.WHITE);
        source.addChild(quad);
    }

    public function setIconButton(s:String):void {
        if (s == "Active") {
            var q:Quad = new Quad(MatrixGrid.WIDTH_CELL, MatrixGrid.WIDTH_CELL, Color.RED);
            q.rotation = Math.PI/4;
            _iconEditor.addChild(q);
            _iconEditor.scaleY /= 2;
            _iconEditor.y = 5;
            _iconEditor.x = 15;
        } else{
            var im:Image = new Image(g.allData.atlas['mapAtlas'].getTexture(s));
            _iconEditor.addChild(im);
        }

        MCScaler.scale(_iconEditor, 30, 30);
        source.addChild(_iconEditor);
        source.flatten();
    }

    public function deleteIt():void {
        while (_iconEditor.numChildren) _iconEditor.removeChildAt(0);
        while (source.numChildren) source.removeChildAt(0);
        source.deleteIt();
        _iconEditor = null;
        source = null;
    }
}
}
