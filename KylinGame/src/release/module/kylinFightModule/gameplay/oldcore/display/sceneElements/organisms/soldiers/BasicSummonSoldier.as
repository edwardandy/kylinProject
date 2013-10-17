package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.towerDefense.fight.constants.FocusTargetType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import framecore.structure.model.user.soldier.SoldierData;

	public class BasicSummonSoldier extends CondottiereSoldier
	{
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
			var growth:int = SoldierData.getInstance().getGrowthByIdAndLvl(m_master.curLevel,myObjectTypeId);
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