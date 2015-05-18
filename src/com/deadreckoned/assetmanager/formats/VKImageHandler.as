/**
 * Created with IntelliJ IDEA.
 * User: vladimir.shafran
 * Date: 12/9/13
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */
package com.deadreckoned.assetmanager.formats {

import flash.net.URLRequest;
import flash.system.LoaderContext;

public class VKImageHandler extends ImageHandler{
    public function VKImageHandler() {
    }

    override public function get id():String { return 'vkimg'; }

    override public function load(uri:String, context:* = null):void {
        _loaded = false;

        _uri = uri;
        _loader.load(new URLRequest(uri));
    }

    public override function dispose():void
    {
        super.dispose();
        if (_loader != null)
        {
            _loader = null;
        }
    }

    public override function getContent():*
    {
        if (!loaded) return null;
        if (_loader != null) {
            return _loader;
        }
    }
}
}
