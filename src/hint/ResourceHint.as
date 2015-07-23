/**
 * Created by user on 7/23/15.
 */
package hint {
import data.BuildType;

import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class ResourceHint {
    private var _source:Sprite;
    private var _image:Image;
    private var _imageClock:Image;
    private var _txtName:TextField;
    private var _txtTime:TextField;
    private var _txtText:TextField;

    private var g:Vars = Vars.getInstance();
    public function ResourceHint() {
        _source = new Sprite();
        var q:Quad = new Quad(150, 60, Color.OLIVE);
        q.pivotX = 0;
        q.pivotY = 0;
        _imageClock = new Image(g.interfaceAtlas.getTexture("clock_icon"));
        MCScaler.scale(_imageClock,30,30);
        _imageClock.y = 30;
        _txtName = new TextField(100,30,"","Arial",14,Color.BLACK);
        _txtName.x = 25;
        _txtName.y = 5;
        _txtTime = new TextField(50,50,"","Arial",14,Color.BLACK);
        _txtTime.x = 30;
        _txtTime.y = 20;
        _txtText = new TextField(100,100,"","Arial",14,Color.BLACK);
        _source.addChild(q);
        _source.addChild(_txtName);
        _source.addChild(_txtText);
        _source.addChild(_txtTime);
        _source.addChild(_imageClock);

    }

    public function showIt(_data:int, text:String,sX:int,sY:int,source:Sprite):void {
            var start:Point = new Point(int(sX), int(sY));
            start = source.parent.localToGlobal(start);
            _source.x = start.x - 25;
            _source.y = start.y - 60;
            if (g.dataResource.objectResources[_data].buildType == BuildType.INSTRUMENT) {
                _imageClock.visible = false;
                _txtTime.visible = false;
            }
            if (g.dataResource.objectResources[_data].buildType == BuildType.INSTRUMENT) {
                _imageClock.visible = false;
                _txtTime.visible = false;
            }
            _txtTime.text = String(g.dataResource.objectResources[_data].buildTime);
            _txtText.text = text;
            _txtName.text = String(g.dataResource.objectResources[_data].name);

            g.cont.hintCont.addChild(_source);
    }

    public function hideIt():void {
        g.cont.hintCont.removeChild(_source);
    }
}
}
