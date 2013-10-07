package kylin.echo.edward.utilities.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;

	/**
	 * 跨域加载图片 
	 * @author Edward
	 * 
	 */	
	public class ExternalImageItem extends ImageItem
	{
		public function ExternalImageItem(url:URLRequest, type:String, uid:String)
		{
			super(url, type, uid);
		}
		
		override public function load() : void{
			super.load();		
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onExternalCompleteHandler, false, 0, true);
		}
		
		private function onExternalCompleteHandler(evt : Event) : void 
		{
			//跨域图片加载完成后，再使用字节方式加载一次即可访问新的Loader的content
			const cacheLoader:Loader = new Loader();
			cacheLoader.loadBytes(loader.contentLoaderInfo.bytes);
			cacheLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:*):void{
				cacheLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,arguments.callee);
				_content = Sprite(loader.content).getChildAt(0) as Bitmap;
				onBaseCompleteHandler(evt);
			});
		}
		
		private function onBaseCompleteHandler(evt:Event):void
		{
			_totalTime = getTimer();
			_timeToDownload = ((_totalTime - _responseTime) /1000);
			if(_timeToDownload == 0){
				_timeToDownload = 0.1;
			}
			_speed = BulkLoader.truncateNumber((bytesTotal / 1024) / (_timeToDownload));
			status = STATUS_FINISHED;
			_isLoaded = true;
			dispatchEvent(evt);
			evt.stopPropagation();
		}
	}
}