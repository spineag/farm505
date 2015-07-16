/**
 * Created by user on 7/16/15.
 */
package manager {
public class DataPath {
    public const MAIN_PATH:String = 'farm505-spineag.c9.io/public/';

    public const CONTENT_PATH:String = 'content/';
    public const XML_DIRECT:String = 'xml/';

    public static const API_VERSION:String = "api-v1-0/";

    private var _data:Object;

    protected static var g:Vars = Vars.getInstance();

    public function DataPathGame():void {
//        _data = {};
//        _data["loader.swf"] = getMainPathSWF() + "game/loader.swf";
    }

    public function getMainPath():String {
        return g.useHttps ? 'https://' + MAIN_PATH : 'http://' + MAIN_PATH;
    }

    public function getVersion():String {
        return API_VERSION;
    }
}
}
