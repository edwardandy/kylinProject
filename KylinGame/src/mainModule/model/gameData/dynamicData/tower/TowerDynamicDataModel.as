package mainModule.model.gameData.dynamicData.tower
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

	/**
	 * 塔的动态数据 
	 * @author Edward
	 * 
	 */	
	public class TowerDynamicDataModel extends BaseDynamicItemsModel implements ITowerDynamicDataModel
	{
			
		private var _towerLevels:Object;
		
		public function TowerDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.TowerData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_TowerData;
			itemClazz = TowerDynamicItem;
		}
		/**
		 * 塔类型对应等级  {type=>level,...}
		 */	
		public function set towerLevels(value:Object):void
		{
			_towerLevels = value;
		}

		/**
		 * @inheritDoc
		 */		
		public function getTowerDataById(id:uint):ITowerDynamicItem
		{
			return getItemById(id) as ITowerDynamicItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function getTowerLevelByType(iType:int):int
		{
			return towerLevels[iType];
		}
	}
}