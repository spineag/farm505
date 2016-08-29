/**
 * Created by user on 8/22/16.
 */
package manager {
public class ManagerTimerSkip {
    private var g:Vars = Vars.getInstance();
    public function ManagerTimerSkip() {
    }

    public function newCount(timeAll:int, time:int, cost:int):int {
        if (300 >= time) {
            cost = 1;
            return cost;
        } else if (1200 >= time) {
            cost = 2;
            return cost;
        } else if (2700 >= time) {
            cost = 3;
            return cost;
        } else if (3600 >= time) {
            cost = 4;
            return cost;
        } else if (7200 >= time) {
            cost = 5;
            return cost;
        } else if (10800 >= time) {
            cost = 6;
            return cost;
        } else if (13200 >= time) {
            cost = 7;
            return cost;
        } else if (21600 >= time) {
            cost = 8;
            return cost;
        }
        var nTime:int = timeAll / 3 + .5;
        var nCount:int = cost/3 + .5;
        if (time > timeAll - nTime) {
            return cost;
        } else {
            return cost - nCount;
        }
    }
}
}
