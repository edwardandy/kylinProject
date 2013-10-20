package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加自身所受的伤害百分比
	 */
	public class SkillResult_DmgPct extends BasicSkillResult
	{
		public function SkillResult_DmgPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			if(pct  == 0)
				return false;
			return target.addDmgUnderAtkPct(pct,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			if(pct  == 0)
				return false;
			return target.addDmgUnderAtkPct(-1*pct,owner);
		}
	}
}