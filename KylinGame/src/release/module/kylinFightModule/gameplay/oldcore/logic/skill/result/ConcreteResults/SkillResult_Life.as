package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_Life extends BasicSkillResult
	{
		public function SkillResult_Life(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var hasAnim:Boolean = true;
			if(value.hasOwnProperty(BufferFields.NOTANIM))
				hasAnim = (1 != value[BufferFields.NOTANIM]);
			var life:uint = getRandomValue(value[_id]);
			return target.addLife(life,owner,hasAnim);
		}
		
		override public function canUse(target:ISkillTarget,owner:ISkillOwner,param:Object):Boolean
		{
			return !target.isFullLife;
		}
	}
}