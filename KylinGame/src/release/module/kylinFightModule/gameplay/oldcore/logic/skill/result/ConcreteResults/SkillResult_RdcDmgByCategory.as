package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 减少受到某一类目标的伤害 rdcDmgByCategory:tower-30,类型为0则所有类型伤害都减伤
	 */
	public class SkillResult_RdcDmgByCategory extends BasicSkillResult
	{
		public function SkillResult_RdcDmgByCategory(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.rdcDmgByCategory(arrValue[0],arrValue[1],owner);
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			return target.rdcDmgByCategory(arrValue[0],arrValue[1],owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return target.rdcDmgByCategory(0,0,owner);
		}
	}
}