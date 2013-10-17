package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.StraightBullectTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_AddTowerAtk extends BasicSkillResult
	{
		/**
		 * 增加周围塔的攻击力百分比  影响范围-增加的攻击百分比
		 */
		public function SkillResult_AddTowerAtk(strId:String)
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
			return target.addTowerAtkFlag(true,area,atk,owner);
		}
		
		override public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return target.addTowerAtkFlag(false,0,0,owner);
		}
	}
}