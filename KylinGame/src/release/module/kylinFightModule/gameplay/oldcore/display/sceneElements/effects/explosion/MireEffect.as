package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.explosion
{
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BulletEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	/**
	 * 油潭
	 */
	public class MireEffect extends ExplosionEffect
	{
		private var _stayCDTimer:SimpleCDTimer;
		
		public function MireEffect(typeId:int)
		{
			super(typeId);
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_stayCDTimer = new SimpleCDTimer(5000);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			clearAllEffSoldiers();
		}
		
		override protected function onStartEffect():void
		{
			changeToTargetBehaviorState(BulletEffectBehaviorState.APPEAR);
		}
		
		private function onAppearEnd():void
		{
			_stayCDTimer.resetCDTime();
			changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case BulletEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, onAppearEnd);
					break;
				case BulletEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					break;	
				case BulletEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, destorySelf);
					break;
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			if(currentBehaviorState == BulletEffectBehaviorState.RUNNING)
			{
				//_stayCDTimer.tick();
				if(_stayCDTimer.getIsCDEnd())
				{
					changeToTargetBehaviorState(BulletEffectBehaviorState.DISAPPEAR);
					return;
				}
				
				onHurtEmemyWhenPerRender();	
			}
		}
		
		private var _vecEffSoldier:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>;
		private function onHurtEmemyWhenPerRender():void
		{
			var vecSoldier:Vector.<BasicOrganismElement> = sceneElementsService.
				searchOrganismElementsBySearchArea(this.x,this.y,50,FightElementCampType.ENEMY_CAMP,necessarySearchConditionFilter);
			if(!vecSoldier || 0 == vecSoldier.length)
			{
				clearAllEffSoldiers();
				return;
			}
			var soldier:BasicOrganismElement;
			for each(soldier in _vecEffSoldier)
			{
				if(vecSoldier.indexOf(soldier) == -1 && soldier.hasBuffer(BufferID.MireSlow))
				{
					
					soldier.notifyDettachBuffer(BufferID.MireSlow);
					//soldier.changeMoveSpeed(50,myHurtEffectFirer);
				}
			}
			if(vecSoldier && vecSoldier.length>0)
			{
				for each(soldier in vecSoldier)
				{
					if(_vecEffSoldier.indexOf(soldier) == -1 && !soldier.hasBuffer(BufferID.MireSlow))
					{
						var param:Object = {};
						param[BufferFields.BUFF] = BufferID.MireSlow;
						param[BufferFields.DURATION] = 0;
						param[SkillResultTyps.MOVE_SPEED_PCT] = -50;
						soldier.notifyAttachBuffer(BufferID.MireSlow,param,myHurtEffectFirer);
					}
						//soldier.changeMoveSpeed(-50,myHurtEffectFirer);
				}
			}
			_vecEffSoldier = vecSoldier;
			
		}
		
		private function clearAllEffSoldiers():void
		{
			for each(var soldier:BasicOrganismElement in _vecEffSoldier)
			{
				if(soldier.hasBuffer(BufferID.MireSlow))
					soldier.notifyDettachBuffer(BufferID.MireSlow);
				//soldier.changeMoveSpeed(50,myHurtEffectFirer);
			}
			_vecEffSoldier.length = 0;
		}
	}
}