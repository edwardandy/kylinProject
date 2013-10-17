package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_Dmg extends BasicSkillResult
	{
		public function SkillResult_Dmg(strId:String)
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
				var pct:int = 0;
				if(owner && owner.isAlive && !owner.isFreezedState())
					pct = owner.getSkillDmgAddPct();
				return target.hurtSelf(dmg*(10000+pct)/10000,FightAttackType.PHYSICAL_ATTACK_TYPE,owner,getDieType(value),1,false);
			}
			return false;
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			if(target == owner)
				return false;
			return true;
		}
	}
}