package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 普通攻击时增加攻击百分比 如普通攻击有20%概率造成双倍伤害（远程造成1.5倍伤害
	 */
	public class SkillResult_HugeDmgPct extends BasicSkillResult
	{
		public function SkillResult_HugeDmgPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrProp:Array = getValueArray(value);
			var near:int = arrProp[0];
			var far:int = arrProp[1];
			var odds:int = ((arrProp.length>2)?arrProp[2]:0);
			return target.hugeDmgEff(true,owner,odds,near,far);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return target.hugeDmgEff(false,owner,0,0,0);
		}
	}
}