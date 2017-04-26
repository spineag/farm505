/**
 * Created by user on 10/21/16.
 */
package manager {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.geom.Point;
import flash.geom.Rectangle;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.ResizeEvent;

public class ManagerResize {
    private var g:Vars = Vars.getInstance();
    private var _stageWidth:int;
    private var _stageHeight:int;
    private const DEFAULT_WIDTH:int = 1000;
    private const DEFAULT_HEIGHT:int = 640;

    public function ManagerResize() {
        _stageWidth = DEFAULT_WIDTH;
        _stageHeight = DEFAULT_HEIGHT;
        g.mainStage.addEventListener(ResizeEvent.RESIZE, onStageResize);
    }
    
    public function checkResizeOnStart():void {
        onStageResize();
    }

    private function onStageResize(e:Event=null):void {
        recheckProperties();
        Cc.info('event onStageResize:: w: ' + _stageWidth + ', h: ' + _stageHeight);

        Starling.current.viewPort = new Rectangle(0, 0, _stageWidth, _stageHeight);
        g.mainStage.stageWidth = _stageWidth;
        g.mainStage.stageHeight = _stageHeight;

        try {
            if (g.cont) g.cont.onResize();
            if (g.bottomPanel) g.bottomPanel.onResize();
            if (g.bottomPanel) g.bottomPanel.onResizePanelFriend();
            if (g.craftPanel) g.craftPanel.onResize();
            if (g.friendPanel) g.friendPanel.onResize();
            if (g.toolsPanel) g.toolsPanel.onResize();
            if (g.xpPanel) g.xpPanel.onResize();
            if (g.catPanel) g.catPanel.onResize();
            if (g.partyPanel) g.partyPanel.onResize();
            if (g.achievementPanel) g.achievementPanel.onResize();
            if (g.windowsManager) g.windowsManager.onResize();
            if (g.optionPanel) g.optionPanel.onResize();
            if (g.stock) g.stock.onResize();
            if (g.salePanel) g.salePanel.onResize();
            if (g.managerTips) g.managerTips.onResize();
            if (g.managerTutorial && g.managerTutorial.isTutorial) g.managerTutorial.onResize();
            if (g.managerCutScenes && g.managerCutScenes.isCutScene) g.managerCutScenes.onResize();
            if (g.managerHelpers) g.managerHelpers.onResize();
            if (g.managerVisibleObjects) g.managerVisibleObjects.onResize();
            if (g.startPreloader) g.startPreloader.onResize();
        } catch (e:Error) {
            Cc.stackch('error', 'error at makeResizeForGame::', 10);
        }
    }

    public function get stageWidth():int { return _stageWidth; }
    public function get stageHeight():int { return _stageHeight; }
    
    public function recheckProperties():void {
        _stageWidth = Starling.current.nativeStage.stageWidth;
        _stageHeight = Starling.current.nativeStage.stageHeight;

    }

    public function scaleMove(minus:Boolean = false):void {
        var p:Point;
        var pNew:Point;
        var oldScale:Number;
        var arr:Array = [/*.5,*/ .62, .8, 1, 1.25, 1.55];
        var s:Number;
        var i:int = arr.indexOf(g.cont.gameCont.scaleX);
        if (!minus) {
            if (i == arr[0]) return;
            else s = arr[0];
        } else {
            if (i == arr[arr.length - 2]) return;
            else s = arr[arr.length - 2];
        }
        var cont:Sprite = g.cont.gameCont;
        oldScale = cont.scaleX;
        if (oldScale > s-.05 && oldScale < s+.05) return;
        p = new Point();
        p.x = g.managerResize.stageWidth/2;
        p.y = g.managerResize.stageHeight/2;
        p = cont.globalToLocal(p);
        cont.scaleX = cont.scaleY = s;
        p = cont.localToGlobal(p);
        pNew = new Point();
        pNew.x = cont.x - p.x + g.managerResize.stageWidth/2;
        pNew.y = cont.y - p.y + g.managerResize.stageHeight/2;
        var oY:Number = g.matrixGrid.offsetY*s;

        if (pNew.y > oY + g.cont.SHIFT_MAP_Y*s) pNew.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (pNew.y < oY - g.realGameHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s)
            pNew.y = oY - g.realGameHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (pNew.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            pNew.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (pNew.x < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - g.cont.SHIFT_MAP_X*s)
            pNew.x =  -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - g.cont.SHIFT_MAP_X*s;
        cont.scaleX = cont.scaleY = oldScale;
        g.currentGameScale = s;
        if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
        new TweenMax(cont, .9, {x: pNew.x, y: pNew.y, scaleX: s, scaleY: s, ease: Linear.easeOut, onComplete: function ():void {
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
        }});
    }
}
}
