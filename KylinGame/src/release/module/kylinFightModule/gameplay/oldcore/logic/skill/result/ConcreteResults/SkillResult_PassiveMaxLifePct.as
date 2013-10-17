package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动技能按百分比增加最大血量
	 */
	public class SkillResult_PassiveMaxLifePct extends BasicSkillResult
	{
		public function SkillResult_PassiveMaxLifePct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var maxLifePct:int = value[_id];
			if(maxLifePct)
				return target.addPassiveMaxLifePct(maxLifePct,owner);
			return false;
		}
	}
}