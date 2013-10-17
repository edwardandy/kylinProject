package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 被动技能增加最大血量
	 */
	public class SkillResult_PassiveMaxLife extends BasicSkillResult
	{
		public function SkillResult_PassiveMaxLife(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var maxLife:int = value[_id];
			if(maxLife)
				return target.addPassiveMaxLife(maxLife,owner);
			return false;
		}
	}
}