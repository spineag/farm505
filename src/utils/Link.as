package utils {
import com.junkbyte.console.Cc;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class Link {

    public static function openURL(url:String, window:String = '_blank'):void {
        var urlRequest:URLRequest;

        if (url) {
            urlRequest = new URLRequest(url);
            Cc.info('Link: open url - \'' + window + '\': ' + url);
            navigateToURL(urlRequest, window);
        } else {
            Cc.warn('Link:: attempt to open a null reference');
        }
    }
}
}