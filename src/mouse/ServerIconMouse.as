/**
 * Created by user on 1/26/16.
 */
package mouse {
import manager.Vars;

import starling.display.Image;
import utils.MCScaler;

public class ServerIconMouse {
    private var countConnectToServer:int;
    private var g:Vars = Vars.getInstance();
    private var im:Image;

    public function ServerIconMouse() {
        countConnectToServer = 0;
    }

    public function startConnect():void {
        if (g.isGameLoaded) {
            countConnectToServer++;
            if (countConnectToServer == 1) {
                addIcon();
                g.gameDispatcher.addEnterFrame(onEnterframe);
            }
        }
    }

    public function endConnect():void {
        if (g.isGameLoaded) {
            countConnectToServer--;
            if (countConnectToServer <= 0) {
                removeIcon();
                g.gameDispatcher.removeEnterFrame(onEnterframe);
            }
        }
    }

    private function onEnterframe():void {
        im.x = g.ownMouse.mouseX + 15;
        im.y = g.ownMouse.mouseY - 20;
    }

    private function addIcon():void {
        if (im) removeIcon();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        MCScaler.scale(im, 24, 24);
        g.cont.mouseCont.addChild(im);
        im.x = g.ownMouse.mouseX + 15;
        im.y = g.ownMouse.mouseY - 20;
    }

    private function removeIcon():void {
        if (!im) return;
        g.cont.mouseCont.removeChild(im);
        im.dispose();
        im = null;
    }
}
}
