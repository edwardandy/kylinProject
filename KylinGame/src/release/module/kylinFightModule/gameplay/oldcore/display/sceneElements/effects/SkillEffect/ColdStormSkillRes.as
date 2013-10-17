package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;

	/**
	 * 极寒风暴
	 */
	public class ColdStormSkillRes extends BasicSkillEffectRes
	{
		private var _myBodySkin1:NewBitmapMovieClip;
		private var _myBodySkin2:NewBitmapMovieClip;
		private var _myBodySkin3:NewBitmapMovieClip;
		public function ColdStormSkillRes(typeId:int)
		{
			super(typeId);
		}
		
		override protected function createBodySkin():void
		{
			//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(bodySkinResourceURL, myScaleRatioType);
			//if(vecFrames)
			{
				myBodySkin = new NewBitmapMovieClip([bodySkinResourceURL],[myScaleRatioType]);
				myBodySkin.smoothing = true;
				addChild(myBodySkin);
				myBodySkin.x = 200;
				myBodySkin.y = 250;
				
				_myBodySkin1 = new NewBitmapMovieClip([bodySkinResourceURL],[myScaleRatioType]);
				_myBodySkin1.smoothing = true;
				addChild(_myBodySkin1);
				_myBodySkin1.x = 200;
				_myBodySkin1.y = 450;
				
				_myBodySkin2 = new NewBitmapMovieClip([bodySkinResourceURL],[myScaleRatioType]);
				_myBodySkin2.smoothing = true;
				addChild(_myBodySkin2);
				_myBodySkin2.x = 600;
				_myBodySkin2.y = 250;
				
				_myBodySkin3 = new NewBitmapMovieClip([bodySkinResourceURL],[myScaleRatioType]);
				_myBodySkin3.smoothing = true;
				addChild(_myBodySkin3);
				_myBodySkin3.x = 600;
				_myBodySkin3.y = 450;
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			_myBodySkin1.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			_myBodySkin2.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			_myBodySkin3.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			_myBodySkin1.render(iElapse);
			_myBodySkin2.render(iElapse);
			_myBodySkin3.render(iElapse);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(myBodySkin != null)
			{
				removeChild(myBodySkin);
				myBodySkin.dispose();
				myBodySkin = null;
			}	
			if(_myBodySkin1 != null)
			{
				removeChild(_myBodySkin1);
				_myBodySkin1.dispose();
				_myBodySkin1 = null;
			}	
			if(_myBodySkin2 != null)
			{
				removeChild(_myBodySkin2);
				_myBodySkin2.dispose();
				_myBodySkin2 = null;
			}	
			if(_myBodySkin3 != null)
			{
				removeChild(_myBodySkin3);
				_myBodySkin3.dispose();
				_myBodySkin3 = null;
			}	
		}
		
		override public function activeSkillEffect(owner:ISkillOwner, state:SkillState):void
		{
			mySkillOwner = owner;
			mySkillState = state;
			this.x = 0;
			this.y = 0;
		}
		
		public function notifyDisappear():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,destorySelf);
			_myBodySkin1.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1);
			_myBodySkin2.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1);
			_myBodySkin3.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1);
		}
		
		override public function destorySelf():void
		{
			super.destorySelf();
		}
		
	}
}