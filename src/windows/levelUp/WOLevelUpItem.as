/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOLevelUpItem {
    public var source:CSprite;
    private var _txtNew:TextField;
    private var _txtCount:TextField;
    private var _image:Image;
    private var _imageBg:Image;
    private var _data:Object;
    private var _onHover:Boolean;
    private var _bolHouse:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOLevelUpItem(ob:Object, boNew:Boolean, boCount:Boolean, count:int = 0) {
        if (!ob) {
            Cc.error('WOLevelUpItem:: ob == null');
            g.woGameError.showIt();
            return;
        }
        var objAnimals:Object;
        var obj:Object;
        var id:String;
        _data = ob;
        source = new CSprite();
        _onHover = false;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _txtNew = new TextField(80,20,'',g.allData.fonts['BloggerBold'],16,Color.WHITE);
        _txtNew.nativeFilters = ManagerFilters.TEXT_STROKE_RED;
        _txtNew.y = 65;
        _txtNew.x = -5;
        _txtCount = new TextField(80,20,'',g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_RED;
        _txtCount.x = 15;
        _txtCount.y = 10;
        try {
            _txtNew.text = 'НОВОЕ!';
            if (ob.coins) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                _txtCount.text = '+' + String(ob.countSoft);
                _txtNew.text = '';
                g.userInventory.addMoney(2,ob.countSoft)
            }
            if (ob.hard) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                _txtCount.text = '+' + String(ob.countHard);
                _txtNew.text = '';
                g.userInventory.addMoney(1,ob.countHard)
            }

            if (ob.decorData) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[ob.id].image + '_icon'));
                if (!_image) {
                    _image = new Image(g.allData.atlas[g.dataBuilding.objectBuilding[ob.id].url].getTexture(g.dataBuilding.objectBuilding[ob.id].image));
                }
                _txtCount.text = '+' + String(ob.count);
                _txtNew.text = '';
                _bolHouse = true;
                var f1:Function = function (dbId:int):void {
                    g.userInventory.addToDecorInventory(ob.id, dbId);
                };
                    g.directServer.buyAndAddToInventory(ob.id, f1);
            }


            if (ob.resourceData) {
                _image = new Image(g.allData.atlas[g.dataResource.objectResources[ob.id].url].getTexture(g.dataResource.objectResources[ob.id].imageShop));
                _txtCount.text = '+' + String(ob.count);
                _txtNew.text = '';
                g.userInventory.addResource(ob.id,ob.count);
            }
            if (ob.buildType == BuildType.FARM) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.RIDGE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.FABRICA) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.TREE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.RESOURCE) {
                objAnimals = [];
                obj = g.dataAnimal.objectAnimal;
                for (id in obj) {
                   if (obj[id].idResourceRaw == ob.id){
                       _txtCount.text = '+3';
                       g.userInventory.addResource(ob.id,3);
                        break;
                   }
                }
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.PLANT) {
                _txtCount.text = '+3';
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(ob.imageShop + '_icon'));
            } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                    || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.DECOR) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                if (!_image) {
                    _image = new Image(g.allData.atlas[ob.url].getTexture(ob.image));
                }
                _bolHouse = true;
            } else if (ob.buildType == BuildType.ANIMAL) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.INSTRUMENT) {
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.ORDER || ob.buildType == BuildType.DAILY_BONUS
                    || ob.buildType == BuildType.SHOP || ob.buildType == BuildType.CAVE || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
                 _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            }
        } catch (e:Error) {
            Cc.error('WOLevelUpItem:: error with _image for data.id: ' + ob.id);
        }

        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 60 - _imageBg.height/2;
        MCScaler.scale(_imageBg,80,80);
        source.addChild(_imageBg);
        if (_image) {
            MCScaler.scale(_image, 68, 68);
            _image.x = 38 - _image.width / 2;
            _image.y = 47 - _image.height / 2;
            source.addChild(_image);
            source.addChild(_txtNew);
            source.addChild(_txtCount);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + count);
        }
    }

    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        if (_image) _image.dispose();
        if (_txtCount) _txtCount.dispose();
        if (_txtNew) _txtNew.dispose();
        _imageBg.dispose();
        _image = null;
        _imageBg = null;
        source = null;
        _bolHouse = false;
    }

    private function onHover():void {
        if (_onHover) return;
        if (_data.coins) return;
        if (_data.hard) return;

        _onHover = true;
        g.levelUpHint.showIt(_data.id,source.x,source.y,source, _bolHouse);
    }

    private function onOut():void {
        g.levelUpHint.hideIt();
        _onHover = false;
    }
}
}
