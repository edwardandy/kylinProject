package mainModule.model.gameConstAndVar
{	
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	
	public class ConfigDataModel extends KylinModel implements IConfigDataModel
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		
		private var _nPanelScaleVelocity:Number;
		private var _nPanelMaxScale:Number;
		private var _nPanelAlphaVelocity:Number;		
		
		public function ConfigDataModel()
		{
			super();
		}

		public function get nPanelAlphaVelocity():Number
		{
			return _nPanelAlphaVelocity;
		}

		public function get nPanelMaxScale():Number
		{
			return _nPanelMaxScale;
		}

		public function get nPanelScaleVelocity():Number
		{
			return _nPanelScaleVelocity;
		}

		[PostConstruct]
		public function init():void
		{
			_nPanelScaleVelocity = Number(gameCfgModel.gameCfg.panelscalevelocity);
			_nPanelMaxScale = Number(gameCfgModel.gameCfg.panelmaxscale);
			_nPanelAlphaVelocity = Number(gameCfgModel.gameCfg.panelalphavelocity);
		}
	}
}