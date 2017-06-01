package utils {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import com.junkbyte.console.KeyBind;
import com.junkbyte.console.addons.htmlexport.ConsoleHtmlExportAddon;

import flash.display.Sprite;
import flash.geom.Point;
import flash.ui.Keyboard;

import flash.ui.Keyboard;

import manager.Vars;

import starling.display.Stage;

import temp.IsometricMouseCoordinates;

import windows.WindowsManager;

public class ConsoleWrapper {
    protected static var g:Vars = Vars.getInstance();

    private static var _instance:ConsoleWrapper;
    private var _isStats:Boolean = false;
    private var _xYPosition:IsometricMouseCoordinates;
    private var _xYPositionBool:Boolean;

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
        _xYPositionBool = false;
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
//        Cc.bindKey(new KeyBind(Keyboard.Q, true,false,true,true), g.managerLanguage.changeLanguage);
        Cc.bindKey(new KeyBind(Keyboard.X, true,false,true,true), showXY);
        Cc.bindKey(new KeyBind(Keyboard.M, true,false,true,true), scaleMoveMinus);
        Cc.bindKey(new KeyBind(Keyboard.P, true,false,true,true), scaleMovePlus);
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

    private function scaleMoveMinus():void {
        if (g.user.isTester) {
            g.managerResize.scaleMove();
        }
    }

    private function scaleMovePlus():void {
        if (g.user.isTester) {
            g.managerResize.scaleMove(true);
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
        Cc.info("Your isTester = " + g.user.isTester);
        g.testerPanel.updateText();
    }

    private function showXY():void {
        if (_xYPositionBool) {
            _xYPosition.stopIt();
            _xYPositionBool = false;
            g.cont.interfaceContMapEditor.removeChild(_xYPosition.source);
        } else {
            if (!_xYPosition) _xYPosition = new IsometricMouseCoordinates();
            _xYPosition.startIt();
            g.cont.interfaceContMapEditor.addChild(_xYPosition.source);
            _xYPositionBool = true;
        }
    }

    private function inspectObjects():void {
        Cc.inspect(g);
    }
}
}
class SingletonEnforcer {}