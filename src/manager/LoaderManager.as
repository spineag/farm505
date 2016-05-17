package manager {

import com.deadreckoned.assetmanager.AssetManager;
import com.deadreckoned.assetmanager.AssetQueue;
import com.junkbyte.console.Cc;

import dragonBones.factories.StarlingFactory;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.utils.ByteArray;


public class LoaderManager {
    private static const COUNT_PARALEL_LOADERS:int = 25;

    [ArrayElementType('com.deadreckoned.assetmanager.AssetQueue')]
    private var _loaders:Array;
    private var _loaderImages:AssetQueue;

    private var _loader:AssetManager = AssetManager.getInstance();
    private var _callbacks:Object;

    //если элемент пошел на загрузку, но еще не загрузился
    private var additionalQueue:Object = new Object();

    private static var _instance:LoaderManager;

    protected var g:Vars = Vars.getInstance();

    public static function getInstance():LoaderManager {
        if (!_instance) {
            _instance = new LoaderManager(new SingletonEnforcer());
        }
        return _instance;
    }

    public function LoaderManager(se:SingletonEnforcer) {
        if (!se) {
            Cc.error('Use LoaderManager.getInstance() instead!!');
        }

        _loaders = [];
        _callbacks = {};
        _loader.loadSequentially = true;
        _loaderImages = _loader.createQueue('loader');
        _loaderImages.loadSequentially = false;
        for (var i:int = 0; i < COUNT_PARALEL_LOADERS; i++) {
            _loaders.push(_loader.createQueue('loader' + String(i)));
        }
    }

    public function loadImage(url:String, callback:Function = null, ...callbackParams):void {
        if (url == '') return;

        Cc.ch('load', 'try to load image: ' + url);
        if (g.pBitmaps[url]) {
            setCallback(url, callback, callbackParams);
            getCallback(url);
            return;
        }

        if (!additionalQueue[url]) {
            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
        } else {
            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
        }

        _loaderImages.add(url, {type: AssetManager.TYPE_IMAGE, priority: 8, onComplete: loadedImage, onCompleteParams: [url, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
    }

    private function loadedImage(url:String, callback:Function, callbackParams:Array):void {
        var bitmapData:BitmapData;
        var image:Bitmap;
        bitmapData = _loader.get(url).asset;
        image = new Bitmap(bitmapData, 'auto', true);
        Cc.ch('load', 'on load image: ' + url);

        g.pBitmaps[url] = new PBitmap(image);
        if (callback != null) {
            if (image != null) {
                callback.apply(null, [g.pBitmaps[url].create() as Bitmap].concat(callbackParams));
            } else {
                Cc.error(url, 'load with some problem.')
            }
        }

        if (additionalQueue[url] && additionalQueue[url].length) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, [g.pBitmaps[url].create() as Bitmap].concat(additionalQueue[url][i].callbackParams))
                }
            }
        }

        if (additionalQueue[url]) additionalQueue[url] = null;
    }

    public function loadXML(url:String, callback:Function = null, ...callbackParams):void {
        if (url == '') return;

        Cc.ch('load', 'try to load xml: ' + url);
        if (g.pXMLs[url]) {
            setCallback(url, callback, callbackParams);
            getCallback(url);
            return;
        }

        if (!additionalQueue[url]) {
            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
        } else {
            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
        }

        _loaderImages.add(url, {type: AssetManager.TYPE_XML, priority: 8, onComplete: loadedXML, onCompleteParams: [url, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
    }

    private function loadedXML(url:String, callback:Function, callbackParams:Array):void {
        var xml:XML = XML(_loader.get(url).asset);
        Cc.ch('load', 'on load xml: ' + url);

        g.pXMLs[url] = xml;
        if (callback != null) {
            callback.apply(null, callbackParams);
        }

        if (additionalQueue[url] && additionalQueue[url].length) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, additionalQueue[url][i].callbackParams);
                }
            }
        }

        if (additionalQueue[url]) additionalQueue[url] = null;
    }

//    public function loadDB_PNG(url:String, name:String, callback:Function = null, ...callbackParams):void {
//        if (url == '') return;
//        Cc.ch('load', 'try to load DB_PNG: ' + url);
//        if (!additionalQueue[url]) {
//            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
//        } else {
//            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
//        }
//
//        _loaderImages.add(url, {type: AssetManager.TYPE_IMAGE, priority: 8, onComplete: loadedDB_PNG, onCompleteParams: [url, name, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
//    }
//
//    private function loadedDB_PNG(url:String, name:String, callback:Function, callbackParams:Array):void {
//        var ba:ByteArray = _loader.get(url).asset;
//        var factory:StarlingFactory = new StarlingFactory();
//        var f:Function = function (e:Event):void {
//            factory.removeEventListener(Event.COMPLETE, f);
//            g.allData.factory[name] = factory;
//            if (callback != null) {
//                callback.apply(null, callbackParams);
//            }
//            if (additionalQueue[url] && additionalQueue[url].length) {
//                for (var i:int = 0; i < additionalQueue[url].length; i++) {
//                    if (additionalQueue[url][i].callback != null) {
//                        additionalQueue[url][i].callback.apply(null, additionalQueue[url][i].callbackParams)
//                    }
//                }
//            }
//
//            if (additionalQueue[url]) additionalQueue[url] = null;
//        };
//        factory.addEventListener(Event.COMPLETE, f);
//        factory.parseData(ba);
//        Cc.ch('load', 'on load image: ' + url);
//    }

    private function errorHandler(url:String):void {
        Cc.error('LoaderManager:: error at ' + url);
    }

    private function setCallback(key:String, callback:Function, callbackParams:Array):void {
        if (callback != null) {
            if (_callbacks[key] == undefined) {
                _callbacks[key] = [{callback: callback, callbackParams: callbackParams}];
            } else {
                _callbacks[key].push({callback: callback, callbackParams: callbackParams});
            }
        }
    }

    private function getCallback(url:String):void {
        var callbackObject:Object;

        if (_callbacks[url] != undefined) {
            while (_callbacks[url] && _callbacks[url].length) {
                callbackObject = _callbacks[url].pop();
                if (callbackObject.callback != null) {
                    callbackObject.callback.apply(null, [g.pBitmaps[url].create() as Bitmap].concat(callbackObject.callbackParams));
                }
            }
            delete _callbacks[url];
        }
    }

    public function get loader():AssetManager {
        return _loader;
    }

}
}class SingletonEnforcer {}