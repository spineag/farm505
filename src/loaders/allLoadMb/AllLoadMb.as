/**
 * Created by user on 11/16/16.
 */
package loaders.allLoadMb {
import com.junkbyte.console.Cc;

import manager.Vars;

public class AllLoadMb {
    public var array:Array;
    private var g:Vars = Vars.getInstance();

    public function AllLoadMb() {
        array = [];
        Cc.addSlashCommand("showAllLoad", showAllLoad);
    }

    public function addAllMb():int {
        var n:int = 0;
        for (var i:int = 0; i < array.length; i++) {
            n += array[i];
        }
        return n;
    }

    private function showAllLoad():void {
        if (g.user.isTester || g.user.isMegaTester) {
            Cc.ch('info', 'Count object: ' + array.length, 1);
            var n:int = addAllMb() / 1048576;
            Cc.ch('info', 'Sum object: ' + n +'мб', 1);
        }
    }


}
}
