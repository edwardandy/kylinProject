package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import mainModule.model.gameData.sheetData.summonerGrowth.ISummonerGrowthSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;

	public class BasicSummonSoldier extends CondottiereSoldier
	{
		[Inject]
		public var growthData:ISummonerGrowthSheetDataModel;
		protected var m_master:ISkillOwner;
		
		public function BasicSummonSoldier(typeId:int)
		{
			super(typeId);
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return GameObjectCategoryType.SOLDIER+"_"+(soldierTempInfo.resId || myObjectTypeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		override protected function initFightState():void
		{
			super.initFightState();
			
			var growth:int = growthData.getSummonerGrowthByMasterLvl(m_master.curLevel).getSummonerGrowthById(myObjectTypeId);
			myFightState.maxlife *= growth/100.0;
			myFightState.minAtk *= growth/100.0;
			myFightState.maxAtk *= growth/100.0;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			if(m_master)
				m_master.notifyPetDisappear(this.myObjectTypeId,this);
		}
		
		override protected function getUpWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.WALK;
		}
		
		override protected function getDownWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.WALK;
		}
		
		public function set master(owner:ISkillOwner):void
		{
			m_master = owner;	
		}		
	}
}