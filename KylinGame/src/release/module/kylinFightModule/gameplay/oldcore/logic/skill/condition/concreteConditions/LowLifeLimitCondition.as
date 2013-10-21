package release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions
{
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.BasicSkillUseCondition;

	/**
	 * 血量下降到达的百分比触发技能 
	 * @author Administrator
	 * 
	 */	
	public class LowLifeLimitCondition extends BasicSkillUseCondition
	{
		public function LowLifeLimitCondition()
		{
			super();
		}
		
		override public function canUse(owner:ISkillOwner,state:SkillState):Boolean
		{
			var pct:int = int(_processer.effectParam[BufferFields.LOWLIFELIMIT]);
			if(owner.fightState.curLife*1.0/owner.fightState.maxlife >= pct*0.01)
				return false;
			return super.canUse(owner,state);
		}
	}
}