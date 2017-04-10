/**
 * Created by user on 9/12/16.
 */
package build.cafe {
import build.WorldObject;

import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import flash.geom.Point;

import hint.FlyMessage;

import loaders.PBitmap;

import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.CSprite;

import windows.WindowsManager;

public class Cafe extends WorldObject {

    private var _isHover:Boolean;
    private var _spriteFirst:Sprite;
    private var _spriteSecond:Sprite;
    private var _spriteThird:Sprite;
    private var _imDoor:Image;
    private var _imDoorTent:Image;
    private var _imBaner:Image;
    private var _imLeftWindow:Image;
    private var _imRightWindow:Image;
    private var _imLeftTent:Image;
    private var _imRightTent:Image;
    private var _imLefttFlower:Image;
    private var _imRightFlower:Image;
    private var _imMenu:Image;
    private var _imBigTree:Image;
    private var _imRoad:Image;
    private var count:int = 0;
    private var _csprMenu:CSprite;
    private var _imFence1:Image;
    private var _imFence2:Image;
    private var _imFence3:Image;
    private var _imFence4:Image;
    private var _imFence5:Image;
    private var _imFence6:Image;
    private var _imFence7:Image;
    private var _imFlowerS1:Image;
    private var _imFlowerS2:Image;
    private var _imFlowerB1:Image;
    private var _imFlowerR1:Image;
    private var _imFlowerR2:Image;
    private var _imFlowerR3:Image;
    private var _imTable1:Image;
    private var _imTable2:Image;

    public function Cafe(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Cafe');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Cafe');
            return;
        }
        useIsometricOnly = false;
        _spriteSecond = new Sprite();
        _spriteThird = new Sprite();
        _spriteFirst = new Sprite();
        _csprMenu = new CSprite();
        _source.addChild(_spriteFirst);
        _source.addChild(_spriteSecond);
        _source.addChild(_spriteThird);
        if (!g.allData.atlas['cafeAtlas']) atlasLoad();
        _source.releaseContDrag = true;
        _dbBuildingId = _data.dbId;
        _isHover = false;
    }


    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['cafeAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'cafeAtlas.xml' + g.getVersion('cafeAtlas'), onLoad);
        }
    }

    private function createAtlases():void {
        g.allData.atlas['cafeAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'cafeAtlas.xml' + g.getVersion('cafeAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'cafeAtlas.xml' + g.getVersion('cafeAtlas')];
        createImage();
    }

    private function createImage():void {
        _imDoor = new Image(g.allData.atlas['cafeAtlas'].getTexture('door_stage_2_open'));
        _imDoorTent = new Image(g.allData.atlas['cafeAtlas'].getTexture('door_tent'));
        _imBaner = new Image(g.allData.atlas['cafeAtlas'].getTexture('banner'));
        _imLeftWindow = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_left_1'));
        _imRightWindow = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_right_1'));
        _imLeftTent = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_left_tent'));
        _imRightTent = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_right_tent'));
        _imLefttFlower = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_left_flowers'));
        _imRightFlower = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_right_flowers'));
        _imMenu = new Image(g.allData.atlas['cafeAtlas'].getTexture('stand_board'));
        _imBigTree = new Image(g.allData.atlas['cafeAtlas'].getTexture('caffee_tree'));
        _imRoad = new Image(g.allData.atlas['cafeAtlas'].getTexture('paving_road'));
        _imFence1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_1'));
        _imFence2 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_2'));
        _imFence3 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_3'));
        _imFence4 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_4'));
        _imFence5 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_5'));
        _imFence6 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_6'));
        _imFence7 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_7'));
        _imFlowerS1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_1'));
        _imFlowerS2 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_1'));
        _imFlowerB1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_2'));
        _imFlowerR1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'));
        _imFlowerR2 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'));
        _imFlowerR3 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'));
        _imTable1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'))
        _imLeftWindow.x = -90;
        _spriteFirst.addChild(_imLeftWindow);

        _imRightWindow.x = 140;
        _imRightWindow.y = 27;
        _spriteFirst.addChild(_imRightWindow);
        _spriteFirst.addChild(_imDoor);

        _imBigTree.y = -332;
        _imBigTree.x = -75;
        _spriteFirst.addChild(_imBigTree);

        _imLeftTent.x =- 80;
        _imLeftTent.y = 5;
        _spriteSecond.addChild(_imLeftTent);

        _imRightTent.x = 146;
        _imRightTent.y = 35;
        _spriteSecond.addChild(_imRightTent);

        _imDoorTent.y = 3;
        _imDoorTent.x = 10;
        _spriteSecond.addChild(_imDoorTent);

        _imLefttFlower.x = -85;
        _imLefttFlower.y = 72;
        _spriteSecond.addChild(_imLefttFlower);

        _imRightFlower.x = 150;
        _imRightFlower.y = 101;
        _spriteSecond.addChild(_imRightFlower);

        _imRoad.y = 132;
        _imRoad.x = -35;
        _source.addChildAt(_imRoad,0);

        _imBaner.x = -14;
        _imBaner.y = -150;
        _spriteSecond.addChild(_imBaner);

        _imFence1.x = -172;
        _imFence1.y = 88;
        _spriteFirst.addChild(_imFence1);

        _imFence2.x = -167;
        _imFence2.y = 124;
        _spriteThird.addChild(_imFence2);

        _imFence3.x = 47;
        _imFence3.y = 232;
        _spriteThird.addChild(_imFence3);

        _imFence4.x = 260;
        _imFence4.y = 254;
        _spriteThird.addChild(_imFence4);

        _imFence7.x = 285;
        _imFence7.y = 140;
        _spriteFirst.addChild(_imFence7);

        _imFlowerS1.x = -151;
        _imFlowerS1.y = 70;
        _spriteSecond.addChild(_imFlowerS1);

        _imFlowerS2.x = 158;
        _imFlowerS2.y = 224;
        _spriteSecond.addChild(_imFlowerS2);

        _imFlowerR1.x = 63;
        _imFlowerR1.y = 165;
        _spriteSecond.addChild(_imFlowerR1);

        _imFlowerR2.x = 240;
        _imFlowerR2.y = 255;
        _spriteSecond.addChild(_imFlowerR2);

        _imFlowerR3.x = 337;
        _imFlowerR3.y = 114;
        _spriteSecond.addChild(_imFlowerR3);

        _imFence6.x = 336;
        _imFence6.y = 188;
        _spriteSecond.addChild(_imFence6);

        _imFence5.x = 338;
        _imFence5.y = 212;
        _spriteSecond.addChild(_imFence5);

        _imFlowerB1.x = 379;
        _imFlowerB1.y = 179;
        _spriteSecond.addChild(_imFlowerB1);

        _csprMenu.x = -75;
        _csprMenu.y = 105;
        _spriteThird.addChild(_csprMenu);
        _csprMenu.addChild(_imMenu);
        _csprMenu.endClickCallback = onClickMenu;
        _csprMenu.hoverCallback = onHoverMenu;
        _csprMenu.outCallback = onOutMenu;

    }

    private function onClickMenu():void {
        _csprMenu.filter = null;
        _isHover = false;
        g.windowsManager.openWindow(WindowsManager.WO_AMBAR,null);
    }

    private function onHoverMenu():void {
        if (_isHover) return;
        _isHover = true;
        _csprMenu.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOutMenu():void {
        _isHover = false;
        _csprMenu.filter = null;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
//        if (_isHover) return;
//        super.onHover();
//        _isHover = true;
//        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
//        super.onOut();
//        _isHover = false;
//        g.hint.hideIt();
    }

    private function onClick():void {
//        var p0:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
//        p0.y -= 50;
//        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
//        new FlyMessage(p0,"Скоро будет!!!");
        if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_BUY_CAVE, null, _dataBuild, "Откройте поезд", 'house');

    }

}
}
