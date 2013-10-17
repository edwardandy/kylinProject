package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.FocusTargetType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.soldier.SoldierTemplateInfo;

	//雇佣兵
	public class CondottiereSoldier extends BasicCondottiereSoldier
	{
		public function CondottiereSoldier(typeId:int)
		{
			myMoveFighterInfo = TemplateDataFactory.getInstance().getSoldierTemplateById(typeId);
			
			super(typeId);
			
			this.myElemeCategory = GameObjectCategoryType.CONDOTTIERE_SOLDIER;
		}
		
		override public function get type():int
		{
			return FocusTargetType.SOLDIER_TYPE;
		}
		
		protected function get soldierTempInfo():SoldierTemplateInfo
		{
			return myMoveFighterInfo as SoldierTemplateInfo;
		}
			
		override public function get resourceID():int
		{
			return (myMoveFighterInfo as SoldierTemplateInfo).resId || myObjectTypeId;
		}
		
		override protected function getDefaultSoundString():String
		{
			return soldierTempInfo?soldierTempInfo.sound:null;
		}
	}
}