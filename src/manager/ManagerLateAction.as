/**
 * Created by andy on 7/26/16.
 */
package manager {
import com.greensock.TweenMax;

public class ManagerLateAction {
    public function ManagerLateAction() {}

    public function releaseOnTimer(delay:Number, f:Function):void {
        TweenMax.delayedCall(delay, f);  // hz kak prervat' timer, potomy ispolzovat ostorojno(
    }

}
}
