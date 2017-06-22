/**
 * Created by andy on 6/20/17.
 */
package resourceItem {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.StructureDataBuilding;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import ui.toolsPanel.RepositoryItem;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class DropDecor {
    private var g:Vars = Vars.getInstance();
    private var _data:StructureDataBuilding;
    private var _count:int;
    private var _txtCount:CTextField;
    private var _source:Sprite;

    public function DropDecor(globalX:int, globalY:int, data:StructureDataBuilding, w:int, h:int, count:int=1, delay:Number = 0) {
        _source = new Sprite();
        _count = count;
        _data = data;
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture && g.allData.atlas[_data.url]) texture = g.allData.atlas[_data.url].getTexture(_data.image);
            if (!texture) texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            if (!texture) {
                Cc.error('DropDecor:: no such texture: ' + _data.url + ' for _data.id ' + _data.id);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropDecor');
                return;
            }
            var im:Image = new Image(texture);
            MCScaler.scale(im, w, h);
            im.alignPivot();
            _source.addChild(im);
        } else {
            Cc.error('DropDecor:: no image for decor with id: ' + _data.id);
        }
        if (_count > 1) {
            _txtCount =  new CTextField(50,50,'');
            _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
            _txtCount.x = w/2 - 20;
            _txtCount.y = h/2 - 25;
            _source.addChild(_txtCount);
        }
        _source.x = globalX;
        _source.y = globalY;
        g.cont.animationsResourceCont.addChild(_source);
        
        if (g.friendPanel.isShowed) {
            g.friendPanel.hideIt(false, .2);
            g.bottomPanel.cancelBoolean(true);
            g.toolsPanel.showIt(.2, 0);
            g.toolsPanel.repositoryBox.showIt(.2, .2);
        } else if (g.toolsPanel.isShowed) {
            if (!g.toolsPanel.repositoryBox.isShowed) {
                g.toolsPanel.repositoryBox.showIt(.2);
            }
        }

        var obj:Object = g.toolsPanel.repositoryBox.moveToItemWithID(_data.id);
        var arrDBids:Array = [];
        var f1:Function = function (dbId:int):void {
            arrDBids.push(dbId);
            if (arrDBids.length == _count) {
                for (var k:int=0; k<_count; k++) {
                    g.userInventory.addToDecorInventory(_data.id, arrDBids[k], false);
                }
                g.cont.animationsResourceCont.removeChild(_source);
                g.updateRepository();
            }
        };

        var f:Function = function ():void {
            g.lastActiveDecorID = _data.id;
            for (var i:int=0; i<_count; i++) {
                g.directServer.buyAndAddToInventory(_data.id, f1);
            }
        };

        var tempX:int = globalX - 140 + int(Math.random()*140);
        var tempY:int = globalY - 40 - int(Math.random()*100);
        var dist:int = int(Math.sqrt((globalX - tempX)*(globalX - tempX) + (globalY - tempY)*(globalY - tempY)));
        dist += int(Math.sqrt((tempX - obj.point.x)*(tempX - obj.point.x) + (tempY - obj.point.y)*(tempY - obj.point.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        var scale:Number = _source.scaleX/1.1;
        new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:obj.point.x, y:obj.point.y}], scaleX:scale, scaleY:scale, delay:delay, ease:Linear.easeOut ,onComplete: f});
    }
}
}
