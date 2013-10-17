package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 巨兽之怒 beastAngry:血量下限百分比-变为区域攻击的范围-攻击速度加成-移动速度加成
	 */
	public class SkillResult_BeastAngry extends BasicSkillResult
	{
		public function SkillResult_BeastAngry(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.addBeastAngryFlag(arrValue[0],arrValue[1],arrValue[2],arrValue[3],owner);
		}
	}

	
}