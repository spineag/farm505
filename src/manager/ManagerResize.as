/**
 * Created by user on 10/21/16.
 */
package manager {
import com.junkbyte.console.Cc;
import flash.geom.Rectangle;
import starling.core.Starling;
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
        Cc.info('event onStageResize');
        rechekProp();

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
            if (g.windowsManager) g.windowsManager.onResize();
            if (g.optionPanel) g.optionPanel.onResize();
            if (g.stock) g.stock.onResize();
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
    
    public function rechekProp():void {
        _stageWidth = Starling.current.nativeStage.stageWidth;
        _stageHeight = Starling.current.nativeStage.stageHeight;

    }
}
}
