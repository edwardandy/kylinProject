package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 魔法伤害
	 */
	public class SkillResult_MagicDmg extends BasicSkillResult
	{
		public function SkillResult_MagicDmg(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var dmg:int = getRandomValue(value[_id]);
			if(target == owner)
				return false;
			if(dmg>0)
			{
				var pct:int = owner?owner.getSkillDmgAddPct():0;
				return target.hurtSelf(dmg*(10000+pct)/10000,FightAttackType.MAGIC_ATTACK_TYPE,owner,getDieType(value),1,false);
			}
			return false;
		}
	}
}