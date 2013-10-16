package release.module.kylinFightModule.model.scene
{
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetItem;
	
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;

	/**
	 * 战斗场景数据 
	 * @author Edward
	 * 
	 */	
	public class SceneDataModel extends KylinActor implements ISceneDataModel
	{
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var tollgateSheet:ITollgateSheetDataModel;
	
		private var _sceneGoods:int = 0;
		private var _sceneLife:int = 0;
		private var _sceneTotalLife:int = 0;
		private var _sceneType:int = -1;
		
		public function SceneDataModel()
		{
			super();
		}
		
		public function get sceneType():int
		{
			return _sceneType;
		}

		public function get sceneTotalLife():int
		{
			return _sceneTotalLife;
		}

		public function get sceneLife():int
		{
			return _sceneLife;
		}

		public function set sceneLife(value:int):void
		{
			_sceneLife = value;
		}

		public function get sceneGoods():int
		{
			return _sceneGoods;
		}

		public function set sceneGoods(value:int):void
		{
			_sceneGoods = value;
		}

		public function initialize():void
		{
			var tollgateItem:ITollgateSheetItem = tollgateSheet.getTollgateSheetById(fightData.tollgateId);
			_sceneGoods = fightData.initGoods>0 ? fightData.initGoods : tollgateItem.goods;
			_sceneLife = tollgateItem.life;
			_sceneTotalLife = _sceneLife;
			_sceneType = tollgateItem.sceneType;
		}
		
		public function destroy():void
		{
			fightData = null;
			tollgateSheet = null;
		}
	}
}