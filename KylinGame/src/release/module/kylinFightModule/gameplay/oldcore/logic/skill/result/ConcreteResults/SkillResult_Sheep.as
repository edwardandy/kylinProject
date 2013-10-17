package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 变成羊，不能攻击，不能使用技能，没有护甲
	 */
	public class SkillResult_Sheep extends BasicSkillResult
	{
		public function SkillResult_Sheep(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			return !target.fightState.bSheep && !target.isBoss && !target.fightState.betrayState.bBetrayed && null == target.fightState.provokeTarget
				&& !target.fightState.bMaxSnowball;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.changeToSheep(true,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			if(!hasFlag(value))
				return false;
			return target.changeToSheep(false,owner);
		}
	}
}