/**
 * Created by user on 2/15/16.
 */
package utils {
public class Utils {
    public static function intArray(ar:Array):Array {
        for (var i:int=0; i<ar.length; i++) {
            ar[i] = int(ar[i]);
        }
        return ar;
    }
}
}
