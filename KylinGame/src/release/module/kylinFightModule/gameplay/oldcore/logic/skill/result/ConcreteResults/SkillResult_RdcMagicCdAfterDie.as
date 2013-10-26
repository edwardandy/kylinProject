package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 死亡后减少战场法术的cd
	 */
	public class SkillResult_RdcMagicCdAfterDie extends BasicSkillResult
	{
		[Inject]
		public var mainUI:GameFightMainUIView;
		
		public function SkillResult_RdcMagicCdAfterDie(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH;
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var magicId:uint = arrValue[0];
			var cd:int = arrValue[1];
			mainUI.fightControllBarView.reduceMagicSkillCDTime(magicId, cd, 1);
			return true;
		}
	}
}