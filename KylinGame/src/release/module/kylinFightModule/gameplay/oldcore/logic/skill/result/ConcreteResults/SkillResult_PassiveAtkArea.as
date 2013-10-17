package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动增加攻击距离点数
	 */
	public class SkillResult_PassiveAtkArea extends BasicSkillResult
	{
		public function SkillResult_PassiveAtkArea(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var range:int = value[_id];
			if(range>0)
				return target.addPassiveAtkArea(range,owner);
			return false;
		}
	}
}