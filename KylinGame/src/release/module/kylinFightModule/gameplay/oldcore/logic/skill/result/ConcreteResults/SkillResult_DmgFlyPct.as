package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 对空中单位增加的伤害百分比 
	 * @author Edward
	 * 
	 */	
	public class SkillResult_DmgFlyPct extends BasicSkillResult
	{
		public function SkillResult_DmgFlyPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(!value[_id])
				return false;
			target.fightState.iDmgFlyPct += int(value[_id]);
			return true;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return effect(value,target,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(!value[_id])
				return false;
			target.fightState.iDmgFlyPct -= int(value[_id]);
			return true;
		}
	}
}