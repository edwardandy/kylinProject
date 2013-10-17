package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_ReflectRdcAtkSpd extends BasicSkillResult
	{
		/**
		 * 攻击自己的敌人的攻击速度百分比降低
		 */
		public function SkillResult_ReflectRdcAtkSpd(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			target.addReflectRdcAtkSpdFlag(pct,owner);
			return true;
		}
	}
}