package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_MoveSpeedPct extends BasicSkillResult
	{
		/**
		 * 动态增加或减少移动速度
		 */
		public function SkillResult_MoveSpeedPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			return !target.fightState.bImmuneRdcMoveSpd && !target.fightState.bInvincible;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.changeMoveSpeed(iPct,owner);
			return false;
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var iPct:int = value[_id];
			if(iPct)
				return target.changeMoveSpeed(-1*iPct,owner,true);
			return false;
		}
	}
}