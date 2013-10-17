package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 对于不同体型的目标的伤害加成
	 */
	public class SkillResult_DmgPctBySize extends BasicSkillResult
	{
		public function SkillResult_DmgPctBySize(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.addDmgPctBySize(true,arrValue[0],arrValue[1],arrValue[2],owner);
		}

	}
}