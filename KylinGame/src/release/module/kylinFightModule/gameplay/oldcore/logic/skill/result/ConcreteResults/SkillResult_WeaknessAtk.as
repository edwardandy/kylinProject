package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 连续攻击同一目标造成累计伤害
	 */
	public class SkillResult_WeaknessAtk extends BasicSkillResult
	{
		public function SkillResult_WeaknessAtk(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var atk:int = value[_id];
			if(atk<=0)
				return false;
			/*if(owner && GameObjectCategoryType.TOWER == owner.elemeCategory)
				atk = owner.minAtk * atk /100;*/
			return target.addWeaknessAtk(true,atk,owner);
			
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return target.addWeaknessAtk(false,0,owner);
		}
	}
}