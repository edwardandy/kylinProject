package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 *  英雄通过装备获得的生命值加成提高的百分比
	 * @author Edward
	 * 
	 */	
	public class SkillResult_PassiveEquipPct extends BasicSkillResult
	{
		public function SkillResult_PassiveEquipPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var pcts:Array = getValueArray(value);
			if(pcts && 4 == pcts.length)
				return target.addPassiveEquipPct(pcts,owner);
			return false;
		}
	}
}