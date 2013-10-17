package release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition
{
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions.AfterUseSkillTriggerCondition;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions.LowLifeLimitCondition;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;
	
	import flash.utils.Dictionary;

	/**
	 * 技能使用条件管理器
	 */
	public class GameFightSkillConditionMgr extends BasicSkillLogicMgr
	{				
		public function GameFightSkillConditionMgr()
		{
			super();
		}
		
		public function getSkillConditionById(id:uint,isHero:Boolean = false):BasicSkillUseCondition
		{
			var result:BasicSkillUseCondition = getSkillLogicById(id,isHero) as BasicSkillUseCondition;
			return result;	
		}
		
		override protected function getLogic(id:uint):BasicSkillLogicUnit
		{
			switch(id)
			{
				case SkillID.KnightSpirit:
					return new LowLifeLimitCondition;
				case SkillID.FastShoot:
					return new AfterUseSkillTriggerCondition;
			}
			return null;
		}
		
		override protected function createDefaultLogic():BasicSkillLogicUnit
		{
			return new BasicSkillUseCondition;
		}
	}
}