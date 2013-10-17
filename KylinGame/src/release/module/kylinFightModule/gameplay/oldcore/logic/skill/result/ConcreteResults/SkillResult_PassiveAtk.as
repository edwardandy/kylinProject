package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动增加攻击力
	 */
	public class SkillResult_PassiveAtk extends BasicSkillResult
	{
		public function SkillResult_PassiveAtk(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var atk:int = value[_id];
			if(atk>0)
				return target.addPassiveAtk(atk,owner);
			return false;
		}
	}
}