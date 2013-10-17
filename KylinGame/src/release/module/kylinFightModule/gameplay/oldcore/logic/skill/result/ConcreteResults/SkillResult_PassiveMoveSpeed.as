package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动技能永久增加移动速度点数
	 */
	public class SkillResult_PassiveMoveSpeed extends BasicSkillResult
	{
		public function SkillResult_PassiveMoveSpeed(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var spd:int = value[_id];
			if(spd>0)
				return target.addPassiveMoveSpeed(spd,owner);
			return false;
		}
	}
}