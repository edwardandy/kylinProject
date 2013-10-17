package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	/**
	 * 巨匠维修工技能，提高工匠技能的影响范围和攻击力百分比 
	 * @author Edward
	 * 
	 */	
	public class SkillResult_ExtraAddTowerAtk extends BasicSkillResult
	{
		public function SkillResult_ExtraAddTowerAtk(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arr:Array = getValueArray(value);
			return target.addExtraAddTowerAtk(arr,owner);
		}
	}
}