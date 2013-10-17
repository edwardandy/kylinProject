package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_MultyAtk extends BasicSkillResult
	{
		public function SkillResult_MultyAtk(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BEFORE_ATTACK;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var atkCount:int = value[_id];
			if(atkCount<2)
				return false;
			return target.setMultyAtkCount(atkCount,owner);
		}
	}
}