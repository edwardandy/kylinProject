package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 恶魔雪人变到最大后不能被阻拦，且增加攻击力
	 */
	public class SkillResult_Snowball extends BasicSkillResult
	{
		public function SkillResult_Snowball(strId:String)
		{
			super(strId);
		 	_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var atk:int = value[_id];
			return target.SnowballMax(atk,owner);
		}
	}
}