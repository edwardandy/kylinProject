package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 改变攻击所用的子弹
	 */
	public class SkillResult_ChangeWeapon extends BasicSkillResult
	{
		public function SkillResult_ChangeWeapon(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var weapon:uint = value[_id];
			if(weapon == 0)
				return false;
			return target.changeWeapon(weapon,owner);
		}
	}
}