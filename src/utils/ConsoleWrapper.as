package utils {
import com.junkbyte.console.Cc;
import com.junkbyte.console.KeyBind;
import com.junkbyte.console.addons.htmlexport.ConsoleHtmlExportAddon;

import flash.display.Sprite;
import flash.ui.Keyboard;

import flash.ui.Keyboard;

import manager.Vars;

import starling.display.Stage;

import windows.WindowsManager;

public class ConsoleWrapper {
    protected static var g:Vars = Vars.getInstance();

    private static var _instance:ConsoleWrapper;
    private var _isStats:Boolean = false;

    public static function getInstance():ConsoleWrapper {
        if (!_instance) {
            _instance = new ConsoleWrapper(new SingletonEnforcer());
        }
        return _instance;
    }

    public function ConsoleWrapper(se:SingletonEnforcer) {
        if (!se) {
            throw(new Error("use ConsoleWrapper.getInstance() instead!!"));
        }
    }

    public function init(stage:Stage, parrent:Sprite):void {
        Cc.config.style.backgroundColor = 0x1A1A1A;
        Cc.config.style.backgroundAlpha = 0.95;
        Cc.config.style.roundBorder = 0;
        Cc.config.maxLines = 2000;
        Cc.startOnStage(parrent, "505");
        Cc.config.commandLineAllowed = false;
        Cc.config.showTimestamp = true;
        Cc.config.showLineNumber = true;
        Cc.width = stage.stageWidth - 50;
        Cc.height = stage.stageHeight / 3;
        Cc.bindKey(new KeyBind(Keyboard.L, false, false, true, true), exportLogToHTML);
        Cc.bindKey(new KeyBind(Keyboard.R, true, false, true, true), deleteUser);
        Cc.bindKey(new KeyBind(Keyboard.F, true, false, true, true), makeFullscreen);
        Cc.bindKey(new KeyBind(Keyboard.I, true, false, true, true), showStats);
        Cc.bindKey(new KeyBind(Keyboard.T, true,false,true,true), makeTester);

        Cc.bindKey(new KeyBind(Keyboard.G, true, false, true, true), forOptimisation);
        Cc.bindKey(new KeyBind(Keyboard.H, true, false, true, true), forOptimisation2);
        Cc.bindKey(new KeyBind(Keyboard.J, true, false, true, true), forOptimisation3);
        Cc.bindKey(new KeyBind(Keyboard.K, true, false, true, true), forOptimisation4);
        Cc.bindKey(new KeyBind(Keyboard.M, true, false, true, true), forOptimisation5);
        Cc.bindKey(new KeyBind(Keyboard.N, true, false, true, true), forOptimisation6);
//        Cc.bindKey(new KeyBind(Keyboard.R, false, false, true, true), removeUserData);

        //Cc.addSlashCommand("export", exportLogToHTML, "Save game log.", true);
    }

    public function initTesterMode():void {
        Cc.info("Console:: tester mode ON");
        Cc.info("KeyBinds:\n" +
                "      0 - open/close console\n" +
                "      alt + L - save log\n" +
                "      alt + R - reset user Data\n" +
                "      alt + T - In - Out User Tester\n" +
                "      alt + F - set fullscreen\n" +
                "      /g - command for monitoring Objects class\n" +
                "");
        Cc.commandLine = true;
        Cc.config.keystrokePassword = "0";
        Cc.config.commandLineAllowed = true;
        Cc.bindKey(new KeyBind(Keyboard.L), exportLogToHTML);
//        Cc.bindKey(new KeyBind(Keyboard.T), turnOffTestMode);
//        Cc.bindKey(new KeyBind(Keyboard.R), removeUserData);
        Cc.addSlashCommand("g", inspectObjects, "Inspect Objects class", true);
//        Cc.addSlashCommand("sendErrorLog", sendErrorLog, "Manually sends error message");
    }

    private function showStats():void {
        _isStats = !_isStats;
        g.starling.showStats = _isStats;
    }

    private function exportLogToHTML():void {
        var time:String;
        var exporter:ConsoleHtmlExportAddon;

        Cc.info("Console:: export log to html.");
        time = String(Math.round(new Date().getTime() / 1000));
        exporter = new ConsoleHtmlExportAddon(Cc.instance);
        exporter.exportToFile("game_log_" + time + ".html");
    }

    private function deleteUser():void {
        if (g.user.isTester || g.isDebug) {
            var f2:Function = function ():void {
                if(g.windowsManager) g.windowsManager.openWindow(WindowsManager.WO_RELOAD_GAME);
            };
            g.directServer.deleteUser(f2);
        }
    }

    private function makeFullscreen():void {
        if (g.optionPanel) {
            g.optionPanel.makeFullScreen();
//            g.optionPanel.makeResizeForGame();
//            if (g.managerTutorial.isTutorial) g.managerTutorial.onResize();
        }
    }

    private function makeTester():void {
        if (g.user.isTester) g.user.isTester = false;
        else g.user.isTester = true;
        g.directServer.updateUserTester(null);
    }

    private function forOptimisation():void {                                       // G
        if (g.isDebug) g.cont.contentCont.visible = !g.cont.contentCont.visible;
        if (g.isDebug) g.cont.craftCont.visible = !g.cont.craftCont.visible;
    }

    private function forOptimisation2():void {                                      // H
        if (g.isDebug) g.cont.tailCont.visible = !g.cont.tailCont.visible;
    }

    private function forOptimisation3():void {                                      // J
        if (g.isDebug) g.cont.backgroundCont.visible = !g.cont.backgroundCont.visible;
    }

    private function forOptimisation4():void {                                      // K
        if (g.isDebug) g.cont.interfaceCont.visible = !g.cont.interfaceCont.visible;
    }

    private function forOptimisation5():void {                                      // M
        if (g.isDebug) g.cont.windowsCont.visible = !g.cont.windowsCont.visible;
    }

    private function forOptimisation6():void {                                      // N
        if (g.isDebug) g.cont.windowsCont.visible = !g.cont.windowsCont.visible;
    }

    private function inspectObjects():void {
        Cc.inspect(g);
    }
}
}
class SingletonEnforcer {}