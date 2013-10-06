package kylin.echo.edward.utilities.loader.interfaces
{		
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="complete",type="flash.events.Event")]
	/**
	 * 多个加载进度显示项
	 * @author Edward
	 * 
	 */	
	public interface ILoaderProgress
	{
		/**
		 * 加载完成回调函数 
		 */
		function set completeCB(value:Function):void;
		/**
		 * 加载进度回调函数 func(percent:Number):void
		 */
		function set progressCB(value:Function):void;
		/**
		 * 添加加载项到队列 
		 * @param item 资源加载项
		 * 
		 */		
		function addItem(item:LoadingItem):int;
		/**
		 * 获得当前的加载进度 
		 * @return 加载进度
		 * 
		 */		
		//function get loadProgress():Number;
		/**
		 * 队列中是否有加载项 
		 * @return 
		 * 
		 */		
		function get hasItem():Boolean;
		/**
		 * 清空队列中的加载项 
		 * 
		 */		
		//function dispose():void;
	}
}