/**
 * Created by user on 1/26/16.
 */
package mouse {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.MCScaler;

public class ServerIconMouse {
    private var countConnectToServer:int;
    private var g:Vars = Vars.getInstance();
    private var clock:Sprite;
    private var arrowSmall:Image;
    private var arrowBig:Image;

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
        clock.x = g.ownMouse.mouseX + 15;
        clock.y = g.ownMouse.mouseY - 20;
    }

    private function addIcon():void {
        if (clock) return;
        clock = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        MCScaler.scale(im, 24, 24);
        im.x = -im.width/2;
        im.y = -im.height/2;
//        arrowSmall =
        g.cont.mouseCont.addChild(clock);
        clock.x = g.ownMouse.mouseX + 27;
        clock.y = g.ownMouse.mouseY - 32;
    }

    private function removeIcon():void {
        if (!clock) return;
        g.cont.mouseCont.removeChild(clock);
        clock.dispose();
        clock = null;
    }
}
}
