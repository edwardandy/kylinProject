package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_PassiveRdcSkillCdPct extends BasicSkillResult
	{
		/**
		 * 被动减少技能cd时间百分比
		 */
		public function SkillResult_PassiveRdcSkillCdPct(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arr:Array = getValueArray(value);
			var reducePct:int = arr[0];
			if(reducePct>0)
			{
				if(1 == arr.length)
					return target.rdcPassiveSkillCdPct(reducePct,0,owner);
				else
				{
					var result:Boolean = true;
					for(var i:int = 1;i<arr.length;++i)
					{
						if(!target.rdcPassiveSkillCdPct(reducePct,arr[i],owner) && result)
							result = false;
					}
					return result;
				}
			}
			return false;
		}
	}
}