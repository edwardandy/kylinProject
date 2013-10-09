package
{		
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
			
	/**
	 * 游戏外壳，用于加载主程序以及传递flash参数 
	 * @author Edward
	 * 
	 */
	[SWF(width="760",height="650",frameRate="30",backgroundColor="0xffffff")] 
	public class KylinGameShell extends Sprite
	{
		/**
		 * 主程序文件名 
		 */		
		private const wrapperUrl:String = "wrapper";
		/**
		 * 资源版本号 
		 */		
		private var _ver:String;
		/**
		 * 资源路径 
		 */		
		private var _cdnPath:String;
		/**
		 * 主程序加载进度显示 
		 */		
		private var _txtProgress:TextField;
		
		public function KylinGameShell()
		{
			_ver = this.loaderInfo.parameters.ver;
			_cdnPath = this.loaderInfo.parameters.url;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			initChild();
			init();
		}
		/**
		 * 初始化进度显示文本框 
		 * 
		 */		
		private function initChild():void
		{
			_txtProgress = new TextField;
			_txtProgress.mouseEnabled = false;
			_txtProgress.mouseWheelEnabled = false;
			_txtProgress.x = this.stage.stageWidth*0.5 - 70;
			_txtProgress.y = this.stage.stageHeight*0.5 - 11;
			_txtProgress.autoSize = TextFieldAutoSize.LEFT;
			_txtProgress.selectable = false;
			//_txtProgress.background = true;
			//_txtProgress.backgroundColor = 0xff0000;
			var format:TextFormat = new TextFormat;
			format.size = 20;
			_txtProgress.defaultTextFormat = format;
			
			_txtProgress.text = "loadpanel " + "0%";
			
			this.addChild(_txtProgress);
		}	
		
		private function init():void
		{
			loadWrapper();
		}
		
		private function genUrl(subPath:String,suffix:String):String
		{
			if(_cdnPath)
				subPath = _cdnPath + subPath;
			if(_ver && int(_ver)>0)
				subPath += "_"+_ver;
			subPath += suffix;
			return subPath;
		}
		/**
		 * 加载主程序 
		 * 
		 */		
		private function loadWrapper():void
		{
			var request:URLRequest = new URLRequest(genUrl(wrapperUrl,".swf"));
			var load:Loader = new Loader;
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadWrapperCmp);
			load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoadWrapperProgress);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			load.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			var context:LoaderContext = new LoaderContext(false,new ApplicationDomain(this.loaderInfo.applicationDomain));
			//var context:LoaderContext = new LoaderContext(false,new ApplicationDomain());//是否和上面等价
			context.parameters = this.loaderInfo.parameters;
			load.load(request,context);
		}
		
		private function onLoadWrapperCmp(e:Event):void
		{
			var loadInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			removeLoaderListener(loadInfo);
						
			this.stage.addChildAt(loadInfo.content,0);	
		}
		
		private function onModuleLoaderReady():void
		{
			this.stage.removeChild(this);
		}
		
		private function onLoadWrapperProgress(e:ProgressEvent):void
		{
			var progress:Number = e.bytesLoaded/e.bytesTotal;
			
			_txtProgress.text = "loadpanel " + int(progress*100) + "%";
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			removeLoaderListener(e.currentTarget as LoaderInfo);
			_txtProgress.text = "GameLoadIOError";
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			removeLoaderListener(e.currentTarget as LoaderInfo);
			_txtProgress.text = "GameLoadSecurityError";
		}
		
		private function removeLoaderListener(loadInfo:LoaderInfo):void
		{
			loadInfo.removeEventListener(Event.COMPLETE,onLoadWrapperCmp);
			loadInfo.removeEventListener(ProgressEvent.PROGRESS,onLoadWrapperProgress);
			loadInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loadInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
		}
		
	}
}