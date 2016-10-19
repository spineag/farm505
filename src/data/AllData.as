/**
 * Created by user on 9/30/15.
 */
package data {
import manager.Vars;

public class AllData {
    public var lockedLandData:Object;
    public var atlas:Object;
    public var fonts:Object;
    public var bFonts:Object; // bitmap fonts
    public var factory:Object;  // StarlingFactory
    public var dataBuyMoney:Array;
    public var decorGroups:Object;
    private var g:Vars = Vars.getInstance();

    public function AllData() {
        atlas = {};
        fonts = {};
        bFonts = {};
        factory = {};
        dataBuyMoney = [];
        decorGroups = {};
    }

    public function addToDecorGroup(dataDecor:Object):void {
        if (!decorGroups[dataDecor.group]) decorGroups[dataDecor.group] = [];
        decorGroups[dataDecor.group].push(dataDecor);
    }

    public function sortDecorData():void {
        for(var id:String in decorGroups) {
            (decorGroups[id] as Array).sortOn('id', Array.NUMERIC);
        }
    }

    public function isFirstInGroupDecor(groupId:int, id:int):Boolean {
        if (!decorGroups[groupId] || !decorGroups[groupId].length) return true;
        if (decorGroups[groupId][0].id == id) return true;
        else return false;
    }

    public function getGroup(groupId:int):Array {
        if (!decorGroups[groupId] || !decorGroups[groupId].length) return [];
        var arr:Array = [];
        for (var i:int=0 ;i<decorGroups[groupId].length; i++) {
            if (decorGroups[groupId][i].visibleTester) {
                if (g.user.isMegaTester || g.user.isTester) arr.push(decorGroups[groupId][i]);
            } else arr.push(decorGroups[groupId][i]);
        }
        return arr;
    }
}
}
