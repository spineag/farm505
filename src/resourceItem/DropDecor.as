/**
 * Created by andy on 6/20/17.
 */
package resourceItem {
import com.junkbyte.console.Cc;
import data.StructureDataBuilding;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class DropDecor {
    private var g:Vars = Vars.getInstance();
    private var _data:StructureDataBuilding;
    private var _count:int;
    private var _txtCount:CTextField;
    private var _source:Sprite;

    public function DropDecor(gX:int, gY:int, data:StructureDataBuilding, w:int, h:int, count:int=1) {
        _source = new Sprite();
        _count = count;
        _data = data;
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) texture = g.allData.atlas[_data.url].getTexture(_data.image);
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
            _txtCount.y = 10;
            _source.addChild(_txtCount);
        }
        _source.x = gX;
        _source.y = gY;
        g.cont.animationsResourceCont.addChild(_source);
        
        if (g.friendPanel.isShowed) {
            g.friendPanel.hideIt(false, .2);
            g.toolsPanel.showIt(.2, 0);
            g.toolsPanel.repositoryBox.showIt(.2, .2);
        } else if (g.toolsPanel.isShowed) {
            if (!g.toolsPanel.repositoryBox.isShowed) {
                g.toolsPanel.repositoryBox.showIt(.2);
            }
        }
    }
}
}
