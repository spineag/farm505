/**
 * Created by andy on 2/10/17.
 */
package manager.ownError {
import analytic.AnalyticManager;
import com.junkbyte.console.Cc;
import manager.Vars;

public class OwnErrorManager {
    private var g:Vars = Vars.getInstance();

    public function OwnErrorManager() {
    }

    public function onGetError(type:int, sendAnalytics:Boolean = false, sendUser:Boolean = false):void {
        return;

        if (g.isDebug) return;
        Cc.info('OwnErrorManager onGetError:: type: ' + type);

        if (sendAnalytics) {
            if (g.analyticManager) g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_ERROR, {id: type});
        }
        if (sendUser) {
            if (g.directServer) g.directServer.addUserError();
        }
    }
}
}
