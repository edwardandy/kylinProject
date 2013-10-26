package mainModule.service.gameDataServices.helpServices
{
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetItem;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	/**
	 * 关卡相关逻辑方法
	 * @author Edward
	 * 
	 */	
	public class TollgateService extends KylinActor implements ITollgateService
	{
		[Inject]
		public var tollgateModel:ITollgateSheetDataModel;
		[Inject]
		public var towerModel:ITowerSheetDataModel;
		
		public function TollgateService()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */		
		public function canTowerBuildInTollgate(tollgateId:uint,towerId:uint):Boolean
		{
			const tollgateItem:ITollgateSheetItem = tollgateModel.getTollgateSheetById(tollgateId);
			if(!tollgateItem)
				return false;
			
			const towerItem:ITowerSheetItem = towerModel.getTowerSheetById(towerId);
			if(!towerItem)
				return false;
			
			return towerItem.level <= tollgateItem.getTowerMaxLvlByType(towerItem.type);
			
		}
	}
}