package mainModule.model.preLoadData.interfaces
{
	import mainModule.model.preLoadData.PreLoadCfgVo;

	/**
	 * 游戏预加载资源配置 
	 * @author Edward
	 * 
	 */	
	public interface IPreLoadCfgModel
	{
		/**
		 * 初始化加载到的配置
		 * @param cfg
		 * 
		 */		
		function initData(cfg:XML):void;
		/**
		 * 首次需要加载的资源 
		 * @return 
		 * 
		 */		
		function get firstLoadRes():Vector.<PreLoadCfgVo>;
		/**
		 * 需要后台缓冲的资源 
		 * @return 
		 * 
		 */		
		function get backgroundLoadRes():Vector.<PreLoadCfgVo>
	}
}