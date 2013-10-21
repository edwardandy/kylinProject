package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 死亡后召唤其他单位
	 */
	public class SkillResult_SummonAfterDie extends BasicSkillResult
	{
		public function SkillResult_SummonAfterDie(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var summonId:uint = arrValue[0];
			var duration:int = arrValue.length>1?arrValue[1]:0;
			return target.summonAfterDie(summonId,duration,owner);
		}
	}
}