package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_Summon extends BasicSkillResult
	{
		public function SkillResult_Summon(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var id:uint = arrValue[0];
			var count:int = (arrValue.length>1 && arrValue[1]>0)?arrValue[1]:1;
			var maxCount:int = (arrValue.length>2 && arrValue[2]>0)?arrValue[2]:count;
			target.summon(id,count,maxCount,owner);
			return true;
		}
		
		override public function canUse(target:ISkillTarget, owner:ISkillOwner, param:Object):Boolean
		{
			var arrValue:Array = getValueArray(param);
			var id:uint = arrValue[0];
			var count:int = (arrValue.length>1 && arrValue[1]>0)?arrValue[1]:1;
			var maxCount:int = (arrValue.length>2 && arrValue[2]>0)?arrValue[2]:count;
			return target.canSummon(id,maxCount,owner);
		}
	}
}