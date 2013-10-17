package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动增加攻击距离百分比
	 */
	public class SkillResult_PassiveAtkAreaPct extends BasicSkillResult
	{
		public function SkillResult_PassiveAtkAreaPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var rangePct:int = value[_id];
			if(rangePct>0)
				return target.addPassiveAtkAreaPct(rangePct,owner);
			return false;
		}
	}
}