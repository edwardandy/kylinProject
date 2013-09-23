package mainModule.model.panelData
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import utili.structure.DictionaryUtil;

	/**
	 * 显示层次集合
	 * @author Edward
	 * 
	 */	
	public final class ViewLayersModel
	{
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
		
		public function ViewLayersModel()
		{
			panelIdxToLayer = new Dictionary();
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