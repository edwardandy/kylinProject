package mainModule.model.gameInitSteps
{
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;

	/**
	 *  游戏主配置文件
	 * @author Edward
	 * 
	 */	
	public class GameCfgModel extends KylinActor implements IGameCfgModel
	{
		private var _gameCfg:XML;
		
		public function GameCfgModel()
		{
			super();
		}
		
		public function get gameCfg():XML
		{
			return _gameCfg;
		}

		public function set gameCfg(value:XML):void
		{
			_gameCfg = value;
		}

	}
}