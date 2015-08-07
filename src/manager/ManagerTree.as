/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.tree.Tree;

import com.junkbyte.console.Cc;

public class ManagerTree {
    private var arrTree:Array; // список всех деревьев юзера

    private var g:Vars = Vars.getInstance();

    public function ManagerTree() {
        var arr:Array = g.townArea.cityObjects;
        arrTree = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Tree) {
                arrTree.push(arr[i]);
            }
        }
    }

    public function addTree(ob:Object):void {
        var curTree:Tree;
        var i:int;
        for (i=0; i<arrTree.length; i++) {
            if (arrTree[i].dbBuildingId == int(ob.user_db_building_id)) {
                curTree = arrTree[i];
                break;
            }
        }
        if (!curTree) {
            Cc.error('no such Tree with dbId: ' + ob.user_db_building_id);
            return;
        }
        curTree.releaseTreeFromServer(ob);
    }

    public function updateTreeState(treeDbId:String, state:int):void {
        g.directServer.updateUserTreeState(treeDbId, state, null);
    }

    public function onCraft(plantIdFromServer:String):void {
        //g.directServer.craftPlantRidge(plantIdFromServer, null);
    }
}
}
