/**
 * Created by user on 2/15/16.
 */
package utils {
import com.junkbyte.console.Cc;

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
}
}
