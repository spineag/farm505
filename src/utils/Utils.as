/**
 * Created by user on 2/15/16.
 */
package utils {
import com.junkbyte.console.Cc;

import data.StructureDataAnimal;

import data.StructureDataBuilding;

import flash.events.TimerEvent;

import flash.utils.ByteArray;
import flash.utils.Timer;

public class Utils {
    public static function intArray(ar:Array):Array {
        for (var i:int=0; i<ar.length; i++) {
            ar[i] = int(ar[i]);
        }
        return ar;
    }

    public static function objectDeepCopy(reference:Object):Object {
        var clone:ByteArray = new ByteArray();
        clone.writeObject(reference);
        clone.position = 0;

        return clone.readObject();
    }

    public static function convert2to16(st:String):String {
        var i:int = st.length;
        if (i%4 == 3) {
            st += '0';
        } else if (i%4 == 2) {
            st += '00';
        } else if (i%4 == 1) {
            st += '000';
        }
        i = st.length/4;
        var ar:Array = [];
        for (var k:int = 0; k<i; k++) {
            ar.push(st.substr(4*k, 4));
        }
        st = '';
        for (k=0; k<i; k++) {
            switch (ar[k]) {
                case '0000': st+='0'; break;
                case '0001': st+='1'; break;
                case '0010': st+='2'; break;
                case '0011': st+='3'; break;
                case '0100': st+='4'; break;
                case '0101': st+='5'; break;
                case '0110': st+='6'; break;
                case '0111': st+='7'; break;
                case '1000': st+='8'; break;
                case '1001': st+='9'; break;
                case '1010': st+='A'; break;
                case '1011': st+='B'; break;
                case '1100': st+='C'; break;
                case '1101': st+='D'; break;
                case '1110': st+='E'; break;
                case '1111': st+='F'; break;
                default: Cc.error('Utils.convert2to16:: unknown at switch: ' + ar[k]);
            }
        }
        return st;
    }

    public static function convert16to2(st:String):String {
        var i:int = st.length;
        var st2:String = '';
        for (var k:int=0; k<i; k++) {
            switch (st.charAt(k)) {
                case '0': st2 += '0000'; break;
                case '1': st2 += '0001'; break;
                case '2': st2 += '0010'; break;
                case '3': st2 += '0011'; break;
                case '4': st2 += '0100'; break;
                case '5': st2 += '0101'; break;
                case '6': st2 += '0110'; break;
                case' 7': st2 += '0111'; break;
                case '8': st2 += '1000'; break;
                case '9': st2 += '1001'; break;
                case 'A': st2 += '1010'; break;
                case 'B': st2 += '1011'; break;
                case 'C': st2 += '1100'; break;
                case 'D': st2 += '1101'; break;
                case 'E': st2 += '1110'; break;
                case 'F': st2 += '1111'; break;
                default: Cc.error('Utils.convert16to2:: unknown at switch: ' + st.charAt(k));
            }
        }
        return st2;
    }

    public static function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }

    public static function objectFromStructureBuildToObject(oldOb:StructureDataBuilding):Object {
        var newOb:Object = {};
        var i:int = 0;
        if (oldOb.blockByLevel) {
            newOb.blockByLevel = [];
            for (i=0; i< oldOb.blockByLevel.length; i++) {
                newOb.blockByLevel.push(oldOb.blockByLevel[i]);
            }
        }
        if (oldOb.buildTime) {
            newOb.buildTime =[];
            for (i=0; i< oldOb.buildTime.length; i++) {
                newOb.buildTime.push(oldOb.buildTime[i]);
            }
        }
        if (oldOb.buildType) newOb.buildType = oldOb.buildType;
        if (oldOb.catNeed) newOb.catNeed = oldOb.catNeed;
        if (oldOb.color) newOb.color = oldOb.color;
        if (oldOb.cost) {
            newOb.cost = [];
            for (i=0; i< oldOb.cost.length; i++) {
                newOb.cost.push(oldOb.cost[i]);
            }
        }
        if (oldOb.currency) {
            newOb.currency = [];
            for (i=0; i< oldOb.currency.length; i++) {
                newOb.currency.push(oldOb.currency[i]);
            }
        }
        if (oldOb.deltaCost) newOb.deltaCost = oldOb.deltaCost;
        if (oldOb.filterType) newOb.filterType = oldOb.filterType;
        if (oldOb.group) newOb.group = oldOb.group;
        if (oldOb.height) newOb.height = oldOb.height;
        if (oldOb.id) newOb.id = oldOb.id;
        if (oldOb.image) newOb.image = oldOb.image;
        if (oldOb.innerX) newOb.innerX = oldOb.innerX;
        if (oldOb.innerY) newOb.innerY = oldOb.innerY;
        if (oldOb.maxAnimalsCount) newOb.maxAnimalsCount = oldOb.maxAnimalsCount;
        if (oldOb.name) newOb.name = oldOb.name;
        if (oldOb.priceSkipHard) newOb.priceSkipHard = oldOb.priceSkipHard;
        if (oldOb.startCountCell) newOb.startCountCell = oldOb.startCountCell;
        if (oldOb.url) newOb.url = oldOb.url;
        if (oldOb.visibleAction) newOb.visibleAction = oldOb.visibleAction;
        if (oldOb.visibleTester) newOb.visibleTester = oldOb.visibleTester;
        if (oldOb.width) newOb.width = oldOb.width;
        if (oldOb.xpForBuild) newOb.xpForBuild = oldOb.xpForBuild;
        if (oldOb.countUnblock) newOb.countUnblock = oldOb.countUnblock;
        if (oldOb.craftIdResource) newOb.craftIdResource = oldOb.craftIdResource;
        if (oldOb.countCraftResource) {
            newOb.countCraftResource = [];
            for (i=0; i< oldOb.countCraftResource.length; i++) {
                newOb.countCraftResource.push(oldOb.countCraftResource[i]);
            }
        }
        if (oldOb.removeByResourceId) newOb.removeByResourceId = oldOb.removeByResourceId;
        if (oldOb.startCountResources) newOb.startCountResources = oldOb.startCountResources;
        if (oldOb.deltaCountResources) newOb.deltaCountResources = oldOb.deltaCountResources;
        if (oldOb.startCountInstrumets) newOb.startCountInstrumets = oldOb.startCountInstrumets;
        if (oldOb.deltaCountAfterUpgrade) newOb.deltaCountAfterUpgrade = oldOb.deltaCountAfterUpgrade;
        if (oldOb.upInstrumentId1) newOb.upInstrumentId1 = oldOb.upInstrumentId1;
        if (oldOb.upInstrumentId2) newOb.upInstrumentId2 = oldOb.upInstrumentId2;
        if (oldOb.upInstrumentId3) newOb.upInstrumentId3 = oldOb.upInstrumentId3;
        if (oldOb.imageActive) newOb.imageActive = oldOb.imageActive;
        if (oldOb.idResource) {
            newOb.idResource = [];
            for (i=0; i< oldOb.idResource.length; i++) {
                newOb.idResource.push(oldOb.idResource[i]);
            }
        }
        if (oldOb.idResourceRaw) {
            newOb.idResourceRaw = [];
            for (i=0; i< oldOb.idResourceRaw.length; i++) {
                newOb.idResourceRaw.push(oldOb.idResourceRaw[i]);
            }
        }
        if (oldOb.variaty) {
            newOb.variaty = [];
            for (i=0; i< oldOb.variaty.length; i++) {
                newOb.variaty.push(oldOb.variaty[i]);
            }
        }
        return newOb;
    }

    public static function objectFromStructureAnimaToObject(oldOb:StructureDataAnimal):Object {
        var newOb:Object = {};
        newOb.id = oldOb.id;
        newOb.buildId = oldOb.buildId;
        newOb.name = oldOb.name;
        newOb.width = oldOb.width;
        newOb.height = oldOb.height;
        newOb.url = oldOb.url;
        newOb.image = oldOb.image;
        newOb.cost = oldOb.cost;
        newOb.cost2 = oldOb.cost2;
        newOb.cost3 = oldOb.cost3;
        newOb.idResource = oldOb.idResource;
        newOb.idResourceRaw = oldOb.idResourceRaw;
        newOb.buildType = oldOb.buildType;
        newOb.costNew = oldOb.costNew;
        return newOb;
    }
}
}
