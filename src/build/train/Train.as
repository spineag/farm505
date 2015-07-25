package build.train {
import build.AreaObject;

import com.junkbyte.console.Cc;

import data.BuildType;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Train extends AreaObject{
    private var list:Array;

    public function Train(_data:Object) {
        super(_data);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;

        fillList();
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");

    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            g.woTrain.showItWithParams(list, this);
            onOut();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

    private function fillList():void {
        var i:int;
        var k:int;
        var n:int;
        var arr:Array = [];
        var obj:Object = g.dataResource.objectResources;
        for(var s:String in obj) {
            if (obj[s].buildType == BuildType.RESOURCE || obj[s].buildType == BuildType.PLANT)
                arr.push(obj[s]);
        }

        if (_dataBuild.blockByLevel[3] <= g.user.level) {
            k = 3;
        } else if (_dataBuild.blockByLevel[2] <= g.user.level) {
            k = 2;
        } else {
            k = 1;
        }

        list = [];
        for (i=0; i<3; i++) {
            obj = arr[int(Math.random()*arr.length)];
            for (n=0; n<k; n++) {
                list.push(new TrainCell(obj, int(Math.random()*5) + 2));
            }
        }
    }

    public function fullTrain():void {
        fillList();
        g.woTrain.showItWithParams(list, this);
        onOut();
    }

}
}
