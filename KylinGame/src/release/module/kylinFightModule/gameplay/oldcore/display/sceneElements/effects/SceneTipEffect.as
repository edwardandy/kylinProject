package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	
	import flash.events.MouseEvent;
	
	import framecore.tools.logger.log;

	/**
	 * 场景小特效，仅仅是展示 
	 * @author Administrator
	 * 
	 */	
	public final class SceneTipEffect extends BasicBodySkinSceneElement
	{
		public static const SCENE_TIPE_MISS:int = 24014;
		public static const SCENE_TIPE_BOOM:int = 24001;
		public static const SCENE_TIPE_BZZT:int = 24002;
		public static const SCENE_TIPE_ZAP:int = 24003;
		
		public static var _testtimes:uint = 0;
		
		public static function playSceneTipEffect(sceneTipTypeId:int, x:Number, y:Number):void
		{
			var sceneTipEffect:SceneTipEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.SCENE_TIP, sceneTipTypeId) as SceneTipEffect;
			sceneTipEffect.x = x;
			sceneTipEffect.y = y;
		}
		
		private var _disappearTime:SimpleCDTimer;
		private var _isTipPlayedEnd:Boolean = false;

		public function SceneTipEffect(typeId:int)
		{
			super();
			
			this.myElemeCategory = GameObjectCategoryType.SCENE_TIP;
			this.myObjectTypeId = typeId;
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_TOP;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			_disappearTime = new SimpleCDTimer(GameFightConstant.SCENE_TIP_DISAPPEAR_TIME);
			myBodySkin.y = -GameFightConstant.SCENE_TIP_HEIGHT;
//			myBodySkin.smoothing = true;
		}
		
		override public function update(iElapse:int):void
		{
			super.update(iElapse);
			/*if(_isTipPlayedEnd)
			{
				//_disappearTime.tick();
				if(_disappearTime.getIsCDEnd())
				{
					destorySelf();
				}
			}*/
		}
			
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);	
			if(_isTipPlayedEnd)
			{
				//_disappearTime.tick();
				if(_disappearTime.getIsCDEnd())
				{
					destorySelf();
				}
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_isTipPlayedEnd = false;
			_disappearTime.resetCDTime();
			myBodySkin.rotation = int(GameMathUtil.randomFromValues(GameFightConstant.SCENE_TIP_RANDOW_ROTATIONS));
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, tipEfectAnimationPlayEndHandler);
		}
		
		private function tipEfectAnimationPlayEndHandler():void
		{
			_isTipPlayedEnd = true;
		}
	}
}