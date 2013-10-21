package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加攻击距离 
	 * @author Edward
	 * 
	 */	
	public class SkillResult_AddAtkArea extends BasicSkillResult
	{
		public function SkillResult_AddAtkArea(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var area:int = value[_id];
			if(0 == area)
				return false;
			return target.addAtkArea(area,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var area:int = value[_id];
			if(0 == area)
				return false;
			return target.addAtkArea(-area,owner);
		}
	}
}