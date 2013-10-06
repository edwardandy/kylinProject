package kylin.echo.edward.utilities.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	/**
	 * 流方式加载图片，边加载边显示 
	 * @author Edward
	 * 
	 */		
	public class StreamImageItem extends LoadingItem
	{
		private var _loader : URLStream;
		
		private var _imageLoader:Loader;
		private var _imageData:ByteArray;
		private var _cacheEvt:Event;
		
		public function StreamImageItem(url:URLRequest, type:String, _uid:String)
		{
			super(url, type, _uid);
		}
		
		override public function load() : void{
			super.load();
			_imageData = new ByteArray;
			_imageLoader = new Loader;
			_loader = new URLStream();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			_loader.addEventListener(Event.INIT, onInitHandler, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			_loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);  
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler, false, 0, true);
			try{
				// TODO: test for security error thown.
				_loader.load(url);
			}catch( e : SecurityError){
				onSecurityErrorHandler(_createErrorEvent(e));
			}
			
		}
		
		override public function onProgressHandler(evt : *) : void {
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_bytesRemaining = _bytesTotal - bytesLoaded;
			_percentLoaded = _bytesLoaded / _bytesTotal;
			_weightPercentLoaded = _percentLoaded * weight;
			
			if(0 == _bytesLoaded)
				return;	
			_cacheEvt = evt;
			onStreamLoading();
		}
		
		override public function onCompleteHandler(evt : Event) : void {
			_cacheEvt = evt;
			
			_totalTime = getTimer();
			_timeToDownload = ((_totalTime - _responseTime) /1000);
			if(_timeToDownload == 0){
				_timeToDownload = 0.1;
			}
			_speed = BulkLoader.truncateNumber((bytesTotal / 1024) / (_timeToDownload));
			status = STATUS_FINISHED;
			_isLoaded = true;
			//dispatchEvent(evt);
			//evt.stopPropagation();
			
			onStreamLoading();
			
			if(_loader.connected)
				_loader.close();
			
			_imageLoader.contentLoaderInfo.removeEventListener(Event.INIT,onImageLoadCmp);
			_imageData.clear();
			_imageData = null;
			_imageLoader = null;
			_cacheEvt = null;
		}
		
		private function onStreamLoading():void
		{
			if(_loader.connected )
				_loader.readBytes(_imageData,_imageData.length);			
			_imageLoader.loadBytes(_imageData);
			if(!_imageLoader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoadCmp);
		}
		
		private function onImageLoadCmp(e:Event):void
		{
			_content ||= _imageLoader;
			if(_cacheEvt)
				dispatchEvent(_cacheEvt);
		}
		
		public function onInitHandler(evt : Event) :void{
			dispatchEvent(evt);
		}
		
		override public function stop() : void{
			try{
				if(_loader){
					_loader.close();
				}
			}catch(e : Error){
				
			}
			super.stop();
		};

		override public function cleanListeners() : void {
			if (_loader){
				var removalTarget : Object = _loader;
				removalTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
				removalTarget.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
				removalTarget.removeEventListener(Event.INIT, onInitHandler, false);
				removalTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
				removalTarget.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
				removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
			}
			
		}
		
		override public function destroy() : void{
			stop();
			cleanListeners();
			_content = null;
			_loader = null;
			if(_imageData)
				_imageData.clear();
			_imageData = null;
			_imageLoader = null;
			_cacheEvt = null;
		}
	}
}