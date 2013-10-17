package release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.concreteConditions
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.BasicSkillUseCondition;

	/**
	 *  在该技能列表里的技能被使用后触发
	 * @author Edward
	 * 
	 */	
	public class AfterUseSkillTriggerCondition extends BasicSkillUseCondition
	{
		public function AfterUseSkillTriggerCondition()
		{
			super();
		}
		
		override public function canUse(owner:ISkillOwner,state:SkillState):Boolean
		{
			var skills:String = _processer.effectParam[BufferFields.TRIGSKILLID];
			if(!skills)
				return super.canUse(owner,state);
			
			var arrSkills:Array = skills.split("-");
			if(-1 == arrSkills.indexOf(owner.fightState.curUseSkillId.toString()))
				return false;
			
			return super.canUse(owner,state);
		}
	}
}