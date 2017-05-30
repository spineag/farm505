/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataAnimal;
import data.StructureDataBuilding;
import data.StructureDataResource;

import manager.ManagerFilters;
import manager.Vars;

import mouse.BuildMoveGridTile;

import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOLevelUpItem {
    public var source:CSprite;
    private var _txtNew:CTextField;
    private var _txtCount:CTextField;
    private var _image:Image;
    private var _imageBg:Image;
    private var _data:Object;
    private var _onHover:Boolean;
    private var _bolHouse:Boolean;
    private var _bolAnimal:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOLevelUpItem(ob:Object, boNew:Boolean, boCount:Boolean, count:int = 0, wallNew:Boolean = false) {
        if (!ob) {
            Cc.error('WOLevelUpItem:: ob == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLevelUpItem');
            return;
        }
        var obj:Object;
        var id:String;
        _data = ob;
        source = new CSprite();
        _onHover = false;
        _bolAnimal = false;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _txtNew = new CTextField(80,20,' ');
        _txtNew.setFormat(CTextField.BOLD18, 18, Color.WHITE, Color.RED);
        _txtNew.cacheIt = false;
        _txtNew.y = 65;
        _txtNew.x = -3;
        _txtCount = new CTextField(80,20,' ');
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, Color.RED);
        _txtCount.cacheIt = false;
        _txtCount.x = 15;
        _txtCount.y = 10;
        try {
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && ob.coins) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                _txtCount.text = '+' + String(ob.countSoft);
//                _txtNew.text = '';
                g.userInventory.addMoney(2,ob.countSoft)
            }
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && ob.hard) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                _txtCount.text = '+' + String(ob.countHard);
//                _txtNew.text = '';
                g.userInventory.addMoney(1,ob.countHard)
            }

            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding)&& ob.decorData) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(ob.id).image + '_icon'));
                if (!_image) {
                    _image = new Image(g.allData.atlas[g.allData.getBuildingById(ob.id).url].getTexture(g.allData.getBuildingById(ob.id).image));
                }
                _txtCount.text = '+' + String(ob.count);
//                _txtNew.text = '';
                _bolHouse = true;
                var f1:Function = function (dbId:int):void {
                    g.userInventory.addToDecorInventory(ob.id, dbId);
                };
                g.directServer.buyAndAddToInventory(ob.id, f1);
            }


            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding)&& ob.resourceData) {
                if (g.allData.getResourceById(ob.id).buildType == BuildType.PLANT) {
                    _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(ob.id).imageShop + '_icon'));
                } else {
                    _image = new Image(g.allData.atlas[g.allData.getResourceById(ob.id).url].getTexture(g.allData.getResourceById(ob.id).imageShop));
                }
                _txtCount.text = '+' + String(ob.count);
//                _txtNew.text = '';
                g.userInventory.addResource(ob.id,ob.count);
            }

            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding)&& ob.catCount) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
                _txtCount.text = String(ob.count);
//                _txtNew.text = '';
                _data.id = -1;
            }
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && ob.ridgeCount) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('ridge_icon'));
                _txtCount.text = String(count);
//                _txtNew.text = '';
                _data.id = -2;
            }
            if (ob.buildType == BuildType.FARM) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
            } else if (ob.buildType == BuildType.RIDGE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
            } else if (ob.buildType == BuildType.FABRICA) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon'));
                _bolHouse = true;
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
            } else if (ob.buildType == BuildType.TREE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
            } else if (ob.buildType == BuildType.RESOURCE) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                if (ob is StructureDataAnimal) _txtCount.text = '+3';
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.PLANT) {
                _txtCount.text = '+3';
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(ob.imageShop + '_icon'));
            } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                    || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.DECOR || ob.buildType == BuildType.DECOR_FENCE_ARKA) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                if (ob.image) {
                    var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon');
                    if (!texture) {
                        texture = g.allData.atlas[_data.url].getTexture(_data.image);
                    }
                }
                _image = new Image(texture);
                _bolHouse = true;
            } else if (ob.buildType == BuildType.ANIMAL) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                _bolHouse = true;
                _bolAnimal = true;
            } else if (ob.buildType == BuildType.INSTRUMENT) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
                 _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.CAVE) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.DAILY_BONUS) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('daily_bonus_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.ORDER) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('orders_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.DECOR_ANIMATION) {
                _txtNew.text = String(g.managerLanguage.allTexts[424]);
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon'));
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
            if (!wallNew) source.addChild(_txtNew);
            if (!wallNew) source.addChild(_txtCount);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + count);
        }
    }

    public function deleteIt():void {
       source.deleteIt();
        if (_txtCount) {
            source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
       if (_txtNew) {
           source.removeChild(_txtNew);
           _txtNew.deleteIt();
           _txtNew = null;
       }
        _image = null;
        _imageBg = null;
        source = null;
    }

    private function onHover():void {
        return;
        if (_onHover) return;
//        if (g.managerTutorial.isTutorial) return;
        if (_data.coins) return;
        if (_data.hard) return;

        _onHover = true;
        g.levelUpHint.showIt(_data.id,source.x,source.y,source, _bolHouse,_bolAnimal);
    }

    private function onOut():void {
        return;
        g.levelUpHint.hideIt();
        _onHover = false;
    }
}
}