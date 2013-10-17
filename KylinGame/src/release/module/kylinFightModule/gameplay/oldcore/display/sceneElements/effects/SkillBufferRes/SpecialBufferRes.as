package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;

	public class SpecialBufferRes extends BasicBufferResource
	{
		private var _playCnt:int = 1;
		
		public function SpecialBufferRes(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onBuffAnimAppearEnd():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,destorySelf);	
		}
	}
}