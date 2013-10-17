package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	/**
	 * 生命值下降到一定百分比以下所受到的伤害减少百分比
	 */
	public class SkillResult_RdcDmgByLifeDown extends BasicSkillResult
	{
		public function SkillResult_RdcDmgByLifeDown(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.RdcDmgByLifeDown(true,arrValue[0],arrValue[1],owner);
		}
	}
}