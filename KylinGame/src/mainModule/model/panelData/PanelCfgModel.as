package mainModule.model.panelData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	
	public class PanelCfgModel extends KylinModel implements IPanelCfgModel
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		
		private var _dicPanelVos:Dictionary;
		
		public function PanelCfgModel()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			_dicPanelVos ||= new Dictionary;
			
			for each(var panel:XML in gameCfgModel.gameCfg.panel as XMLList)
			{
				var vo:PanelCfgVo = new PanelCfgVo;
				vo.panelKey = panel;
				vo.iPreLoad = int(panel.@iPreLoad);
				vo.priority = panel.@priority;
				vo.layerIndex = panel.@layerIndex;
				vo.appearStrategy = panel.@appear;
				vo.disappearStrategy = panel.@disappear;
				vo.resId = panel.@resId;
				_dicPanelVos[vo.panelKey] = vo;
			}
		}
		
		public function getPanelCfg(key:String):PanelCfgVo
		{
			return _dicPanelVos[key];
		}
		
		public function getPreloadPanelResIds():Array
		{
			var arr:Array = [];
			for each(var vo:PanelCfgVo in _dicPanelVos)
			{
				if(1 == vo.iPreLoad)
				{
					arr.push(vo.resId?vo.resId:vo.panelKey);
				}
			}
			return arr;
		}
	}
}