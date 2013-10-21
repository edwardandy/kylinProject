package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 立即重生
	 */
	public class SkillResult_Rebirth extends BasicSkillResult
	{
		public function SkillResult_Rebirth(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.rebirthNow(owner);
		}
	}
}