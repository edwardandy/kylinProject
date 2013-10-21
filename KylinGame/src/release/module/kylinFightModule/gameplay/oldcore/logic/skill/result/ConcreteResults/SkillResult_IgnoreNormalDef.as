package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 普通攻击对方时忽略对方的护甲  
	 * @author Edward
	 * 
	 */	
	public class SkillResult_IgnoreNormalDef extends BasicSkillResult
	{
		public function SkillResult_IgnoreNormalDef(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(0 == value[_id])
				return false;
			target.fightState.bIgnoreNormalDef = true;
			return true;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return effect(value,target,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(0 == value[_id])
				return false;
			target.fightState.bIgnoreNormalDef = false;
			return true;
		}
	}
}