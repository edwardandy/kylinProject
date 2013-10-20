package release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition
{
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions.AfterUseSkillTriggerCondition;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions.LowLifeLimitCondition;
	
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * 技能使用条件管理器
	 */
	public class GameFightSkillConditionMgr extends BasicSkillLogicMgr
	{				
		[Inject]
		public var injector:IInjector;
		
		public function GameFightSkillConditionMgr()
		{
			super();
		}
		
		public function getSkillConditionById(id:uint):BasicSkillUseCondition
		{
			var result:BasicSkillUseCondition = getSkillLogicById(id) as BasicSkillUseCondition;
			return result;	
		}
		
		override protected function getLogic(id:uint):BasicSkillLogicUnit
		{
			var result:BasicSkillLogicUnit;
			switch(id)
			{
				case SkillID.KnightSpirit:
					result = new LowLifeLimitCondition;
				case SkillID.FastShoot:
					result = new AfterUseSkillTriggerCondition;
			}
			if(result)
				injector.injectInto(result);
			return result;
		}
		
		override protected function createDefaultLogic():BasicSkillLogicUnit
		{
			return injector.instantiateUnmapped(BasicSkillUseCondition);
		}
	}
}