package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 格挡一次伤害 block:1-格挡或闪避的概率(没有就是100%)
	 */
	public class SkillResult_Block extends BasicSkillResult
	{
		public function SkillResult_Block(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BEFORE_UNDER_ATTACK;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			if(!arrValue[0])
				return false;
			var odds:int = arrValue[1];
			if(odds>0 && odds<100 && !GameMathUtil.randomTrueByProbability(odds))
				return true;
			if(arrValue.length>2)
				var blockAtkPct:int = arrValue[2];
			return target.addBlockFlag(blockAtkPct,owner);
		}
	}
}