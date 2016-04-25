/**
 * Created by user on 1/26/16.
 */
package mouse {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

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
                g.gameDispatcher.removeEnterFrame(onEnterframe);
                removeIcon();
            }
        }
    }

    private function onEnterframe():void {
        clock.x = g.ownMouse.mouseX + 27;
        clock.y = g.ownMouse.mouseY + 32;
    }

    private function addIcon():void {
        if (clock) return;
        clock = new Sprite();
        clock.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock_1'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        clock.addChild(im);
        arrowSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock_2'));
        arrowSmall.pivotY = arrowSmall.height/2;
        arrowBig = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock_3'));
        arrowBig.pivotX = arrowBig.width/2;
        arrowBig.pivotY = arrowBig.height;
        clock.addChild(arrowSmall);
        clock.addChild(arrowBig);
        g.cont.mouseCont.addChild(clock);
        clock.x = g.ownMouse.mouseX + 27;
        clock.y = g.ownMouse.mouseY + 32;
        animateBig();
        animateSmall();
    }

    private function animateBig():void {
        TweenMax.to(arrowBig, 3, {rotation: 6.28, repeat: 50, ease:Linear.easeNone});
    }

    private function animateSmall():void {
        TweenMax.to(arrowSmall, 1, {rotation: 6.28, repeat: 50, ease:Linear.easeNone});
    }

    private function removeIcon():void {
        TweenMax.killTweensOf(arrowBig);
        TweenMax.killTweensOf(arrowSmall);
        if (!clock) return;
        g.cont.mouseCont.removeChild(clock);
        clock.dispose();
        clock = null;
        arrowBig = null;
        arrowSmall = null;
    }
}
}
