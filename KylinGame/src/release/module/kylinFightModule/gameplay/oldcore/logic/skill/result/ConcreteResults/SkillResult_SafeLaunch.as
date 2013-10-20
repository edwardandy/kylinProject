package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 安全弹射装置  safeLaunch:伤害范围-伤害值-自己昏迷时间-落地伤害范围-落地伤害值
	 */
	public class SkillResult_SafeLaunch extends BasicSkillResult
	{
		public function SkillResult_SafeLaunch(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BEFORE_DIE;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.addSafeLaunchFlag(int(arrValue[0]),int(arrValue[1]),int(arrValue[2])
				,arrValue.length>3?int(arrValue[3]):0,arrValue.length>4?int(arrValue[4]):0,owner);
		}
	}
}