package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 对目标造成效果所有者的基础攻击的倍率伤害
	 */
	public class SkillResult_DmgAddition extends BasicSkillResult
	{
		public function SkillResult_DmgAddition(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var pct:int = getRandomValue(value[_id]);;
			if(pct>0)
				return target.dmgAddition(pct,owner,getDieType(value));
			return false;
		}
	}
}