/**
 * Created by user on 2/29/16.
 */
package tutorial {
import com.junkbyte.console.Cc;

import manager.Vars;

public class ManagerTutorial {
    private static const TUTORIAL_ON:Boolean = false;

    private static const MAX_STEPS:uint = 100;
    private static var _instance:ManagerTutorial;
    private static var g:Vars = Vars.getInstance();

    public function ManagerTutorial(cl:Enforcer) {
    }

    public static function getInstance():ManagerTutorial {
        if (_instance == null) {
            _instance = new ManagerTutorial(new Enforcer());
        }
        return _instance;
    }

    public static function get isTutorial():Boolean {
        return g.user.tutorialStep < MAX_STEPS && TUTORIAL_ON;
    }

    private function updateTutorialStep():void {
        g.directServer.updateUserTutorialStep(null);
    }

    public static function initScenes():void {
        var curFunc:Function;

        try {
            switch (g.user.tutorialStep) {
                case 0:
                    if (TUTORIAL_ON) {
//                        curFunc = initScene50;
                    } else {
                        g.user.tutorialStep = 1;
                    }
                    break;
//                case 1:
//                    curFunc = initScene1;
//                    break;
//                case 2:
//                    curFunc = initScene2;
//                    break;
//                case 3:
//                    curFunc = initScene3;
//                    break;
//                case 4:
//                    curFunc = initScene4;
//                    break;
//                case 5:
//                    curFunc = initScene5;
//                    break;
//                case 6:
//                    curFunc = initScene6;
//                    break;
//                case 7:
//                    curFunc = initScene7;
//                    break;
//
//
//                case 50:
//                    curFunc = initScene0;
//                    break;
            }
            if (curFunc != null) {
                curFunc.apply();
            }
        } catch (err:Error) {
            Cc.error("Tutorial crashed at step #" + g.user.tutorialStep + " with error message #" + err.errorID);
        }
    }
}
}


class Enforcer {}