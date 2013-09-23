package mainModule.model.panelData
{
	/**
	 * 面板设置数据 
	 * @author Edward
	 * 
	 */	
	public final class PanelCfgVo
	{
		/**
		 * 面板id 
		 */		
		public var panelKey:String;
		/**
		 * 是否首次加载 1-首次预加载,2-后台隐藏式加载,0-需要时加载
		 */		
		public var iPreLoad:int;
		/**
		 * 加载优先级 
		 */		
		public var priority:int;
		/**
		 * 显示层级 
		 */		
		public var layerIndex:int;
		/**
		 * 面板资源id(可能多个面板类共用同一个资源文件) 
		 */		
		public var resId:String;
		/**
		 * 显示动画策略 
		 */		
		public var appearStrategy:String;
		/**
		 * 消失动画策略 
		 */		
		public var disappearStrategy:String;
		
		public function PanelCfgVo()
		{
		}
	}
}