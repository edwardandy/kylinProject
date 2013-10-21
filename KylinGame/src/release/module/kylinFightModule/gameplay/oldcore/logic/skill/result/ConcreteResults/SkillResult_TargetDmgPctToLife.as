package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_TargetDmgPctToLife extends BasicSkillResult
	{
		/**
		 * 对目标的普通攻击伤害的百分比转换成自身生命值
		 */
		public function SkillResult_TargetDmgPctToLife(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.addTargetDmgPctToLife(iPct,owner);
			return false;
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return target.addTargetDmgPctToLife(0,owner);
		}
	}
}