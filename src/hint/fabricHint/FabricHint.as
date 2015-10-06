/**
 * Created by user on 7/13/15.
 */
package hint.fabricHint {

import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class FabricHint {
    private var _imageClock:Image;
    private var _imageItem:Image;
    private var _txtName:TextField;
    private var _txtCreate:TextField;
    private var _txtTimeCreate:TextField;
    private var _txtOnSklad:TextField;
    private var _txtItem:TextField;
    private var _txtTime:TextField;
    private var _source:Sprite;
    private var _arrCells:Array;
    private var _contImage:Sprite;

    private var g:Vars = Vars.getInstance();

    public function FabricHint() {
        _source = new Sprite();
        _contImage = new Sprite();
        _arrCells = [];
        var q:Quad = new Quad(200, 200, Color.AQUA);
        q.pivotX = 0;
        q.pivotY = 0;
        _imageClock = new Image(g.interfaceAtlas.getTexture("clock_icon"));
        MCScaler.scale(_imageClock,30,30);
        _imageClock.x = 10;
        _imageClock.y = q.height - 35;
        _txtName = new TextField(200,100,"","Arial",14,Color.BLACK);
        _txtName.y = -20;
        _txtCreate = new TextField(200,100,"Для изготовления требуется", "Arial",14,Color.BLACK);
        _txtCreate.x = -5;
        _txtCreate.y = 10;
        _txtTimeCreate = new TextField(150,100,"Время производства:","Arial",10,Color.BLACK);
        _txtTimeCreate.x = -20;
        _txtTimeCreate.y = 100;
        _txtOnSklad = new TextField(100,100,"На складе:","Arial",10,Color.BLACK);
        _txtOnSklad.x = 100;
        _txtOnSklad.y = 100;
        _txtItem = new TextField(100,100,"","Arial",14,Color.BLACK);
        _txtItem.x = 100;
        _txtItem.y = 130;
        _txtTime = new TextField(100,100,"","Arial",14,Color.BLACK);
        _txtTime.x = 20;
        _txtTime.y = 130;

        _source.addChild(q);
        _source.addChild(_txtName);
        _source.addChild(_txtCreate);
        _source.addChild(_txtTimeCreate);
        _source.addChild(_txtOnSklad);
        _source.addChild(_txtItem);
        _source.addChild(_txtTime);
        _source.addChild(_imageClock);
        _source.addChild(_contImage);
//        _source.x = 300;
//        _source.y = 300;
    }

    public function showIt(data:Object, sX:int, sY:int):void {
        if (data && g.dataResource.objectResources[data.idResource]) {
            _txtName.text = String(g.dataResource.objectResources[data.idResource].name);
            _txtTime.text = String(g.dataResource.objectResources[data.idResource].buildTime);
            _txtItem.text = String(g.userInventory.getCountResourceById(data.idResource));
            createList(data);
            _source.removeChild(_imageItem);
            _imageItem = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[data.idResource].imageShop));
            if (!_imageItem) {
                Cc.error('FabricHint showIt:: no such image: ' + g.dataResource.objectResources[data.idResource].imageShop);
                g.woGameError.showIt();
                return;
            }
            _imageItem.x = 160;
            _imageItem.y = 160;
            MCScaler.scale(_imageItem, 40,40);
            _source.addChild(_imageItem);
            _source.x = sX - 50;
            _source.y = sY + 100;
            g.cont.hintCont.addChild(_source);
        } else {
            Cc.error('FabricHint showIt with empty data or g.dataResource.objectResources[data.idResource] = null');
        }
    }

    public function clearIt():void {
        _source.removeChild(_imageItem);
        g.cont.hintCont.removeChild(_source);

        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _arrCells.length = 0;
    }

    private function createList(data:Object):void {
        if (!data) {
            Cc.error('FabricHint createList:: empty data');
            g.woGameError.showIt();
            return;
        }
        var im:FabricHintItem;
        for (var i:int = 0; i < data.ingridientsId.length; i++) {
            im = new FabricHintItem(int(data.ingridientsId[i]), int(data.ingridientsCount[i]));
            im.source.x = int (i * 45);
            _arrCells.push(im);
            _contImage.addChild(im.source);
            _contImage.y = 50;
            switch (data.ingridientsId.length) {
                case 1:
                    _contImage.x = 50;
                    break;
                case 2:
                    _contImage.x = 30;
                    break;
                case 3:
                    _contImage.x = 10;
                    break;
                case 4:
                    _contImage.x = -20;
                    break;
            }
        }
    }
}
}
