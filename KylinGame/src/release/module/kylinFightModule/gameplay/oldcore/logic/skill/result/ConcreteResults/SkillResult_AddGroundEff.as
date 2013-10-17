package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加一个地面特效
	 */
	public class SkillResult_AddGroundEff extends BasicSkillResult
	{
		public function SkillResult_AddGroundEff(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var arrParam:Array = [];
			if(arrValue.length>2)
			{
				for(var i:int=2;i<arrValue.length;++i)
				{
					arrParam.push(arrValue[i]);
				}
			}
			return target.addGroundEff(arrValue[0],arrValue[1],arrParam,owner);
		}
	}
}