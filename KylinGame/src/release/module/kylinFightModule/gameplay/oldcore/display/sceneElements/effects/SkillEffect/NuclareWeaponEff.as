package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;

	/**
	 * 核弹的随机小爆炸效果 
	 * @author Edward
	 * 
	 */	
	public class NuclareWeaponEff extends BasicSkillEffectRes
	{
		public function NuclareWeaponEff(typeId:int)
		{
			super(typeId);
		}
		
		override protected function beginToShow():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, destorySelf);
		}
	}
}