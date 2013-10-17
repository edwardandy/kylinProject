package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 被动技能增加移动速度百分比
	 */
	public class SkillResult_PassiveMoveSpeedPct extends BasicSkillResult
	{
		public function SkillResult_PassiveMoveSpeedPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var spdPct:int = value[_id];
			if(spdPct>0)
				return target.addPassiveMoveSpeedPct(spdPct,owner);
			return false;
		}
	}
}