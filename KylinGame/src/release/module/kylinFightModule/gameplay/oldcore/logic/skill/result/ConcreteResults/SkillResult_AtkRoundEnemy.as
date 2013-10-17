package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_AtkRoundEnemy extends BasicSkillResult
	{
		/**
		 * 每秒攻击周围一定范围的敌人 atkRoundEnemy:范围(像素)-(攻击值)
		 */
		public function SkillResult_AtkRoundEnemy(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.atkRoundUnits(arrValue[0],arrValue[1],target.oppositeCampType,owner,getDieType(value));
		}
	}
}