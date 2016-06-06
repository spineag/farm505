package analytic.google {
import com.junkbyte.console.Cc;

import manager.Vars;

public class GAFarm {
    private static const ACCOUNT_VK:String = "UA-78805451-1";
    private var _isActive:Boolean = false;

    private var g:Vars = Vars.getInstance();

    public function GAFarm() {
        try {
//            if (!g.isDebug) _isActive = true;
            _isActive = true;
            Cc.ch("analytic", "<GAFarm> initialized on");
        } catch (error:Error) {
            Cc.error("<GAFarm> init error:" + error.message);
        }
    }

    public function sendActivity(category:String, action:String, obj:Object):void {
        try {
            if (_isActive) {
                checkGAsid(category, action, obj);
            } else {
                Cc.ch('analytic', "<GAFarm> is not ready to send event");
            }
        } catch (error:Error) {
            Cc.error("<GAFarm> send activity error: " + error.message);
        }
    }

    private function checkGAsid(category:String, action:String, obj:Object):void {
        if (g.user.userGAcid == 'unknown' || g.user.userGAcid == 'undefined') {
            var f:Function = function():void {
                event(category, action, obj);
            };
            g.socialNetwork.getUserGAsid(f);
        } else {
            event(category, action, obj);
        }
    }

    private function event(category:String, action:String, obj:Object):void {
        try {
//            _analytics.trackEvent(category, action, label, value);
//            _analytics.trackPageview(category + "/" + action + "/" + label);
            Cc.infoch("analytic", "<GAFarm> sending event => " + category + " + " + action);
        } catch (error:Error) {
            Cc.error("<GAFarm> send event error: " + error.message);
        }
    }
}
}
