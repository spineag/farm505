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
}
}
