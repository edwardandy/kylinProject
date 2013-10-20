package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 动态增加或减少攻击速度
	 */
	public class SkillResult_AtkSpeedPct extends BasicSkillResult
	{
		public function SkillResult_AtkSpeedPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.addAtkSpdPct(iPct,owner);
			return false;
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.addAtkSpdPct(-1*iPct,owner);
			return false;
		}
	}
}