package kylin.echo.edward.utilities.loader
{
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;

	/**
	 * 外部图片加载项 ,解决跨域加载图片显示问题
	 * @author Edward
	 * 
	 */	
	public class ExternalImageItem extends ImageItem
	{
		private var _extImage:Bitmap;
		
		public function ExternalImageItem(url:URLRequest, type:String, uid:String)
		{
			super(url, type, uid);
		}

		/**
		 * 解决跨域限制的图片内容
		 */
		public function get extImage():Bitmap
		{
			return _extImage;
		}

		/**
		 * @private
		 */
		public function set extImage(value:Bitmap):void
		{
			_extImage = value;
		}

	}
}