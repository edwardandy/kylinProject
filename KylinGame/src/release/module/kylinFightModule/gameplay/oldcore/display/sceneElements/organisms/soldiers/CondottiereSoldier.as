package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import mainModule.model.gameData.sheetData.soldier.ISoldierSheetDataModel;
	import mainModule.model.gameData.sheetData.soldier.ISoldierSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;

	//雇佣兵
	public class CondottiereSoldier extends BasicCondottiereSoldier
	{
		[Inject]
		public var soldierModel:ISoldierSheetDataModel;
		
		public function CondottiereSoldier(typeId:int)
		{
			myMoveFighterInfo = soldierModel.getSoldierSheetById(typeId);
			
			super(typeId);
			
			this.myElemeCategory = GameObjectCategoryType.CONDOTTIERE_SOLDIER;
		}
		
		override public function get type():int
		{
			return FocusTargetType.SOLDIER_TYPE;
		}
		
		protected function get soldierTempInfo():ISoldierSheetItem
		{
			return myMoveFighterInfo as ISoldierSheetItem;
		}
			
		override public function get resourceID():int
		{
			return (myMoveFighterInfo as ISoldierSheetItem).resId || myObjectTypeId;
		}
		
		override protected function getDefaultSoundObj():Object
		{
			return soldierTempInfo?soldierTempInfo.objSound:null;
		}
	}
}