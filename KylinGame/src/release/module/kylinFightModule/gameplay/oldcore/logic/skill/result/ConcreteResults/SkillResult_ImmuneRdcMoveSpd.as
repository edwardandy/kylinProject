package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_ImmuneRdcMoveSpd extends BasicSkillResult
	{
		/**
		 * 免疫移动减速
		 */
		public function SkillResult_ImmuneRdcMoveSpd(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.addImmuneRdcMoveSpdFlag(true,owner);
		}
		
		override public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.addImmuneRdcMoveSpdFlag(false,owner);
		}	
	}
}