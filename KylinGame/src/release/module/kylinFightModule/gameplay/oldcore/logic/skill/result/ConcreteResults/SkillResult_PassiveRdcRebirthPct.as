package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动技能减少英雄 援军重生时间百分比
	 */
	public class SkillResult_PassiveRdcRebirthPct extends BasicSkillResult
	{
		public function SkillResult_PassiveRdcRebirthPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var reducePct:int = value[_id];
			if(reducePct>0)
				return target.rdcPassiveRebirthPct(reducePct,owner);
			return false;
		}
	}
}