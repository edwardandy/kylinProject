package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 按最大血量的万分比增加或减少血量
	 */
	public class SkillResult_AddMaxLifePct extends BasicSkillResult
	{
		public function SkillResult_AddMaxLifePct(strId:String)
		{
			super(strId);
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			if(param.hasOwnProperty(BufferFields.DURATION))
				return true;
			var life:int = param[_id];
			if(life>0 && target.isFullLife)
				return false;
			return true;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var life:int = value[_id];
			if(0 == life)
				return false;
			var hasAnim:Boolean = true;
			if(value.hasOwnProperty(BufferFields.NOTANIM))
				hasAnim = (1 != value[BufferFields.NOTANIM]);
			return target.addMaxLifePct(life,FightAttackType.MAGIC_ATTACK_TYPE,owner,hasAnim,getDieType(value));
		}
	}
}