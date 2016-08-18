/**
 * Created by user on 9/30/15.
 */
package data {
public class AllData {
    public var lockedLandData:Object;
    public var atlas:Object;
    public var bFonts:Object; // bitmap fonts
    public var factory:Object;  // StarlingFactory
    public var dataBuyMoney:Array;

    public function AllData() {
        atlas = {};
        bFonts = {};
        factory = {};
        dataBuyMoney = [];
    }
}
}
