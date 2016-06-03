package utils {
import com.junkbyte.console.Cc;
import com.junkbyte.console.KeyBind;
import com.junkbyte.console.addons.htmlexport.ConsoleHtmlExportAddon;

import flash.display.Sprite;

import flash.ui.Keyboard;

import manager.Vars;

import starling.display.Stage;

public class ConsoleWrapper {
    protected static var g:Vars = Vars.getInstance();

    private static var _instance:ConsoleWrapper;

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
//        Cc.bindKey(new KeyBind(Keyboard.R, false, false, true, true), removeUserData);

        //Cc.addSlashCommand("export", exportLogToHTML, "Save game log.", true);
    }

    public function initTesterMode():void {
        Cc.info("Console:: tester mode ON");
        Cc.info("KeyBinds:\n" +
                "      0 - open/close console\n" +
                "      alt + L - save log\n" +
                "      alt + R - reset user Data\n" +
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

    private function exportLogToHTML():void {
        var time:String;
        var exporter:ConsoleHtmlExportAddon;

        Cc.info("Console:: export log to html.");
        time = String(Math.round(new Date().getTime() / 1000));
        exporter = new ConsoleHtmlExportAddon(Cc.instance);
        exporter.exportToFile("game_log_" + time + ".html");
    }
//
//    private function removeUserData():void {
//        if (g.currentUser.isTester) {
//            g.server.resetUser(onResetUser);
//        }
//    }

    private function onResetUser():void {
//        g.socialNetwork.reloadGame();
    }

    private function inspectObjects():void {
        Cc.inspect(g);
    }
}
}
class SingletonEnforcer {}