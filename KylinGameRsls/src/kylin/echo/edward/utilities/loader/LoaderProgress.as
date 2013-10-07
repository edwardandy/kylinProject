package kylin.echo.edward.utilities.loader
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	/**
	 * 多个加载进度显示项
	 * @author Edward
	 * 
	 */	
	public class LoaderProgress implements ILoaderProgress
	{
		/**
		 * 加载项队列
		 */		
		private var _vecLoadingItems:Vector.<LoadingItem>;		

		private var _progressCB:Function;
		private var _completeCB:Function;
		
		public function LoaderProgress()
		{
			_vecLoadingItems = new Vector.<LoadingItem>;
		}
		/**
		 * @inheritDoc
		 */
		public function set completeCB(value:Function):void
		{
			_completeCB = value;
		}
		/**
		 * @inheritDoc
		 */
		public function set progressCB(value:Function):void
		{
			_progressCB = value;
		}
		/**
		 * @inheritDoc
		 */		
		internal function addItem(item:LoadingItem,listener:IAssetsLoaderListener):int
		{
			if(item && -1 == _vecLoadingItems.indexOf(item))
			{
				_vecLoadingItems.push(item);
				listener.addComplete(onItemComplete).addProgress(onItemProgress);
				//item.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				//item.addEventListener(Event.COMPLETE,onItemComplete);
			}
			return _vecLoadingItems.length;
		}
		/**
		 * 获得当前的加载进度 
		 * @return 加载进度
		 * 
		 */
		private function get loadProgress():Number
		{
			if(0 == _vecLoadingItems.length)
				return 0;
			
			var iByteLoaded:int = 0;
			var iByteTotle:int = 0;
			for each(var item:LoadingItem in _vecLoadingItems)
			{
				//iByteLoaded += item.bytesLoaded;
				iByteLoaded += item.weightPercentLoaded;
				iByteTotle += item.weight;
			}
			
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
		 * 清空队列中的加载项 
		 * 
		 */	
		private function dispose():void
		{
			_vecLoadingItems.length = 0;
			_completeCB = null;
			_progressCB = null;
		}
		
		private function onItemProgress():void
		{		
			if(null != _progressCB)
				_progressCB.apply(null,[loadProgress]);
		}
		
		private function onItemComplete():void
		{	
			var iLoaded:int;
			for each(var item:LoadingItem in _vecLoadingItems)
				if(item.isLoaded)
					++iLoaded;
			
			if(iLoaded == _vecLoadingItems.length)
			{
				if(null != _completeCB)
					_completeCB.apply();
				dispose();
			}
		}
	}
}