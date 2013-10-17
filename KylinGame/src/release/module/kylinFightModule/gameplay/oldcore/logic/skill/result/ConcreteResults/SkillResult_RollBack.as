package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 使怪物回退一定距离
	 */
	public class SkillResult_RollBack extends BasicSkillResult
	{
		public function SkillResult_RollBack(strId:String)
		{
			super(strId);
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			return !target.isBoss;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var range:int = value[_id];
			return target.rollBack(range,owner);
		}
	}
	
	
}