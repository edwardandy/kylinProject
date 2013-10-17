package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动增加攻击力百分比
	 */
	public class SkillResult_PassiveAtkPct extends BasicSkillResult
	{
		public function SkillResult_PassiveAtkPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var atkPct:int = value[_id];
			if(atkPct>0)
				return target.addPassiveAtkPct(atkPct,owner);
			return false;
		}
	}
}