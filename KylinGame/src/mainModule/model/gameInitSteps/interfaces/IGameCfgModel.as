package mainModule.model.gameInitSteps.interfaces
{
	/**
	 *  游戏主配置文件
	 * @author Edward
	 * 
	 */	
	public interface IGameCfgModel
	{
		/**
		 * 游戏主配置文件 
		 * @return 
		 * 
		 */		
		function get gameCfg():XML;
		function set gameCfg(value:XML):void;
	}
}