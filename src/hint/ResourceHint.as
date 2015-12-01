/**
 * Created by user on 7/23/15.
 */
package hint {
import com.junkbyte.console.Cc;

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
        _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock_icon"));
        MCScaler.scale(_imageClock,30,30);
        _imageClock.y = 30;
        _txtName = new TextField(150,30,"","Arial",13,Color.BLACK);
        _txtName.x = 10;
        _txtName.y = -5;
        _txtTime = new TextField(50,50,"","Arial",14,Color.BLACK);
        _txtTime.x = 30;
        _txtTime.y = 20;
        _txtText = new TextField(150,100,"","Arial",12,Color.BLACK);
//        _txtText.x = -10;
        _txtText.y = -20;
        _source.addChild(q);
        _source.addChild(_txtName);
        _source.addChild(_txtText);
        _source.addChild(_txtTime);
        _source.addChild(_imageClock);
        _source.touchable = false;
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite):void {
        var obj:Object;
        var id:String;

        if (!g.dataResource.objectResources[_dataId]) {
            Cc.error('ResourceHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.woGameError.showIt();
            return;
        }

        var start:Point = new Point(int(sX), int(sY));
        start = source.parent.localToGlobal(start);
        _source.x = start.x - 25;
        _source.y = start.y - 60;
        _imageClock.visible = true;
        _txtTime.visible = true;
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (_dataId == obj[id].craftIdResource) {
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Растет на: " + obj[id].name;
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
                g.cont.hintCont.addChild(_source);
                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.PLANT) {
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Растет на грядке";
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
                g.cont.hintCont.addChild(_source);
                return;
            }
            if (g.dataResource.objectResources[_dataId].buildType == BuildType.INSTRUMENT) {
                    _imageClock.visible = false;
                    _txtTime.visible = false;
                    _txtText.text = String(g.dataResource.objectResources[_dataId].opys);
                    _txtName.text = String(g.dataResource.objectResources[_dataId].name);
                    g.cont.hintCont.addChild(_source);
                    return;
            }
        }
        obj = g.dataRecipe.objectRecipe;
        for (id in obj) {
            if (_dataId == obj[id].idResource){
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Место производства: " + g.dataBuilding.objectBuilding[obj[id].buildingId].name;
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
                g.cont.hintCont.addChild(_source);
                return;
            }
                _txtTime.text = String(g.dataResource.objectResources[_dataId].buildTime);
                _txtText.text = "Место производства: Пещера";
                _txtName.text = String(g.dataResource.objectResources[_dataId].name);
                g.cont.hintCont.addChild(_source);
        }
    }

    public function hideIt():void {
        g.cont.hintCont.removeChild(_source);
    }
}
}
