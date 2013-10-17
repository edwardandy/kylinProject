package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_LifeToPhysicDef extends BasicSkillResult
	{
		/**
		 * 根据减少的血量增加额外的物理护甲
		 */
		public function SkillResult_LifeToPhysicDef(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var pct:int = arrValue[0];
			var def:int = arrValue[1];
			return target.lifeToPhysicDef(pct,def,owner);
		}
	}
}