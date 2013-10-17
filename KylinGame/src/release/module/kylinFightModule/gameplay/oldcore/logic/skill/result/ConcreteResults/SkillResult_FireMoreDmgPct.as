package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 受到龙息塔攻击伤害加成百分比
	 */
	public class SkillResult_FireMoreDmgPct extends BasicSkillResult
	{
		public function SkillResult_FireMoreDmgPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.addFireMoreDmgPct(iPct,owner);
			return false;
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.addFireMoreDmgPct(0,owner);
			return false;
		}
	}
}