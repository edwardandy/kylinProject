package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动技能增加魔法防御
	 */
	public class SkillResult_PassiveMagicDef extends BasicSkillResult
	{
		public function SkillResult_PassiveMagicDef(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var def:int = value[_id];
			if(def>0)
				return target.addPassiveMagicDef(def,owner);
			return false;
		}
	}
}