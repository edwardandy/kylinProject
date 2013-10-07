package mainModule.extensions.viewLayers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.utilities.datastructures.DictionaryUtil;
	
	/**
	 * 显示层次集合
	 * @author Edward
	 * 
	 */	
	public final class ViewLayersMgr
	{
		private var _contextRoot:DisplayObjectContainer;
		private var _fightScene:DisplayObjectContainer;
		/**
		 * 面板层 
		 */		
		public var panelLayer:DisplayObjectContainer;
		private var panelIdxToLayer:Dictionary;
		/**
		 * 2级弹框层 
		 */		
		public var popUpLayer:DisplayObjectContainer;
		/**
		 * 提示层 
		 */		
		public var tipsLayer:DisplayObjectContainer;
		/**
		 * 打开面板时的遮罩层 
		 */		
		public var waitPanelAppearLayer:Sprite;
		
		public function ViewLayersMgr()
		{
			panelIdxToLayer = new Dictionary();
			init();
		}
		
		/**
		 * 框架根显示容器 
		 */
		public function get contextRoot():DisplayObjectContainer
		{
			return _contextRoot;
		}
		/**
		 * 战斗场景层，不进行框架监听 
		 * 
		 */		
		public function get fightScene():DisplayObjectContainer
		{
			return _fightScene;
		}

		private function init():void
		{
			_contextRoot = new Sprite;
			_fightScene = new Sprite;
			
			panelLayer = new Sprite;
			panelLayer.mouseEnabled = false;
			_contextRoot.addChild(panelLayer);
			
			popUpLayer = new Sprite;
			popUpLayer.visible = false;
			_contextRoot.addChild(popUpLayer);
			
			tipsLayer = new Sprite;
			tipsLayer.mouseEnabled = false;
			tipsLayer.mouseChildren = false;
			_contextRoot.addChild(tipsLayer);
			
			waitPanelAppearLayer = new Sprite;
			waitPanelAppearLayer.mouseChildren = false;
			waitPanelAppearLayer.visible = false;
			_contextRoot.addChild(waitPanelAppearLayer);
		}
		
		
		public function getPanelSubLayerByIdx(layerIndex:int):DisplayObjectContainer
		{
			if(null == panelIdxToLayer[layerIndex])
			{
				var sp:Sprite = new Sprite();
				panelLayer.addChild(sp);
				panelIdxToLayer[layerIndex] = sp;
				var temp:Array 	= DictionaryUtil.getKeys(panelIdxToLayer);
				temp.sort(Array.NUMERIC);
				for (var i:int = 0, len:int = temp.length; i < len; ++i)
				{
					var layer:Sprite = panelIdxToLayer[temp[i]];
					panelLayer.setChildIndex(layer,i);
				}
			}
			return panelIdxToLayer[layerIndex];
		}
	}
}