/**
 * Created by user on 2/15/16.
 */
package utils {
import flash.utils.ByteArray;

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
            }
        }
        return st;
    }

    public static function convert16to2(st:String):String {

    }
}
}
