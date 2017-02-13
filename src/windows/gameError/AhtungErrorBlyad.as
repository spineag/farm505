/**
 * Created by user on 9/22/16.
 */
package windows.gameError {
import flash.display.StageDisplayState;
import flash.geom.Rectangle;

import manager.Vars;
import manager.ownError.ErrorConst;

import starling.core.Starling;
import starling.display.Quad;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Color;

import utils.CButton;

public class AhtungErrorBlyad {
    private var g:Vars = Vars.getInstance();

    public function AhtungErrorBlyad(e:Error) {
        g.errorManager.onGetError(ErrorConst.STARLING_GRAPHIC_CRASH, true, true);
        if (Starling.current.nativeStage.displayState == StageDisplayState.FULL_SCREEN) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
        g.cont.popupCont.addChild(q);
        q.alpha = .9;
        var txt:TextField = new TextField(500, 200, 'Критическая ошибка. Перезагрузите игру');
        var format:TextFormat = new TextFormat();
        format.size = 36;
        format.color = Color.WHITE;
        txt.format = format;
        txt.x = g.managerResize.stageWidth/2 - 250;
        txt.y = g.managerResize.stageHeight/2 - 100;
        g.cont.popupCont.addChild(txt);

        var _b:CButton = new CButton();
//        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        q = new Quad(210, 34, Color.BLUE);
        q.x = -105;
        q.y = -17;
        _b.addChild(q);
        _b.x = g.managerResize.stageWidth/2;
        _b.y = g.managerResize.stageHeight/2 + 100;
        txt = new TextField(210, 34, "Перезагрузить");
        format = new TextFormat();
        format.size = 24;
        format.color = Color.WHITE;
        txt.format = format;
        txt.x = -105;
        txt.y = -17;
        _b.addChild(txt);
        _b.clickCallback = onClick;
        g.cont.popupCont.addChild(_b);
    }

    private function onClick():void {
        g.socialNetwork.reloadGame();
    }
}
}
