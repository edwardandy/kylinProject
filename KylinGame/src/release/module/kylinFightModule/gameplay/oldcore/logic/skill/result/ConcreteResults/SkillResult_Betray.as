package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_Betray extends BasicSkillResult
	{
		/**
		 * 魅惑
		 */
		public function SkillResult_Betray(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.setBetrayFlag(true,owner);
		}
		
		override public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return target.setBetrayFlag(false,owner);
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			return target.canBetray();
		}
	}
}