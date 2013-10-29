package mainModule.model.gameConstAndVar
{		
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	
	public class ConfigDataModel implements IConfigDataModel
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		
		private var _nPanelScaleVelocity:Number;
		private var _nPanelMaxScale:Number;
		private var _nPanelAlphaVelocity:Number;	
		private var _arrItemIdsInFight:Array = [];
		
		public function ConfigDataModel()
		{
			super();
		}
		/**
		 * 战斗中可以购买并使用的道具 
		 * @return 
		 * 
		 */		
		public function get arrItemIdsInFight():Array
		{
			return _arrItemIdsInFight;
		}
		
		public function set itemIdsInFight(value:String):void
		{
			_arrItemIdsInFight.length = 0;
			if(!value)
				return;
			_arrItemIdsInFight = KylinStringUtil.splitStringArrayToIntArray(value);
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
			itemIdsInFight = String(gameCfgModel.gameCfg.itemIdsInFight);
		}
	}
}