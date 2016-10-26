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

    public function ManagerResize() {
        _stageWidth = 1000;
        _stageHeight = 640;
        g.mainStage.addEventListener(ResizeEvent.RESIZE, onStageResize);
    }

    private function onStageResize(e:Event):void {
        Cc.info('event onStageResize');
        _stageWidth = Starling.current.nativeStage.stageWidth;
        _stageHeight = Starling.current.nativeStage.stageHeight;

        Starling.current.viewPort = new Rectangle(0, 0, _stageWidth, _stageHeight);
        g.mainStage.stageWidth = _stageWidth;
        g.mainStage.stageHeight = _stageHeight;

        try {
            g.cont.onResize();
            g.bottomPanel.onResize();
            g.bottomPanel.onResizePanelFriend();
            g.craftPanel.onResize();
            g.friendPanel.onResize();
            g.toolsPanel.onResize();
            g.xpPanel.onResize();
            g.catPanel.onResize();
            g.windowsManager.onResize();
            g.optionPanel.onResize();
            g.stock.onResize();
            if (g.managerTips) g.managerTips.onResize();
            if (g.managerTutorial.isTutorial) g.managerTutorial.onResize();
            if (g.managerCutScenes.isCutScene) g.managerCutScenes.onResize();
            if (g.managerHelpers) g.managerHelpers.onResize();
            if (g.managerVisibleObjects) g.managerVisibleObjects.onResize();
        } catch (e:Error) {
            Cc.stackch('error', 'error at makeResizeForGame::', 10);
        }
    }

    public function get stageWidth():int { return _stageWidth; }
    public function get stageHeight():int { return _stageHeight; }
}
}
