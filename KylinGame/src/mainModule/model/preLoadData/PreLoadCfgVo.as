package mainModule.model.preLoadData
{
	/**
	 * 预加载配置项的格式 
	 * @author Edward
	 * 
	 */	
	public final class PreLoadCfgVo
	{
		/**
		 * 资源id 
		 */		
		public var id:String;
		/**
		 * 资源所属类别 
		 */		
		public var folder:String;
		/**
		 * 是否首次加载或者是后台缓冲加载 
		 */		
		public var bIsFirstLoad:Boolean;
		/**
		 * 后台缓冲时的优先级 
		 */		
		public var iPriority:int;
	}
}