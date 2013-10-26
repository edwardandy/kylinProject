package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 沉默玩家，无法使用战场法术
	 */
	public class SkillResult_PlayerSilent extends BasicSkillResult
	{
		[Inject]
		public var mainUI:GameFightMainUIView;
		
		public function SkillResult_PlayerSilent(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var duration:int = value[_id];
			mainUI.fightControllBarView.notifyMagicSilent(duration);
			return true;
		}
	}
}