/**
 * Created by user on 7/16/15.
 */
package loaders {
import manager.*;

public class DataPath {
    public const MAIN_PATH:String = '505.ninja/';
    public const MAIN_PATH_GRAPHICS:String = '505.ninja/content/';

    public static const API_VERSION:String = "api-v1-0/";

    protected static var g:Vars = Vars.getInstance();

    public function getMainPath():String {
        return g.useHttps ? 'https://' + MAIN_PATH : 'http://' + MAIN_PATH;
    }

    public function getGraphicsPath():String {
        return g.useHttps ? 'https://' + MAIN_PATH_GRAPHICS : 'http://' + MAIN_PATH_GRAPHICS;
    }

   public function getQuestIconPath():String {
        return getGraphicsPath() + 'quest_icon/';
    }

    public function getVersion():String {
        return 'php/' + API_VERSION;
    }

}
}
