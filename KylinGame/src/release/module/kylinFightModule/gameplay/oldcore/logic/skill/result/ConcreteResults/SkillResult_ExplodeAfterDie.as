package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 死亡后爆炸
	 */
	public class SkillResult_ExplodeAfterDie extends BasicSkillResult
	{
		public function SkillResult_ExplodeAfterDie(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var dmg:int = getRandomValue(value[BufferFields.EXPLODE_DMG]);
			//塔的技能伤害和塔的攻击成正比
			if(owner && GameObjectCategoryType.TOWER == owner.elemeCategory)
				dmg = owner.maxAtk * dmg/100;
			
			var range:int = value[BufferFields.RANGE];
			return target.explodeAfterDie(dmg,range,owner,getDieType(value));
		}
	}
}