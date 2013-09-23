package kylin.echo.edward.framwork.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	import kylin.echo.edward.framwork.view.interfaces.IKylinBasePanel;
	import kylin.echo.edward.utilities.display.DisplayObjectUtils;
	
	public class KylinBasePanel extends Sprite implements IKylinBasePanel
	{
		private var _resDomain:ApplicationDomain;
		private var _panelId:String;
		private var _content:MovieClip;
		
		public function KylinBasePanel()
		{
			super();
		}
			
		/**
		 * 显示内容 
		 */
		public function get content():MovieClip
		{
			return _content;
		}

		public function get panelId():String
		{
			return _panelId;
		}

		public function set panelId(value:String):void
		{
			_panelId = value;
		}

		public function set resDomain(value:ApplicationDomain):void
		{
			_resDomain = value;
		}

		public function appear(param:Object = null):void
		{
			onShowStart(param);
		}	
		/**
		 * 面板开始显示 
		 * @param param
		 * 
		 */		
		protected function onShowStart(param:Object = null):void
		{
			
		}
		
		public function disappear(param:Object = null):void
		{
			onCloseStart(param);
		}	
		/**
		 * 面板开始关闭
		 * @param param
		 * 
		 */		
		protected function onCloseStart(param:Object = null):void
		{
			
		}
		
		public function afterAppear(param:Object = null):void
		{
			onShowEnd(param);
		}	
		/**
		 * 面板完成显示 
		 * @param param
		 * 
		 */		
		protected function onShowEnd(param:Object = null):void
		{
			
		}
		
		public function afterDisappear(param:Object = null):void
		{
			onCloseEnd(param);
		}
		/**
		 * 面板完成关闭
		 * @param param
		 * 
		 */		
		protected function onCloseEnd(param:Object = null):void
		{
			
		}
		
		/**
		 * 面板加到舞台上时初始化 
		 * 
		 */		
		public function firstInit():void
		{
			initPropreties();
			initContent();
			onFirstInit();
		}
		
		private function initPropreties():void
		{
			alpha = 0;
			visible = false;
			tabChildren = false;
			tabEnabled = false;
			mouseEnabled = true;
		}
		
		protected function initContent():void
		{
			_content = new(_resDomain.getDefinition(contentName) as Class) as MovieClip;
			if(!_content)
				return;
			_content.x = stage.stageWidth>>1;
			_content.y = stage.stageHeight>>1;
			addChild(_content);
			
			DisplayObjectUtils.instance.mapSymbol(_content,this);
		}
		/**
		 * 从资源中生成面板的类名 
		 * @return 
		 * 
		 */		
		protected function get contentName():String
		{
			return _panelId;
		}
		/**
		 * 首次初始化 
		 * 
		 */		
		protected function onFirstInit():void
		{
			
		}
		
		public function dispose():void
		{
			_resDomain = null;
			_content = null;
		}
	}
}