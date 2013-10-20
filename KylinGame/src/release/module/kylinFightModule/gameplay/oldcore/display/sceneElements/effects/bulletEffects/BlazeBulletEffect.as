package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	//喷火，需要缩放
	public class BlazeBulletEffect extends BasicBulletEffect
	{
		protected var myBodySkin2:NewBitmapMovieClip;
		
		public function BlazeBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function createBodySkin():void
		{		
			//will stop inner default
			//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(bodySkinResourceURL+"_1", myScaleRatioType);
			//if(vecFrames)
			{
				myBodySkin2 = new NewBitmapMovieClip([bodySkinResourceURL+"_1"],[myScaleRatioType]);
				injector.injectInto(myBodySkin2);
				addChild(myBodySkin2);
			}	
			super.createBodySkin();
		}
		
		override protected function onRenderBulletEffect():void
		{
			super.onRenderBulletEffect();
			
			this.myBodySkin.scaleX = this.myBodySkin.scaleY = 0.5 + myBulletEffectProgress;
			this.myBodySkin2.scaleX = this.myBodySkin2.scaleY = 0.5 + myBulletEffectProgress;
		}
		
		override protected function onBehaviorChangedToRunning():void
		{
			var arrIdx:Array = [1,2,3,4,5,6];
			var idx:int = GameMathUtil.randomFromValues(arrIdx) as int;
			myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE+"_"+idx);
			idx = GameMathUtil.randomFromValues(arrIdx) as int;
			myBodySkin2.gotoAndStop2(GameMovieClipFrameNameType.IDLE+"_"+idx);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			if(myBodySkin2)
				myBodySkin2.render(iElapse);
		}
	}
}