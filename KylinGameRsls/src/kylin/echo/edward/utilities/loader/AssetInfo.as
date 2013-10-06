package kylin.echo.edward.utilities.loader
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * 素材内容缓存信息，包括回调函数 
	 * @author Edward
	 * 
	 */	
	public class AssetInfo
	{
		/**
		 * 加载的内容 
		 */		
		public var content:*      				= null;	
		/**
		 * 加载完成的回调函数 
		 */		
		internal var onCompletes:Array	   		= [];
		/**
		 * 加载完成回调函数的参数，数组的数组 
		 */		
		internal var onCompleteParams:Array		= [];
		/**
		 *  加载进度的回调函数 
		 */		
		internal var onUpdates:Array       		= [];
		/**
		 *  加载进度回调函数的参数，数组的数组 
		 */		
		internal var onUpdateParams:Array       = [];
		/**
		 * 加载出错回调函数 
		 */		
		internal var onErrors:Array				= [];
		/**
		 *  加载出错回调函数的参数，数组的数组 
		 */		
		internal var onErrorParams:Array       = [];
		
		public function AssetInfo()
		{
			super();
		}
		/**
		 * 获得类定义 
		 * @param clsName 类名
		 * @return 
		 * 
		 */		
		public function getClass(clsName:String):Class
		{
			if(content && content is DisplayObject)
			{				
				if(content.loaderInfo.applicationDomain.hasDefinition(clsName))
					return content.loaderInfo.applicationDomain.getDefinition(clsName) as Class;				
			}
			return null;
		}
		/**
		 * 获得一份位图拷贝 
		 * @return 
		 * 
		 */		
		public function getBitmap():Bitmap
		{
			if(content && content is Bitmap)
				return new Bitmap(Bitmap(content).bitmapData);
			return null;
		}
		/**
		 * 获得xml内容 
		 * @return 
		 * 
		 */		
		public function getXML():XML
		{
			return XML(content);
		}
		/**
		 * 获得一份影片剪辑实例 
		 * @param clsName 影片剪辑类名
		 * @return 
		 * 
		 */		
		public function getMovieClip(clsName:String):MovieClip
		{
			var cls:Class = getClass(clsName);
			if(cls)
				return new cls();
			return null;
		}		
		
		internal function clearCallbacks():void
		{
			onCompletes	   		= [];
			onCompleteParams	= [];
			onUpdates	    	= [];
			onUpdateParams	    = [];
			onErrors			= [];
			onErrorParams		= [];
		}
	}
}