package kylin.echo.edward.utilities.loader
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	public class StreamDataItem extends LoadingItem
	{
		public var loader : URLStream;
		
		public function StreamDataItem(url:URLRequest, type:String, _uid:String)
		{
			super(url, type, _uid);
		}
		
		override public function load() : void{
			super.load();
			loader = new URLStream();
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			loader.addEventListener(Event.INIT, onInitHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);  
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			_content = loader;
			try{
				// TODO: test for security error thown.
				loader.load(url);
			}catch( e : SecurityError){
				onSecurityErrorHandler(_createErrorEvent(e));
			}
			
		};
		
		public function _onHttpStatusHandler(evt : HTTPStatusEvent) : void{
			_httpStatus = evt.status;
			dispatchEvent(evt);
		}
		
		public function onInitHandler(evt : Event) :void{
			dispatchEvent(evt);
		}
		
		override public function onCompleteHandler(evt : Event) : void {
			if(loader.connected)
				loader.close();
			super.onCompleteHandler(evt);	
		}
		
		override public function stop() : void{
			try{
				if(loader){
					loader.close();
				}
			}catch(e : Error){
				
			}
			super.stop();
		};

		override public function cleanListeners() : void {
			if (loader){
				var removalTarget : Object = loader;
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
			loader = null;
		}
	}
}