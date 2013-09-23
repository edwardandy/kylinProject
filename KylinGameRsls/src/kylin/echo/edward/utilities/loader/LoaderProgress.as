package kylin.echo.edward.utilities.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="complete",type="flash.events.Event")]
	/**
	 * 加载进度显示项
	 * @author Edward
	 * 
	 */	
	public class LoaderProgress extends EventDispatcher implements ILoaderProgress
	{
		//加载项队列
		private var _vecLoadingItems:Vector.<LoadingItem>;
		//进度事件
		private var _evtProgress:ProgressEvent;
		
		public function LoaderProgress()
		{
			_vecLoadingItems = new Vector.<LoadingItem>;
		}
		/**
		 * @inheritDoc
		 */		
		public function addItem(item:LoadingItem):int
		{
			if(-1 == _vecLoadingItems.indexOf(item))
			{
				_vecLoadingItems.push(item);
				item.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				item.addEventListener(Event.COMPLETE,onItemComplete);
			}
			return _vecLoadingItems.length;
		}
		/**
		 * @inheritDoc
		 */
		public function get loadProgress():Number
		{
			if(0 == _vecLoadingItems.length)
				return 0;
			//var fProgress:Number = 0;
			var iByteLoaded:int = 0;
			var iByteTotle:int = 0;
			//var iLoaded:int = 0;
			for each(var item:LoadingItem in _vecLoadingItems)
			{
				iByteLoaded += item.bytesLoaded;
				iByteTotle += item.weight;
				/*if(item.isLoaded)
				{
					++iLoaded;
					fProgress += 1/_vecLoadingItems.length;
				}
				else if(item._isLoading)
				{
					fProgress += item.bytesLoaded/item.bytesTotal/_vecLoadingItems.length;
				}*/
			}
			
			//if(iLoaded == _vecLoadingItems.length)
			if(iByteLoaded == iByteTotle)
				return 1;
	
			return iByteLoaded/iByteTotle;
		}
		/**
		 * @inheritDoc
		 */
		public function get hasItem():Boolean
		{
			return _vecLoadingItems.length>0;
		}
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_vecLoadingItems.length = 0;
		}
		
		private function onItemProgress(e:ProgressEvent):void
		{
			_evtProgress ||= new ProgressEvent(ProgressEvent.PROGRESS);
			_evtProgress.bytesLoaded = loadProgress;
			_evtProgress.bytesTotal = 1;
			
			dispatchEvent(_evtProgress);
		}
		
		private function onItemComplete(e:Event):void
		{
			(e.currentTarget as EventDispatcher).removeEventListener(Event.COMPLETE,onItemComplete);
			(e.currentTarget as EventDispatcher).removeEventListener(ProgressEvent.PROGRESS,onItemProgress);
			
			var iLoaded:int;
			for each(var item:LoadingItem in _vecLoadingItems)
			{
				if(item.isLoaded)
				{
					++iLoaded;
				}
			}
			
			if(iLoaded == _vecLoadingItems.length)
				dispatchEvent(e.clone());
		}
	}
}