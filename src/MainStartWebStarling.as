/**
 * Created by ndy on 16.03.2014.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.UncaughtErrorEvent;
import flash.system.Security;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import manager.Containers;

import manager.Vars;

import preloader.StartPreloader;

import starling.core.Starling;
import starling.events.Event;

import utils.ConsoleWrapper;

[SWF (frameRate='30', backgroundColor='#000000', width = '1000', height = '640')]

public class MainStartWebStarling extends Sprite{
    private var star:Starling;
    private var stageReady:Boolean = false;
    private var stageReadyInterval:int;
    private var game:MainStarling;
    private var g:Vars = Vars.getInstance();

    public function MainStartWebStarling() {
        loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfo_uncaughtError);

        Security.allowDomain('*');
        Security.allowInsecureDomain("*");
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.addEventListener(flash.events.Event.RESIZE, onStageResize);

        setTimeout(function() : void { if (!stageReady) onStageResize(null);}, 1000);
    }

    private function onStageResize(e:flash.events.Event):void {
//        star.stage.stageWidth = stage.stageWidth;
//        star.stage.stageHeight = stage.stageHeight;
//
//        const viewPort:Rectangle = starling.viewPort;
//        viewPort.width = stage.stageWidth;
//        viewPort.height = stage.stageHeight;
//        starling.viewPort = viewPort;

        if (stageReadyInterval > 0) {
            clearTimeout(stageReadyInterval);
            stageReadyInterval = 0;
        }
        stageReadyInterval = setTimeout(startLoading, 500);

        function startLoading() : void {
            stage.removeEventListener(flash.events.Event.RESIZE, onStageResize);
            if (!stageReady) {
                star = new Starling(MainStarling, stage);
                star.showStats = false;
                g.mainStage = star.stage;
                g.starling = star;
                star.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
//                stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
            }
        }
    }

    private function onRootCreated(event:starling.events.Event):void {
        ConsoleWrapper.getInstance().init(g.mainStage, this as Sprite);

        game = star.root as MainStarling;
        game.addEventListener(MainStarling.LOADED, onLoaded);
        star.start();

        g.cont = new Containers();
        g.startPreloader = new StartPreloader();
        g.startPreloader.showIt();

        game.start();
    }

    private function onLoaded(event : starling.events.Event):void {
        game.removeEventListener(MainStarling.LOADED, onLoaded);
    }

//    private function onStageDeactivate(e:Event):void {
//        star.stop();
//        stage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate, false, 0, true);
//    }
//
//    private function onStageActivate(e:Event):void {
//        stage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
//        star.start();
//    }

    private function loaderInfo_uncaughtError(event:UncaughtErrorEvent) : void
    {
//        Cc.logch("Error", event.error, event.errorID, event);
//        Cc.logch("Error", (event.error as Error).getStackTrace());
    }

}
}
