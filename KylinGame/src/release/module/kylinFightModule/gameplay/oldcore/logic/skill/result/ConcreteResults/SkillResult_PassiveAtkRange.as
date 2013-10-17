package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加普通攻击的溅射范围 
	 * @author Edward
	 * 
	 */	
	public class SkillResult_PassiveAtkRange extends BasicSkillResult
	{
		public function SkillResult_PassiveAtkRange(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(0 == int(value[_id]))
				return false;
			target.fightState.range += int(value[_id]);
			return true;
		}
	}
}