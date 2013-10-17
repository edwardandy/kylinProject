package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_DropBox extends BasicSkillResult
	{
		/**
		 * 掉落物资箱 dropBox:xxxxx-1-2000-100
		 */
		public function SkillResult_DropBox(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var itemId:uint = arrValue[0];
			var count:int = arrValue[1];
			var duration:int = arrValue[2];
			var money:uint = arrValue[3];
			return target.dropBox(itemId,count,duration,money,owner);
		}
	}
}