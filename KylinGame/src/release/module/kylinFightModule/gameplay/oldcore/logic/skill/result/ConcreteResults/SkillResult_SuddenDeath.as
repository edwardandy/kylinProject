package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 被秒杀
	 */
	public class SkillResult_SuddenDeath extends BasicSkillResult
	{
		public function SkillResult_SuddenDeath(strId:String)
		{
			super(strId);
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			return !target.isBoss && !target.fightState.bInvincible;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var odds:int = value[_id];
			if(GameMathUtil.randomTrueByProbability(odds/100.0))
				return target.suddenDeath(owner,getDieType(value));
			return false;
		}
	}
}