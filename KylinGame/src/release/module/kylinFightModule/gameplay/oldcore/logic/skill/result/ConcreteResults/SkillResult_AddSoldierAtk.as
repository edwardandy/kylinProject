package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加英雄周围士兵的攻击百分比
	 */
	public class SkillResult_AddSoldierAtk extends BasicSkillResult
	{
		public function SkillResult_AddSoldierAtk(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var area:int = arrValue[0];
			var atk:int = arrValue[1];
			if(!area || !atk)
				return false;
			return target.addSoldierAtkFlag(true,area,atk,owner);
		}
		
		override public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return target.addSoldierAtkFlag(false,0,0,owner);
		}
	}
}