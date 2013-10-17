package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.IceMagicWandGroundEff;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.utils.getTimer;
	
	import framecore.structure.model.constdata.GameConst;
	
	import io.smash.time.TimeManager;

	public class FullScreenFreezeEnemy extends BasicMagicSkillEffect
	{
		private var _arrCoord:Array;
		private var _vecEffs:Vector.<IceMagicWandGroundEff> = new Vector.<IceMagicWandGroundEff>;
		private var _tickStart:int;
		private var _arrEffId:Array;
		private var _freezeCd:SimpleCDTimer = new SimpleCDTimer;
		
		
		public function FullScreenFreezeEnemy(typeId:int)
		{
			super(typeId);
			
			_arrEffId = (myEffectParameters["groundEffect"] as String).split("-");
			_freezeCd.setDurationTime(myBuffer1Parameters[BufferFields.DURATION]);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			_tickStart = 0;
			_arrCoord = [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]];
			_vecEffs.length = 0;
			
			this.x = GameFightConstant.SCENE_MAP_WIDTH>>1;
			this.y = GameFightConstant.SCENE_MAP_HEIGHT>>1;
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1,onAppearEnd);
					break;
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1);
					break;
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
					onFirePoint();
					_freezeCd.resetCDTime();
					break;
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			var curTick:uint = TimeManager.instance.virtualTime;
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
				case MagicSkillEffectBehaviorState.RUNNING:
				{
					if(_arrCoord.length>0)
					{
						_tickStart ||= curTick;
						if(curTick - _tickStart >= 100)
						{
							_tickStart = curTick;
							var idx:int = GameMathUtil.randomUintBetween(0,_arrCoord.length-1);
							var pt:PointVO = getPointToShowEff(_arrCoord[idx]);
							_arrCoord.splice(idx,1);
							var effId:uint = uint(GameMathUtil.randomFromValues(_arrEffId));
							_vecEffs.push((ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.GROUNDEFFECT,effId,false) as IceMagicWandGroundEff));
							_vecEffs[_vecEffs.length-1].x = pt.x;
							_vecEffs[_vecEffs.length-1].y = pt.y;
							_vecEffs[_vecEffs.length-1].notifyLifecycleActive();
						}
						return;
					}
					
					if(MagicSkillEffectBehaviorState.RUNNING == currentBehaviorState)
					{
						if(_freezeCd.getIsCDEnd())
						{
							changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
							_tickStart = 0;
						}
					}
				}
					break;
				case MagicSkillEffectBehaviorState.DISAPPEAR:
				{
					if(0 == _vecEffs.length)
					{
						destorySelf();
						return;
					}
					_tickStart ||= curTick;
					if(curTick - _tickStart >= 100)
					{
						_tickStart = curTick;
						_vecEffs.pop().disappear();
					}
				}
					break;
			}
		}
		
		private function getPointToShowEff(arr:Array):PointVO
		{
			var pt:PointVO = new PointVO;
			pt.x = GameMathUtil.randomUintBetween(GameFightConstant.SCENE_MAP_WIDTH/3*arr[1],GameFightConstant.SCENE_MAP_WIDTH/3*(arr[1]+1));
			pt.y = GameMathUtil.randomUintBetween(GameFightConstant.SCENE_MAP_HEIGHT/3*arr[0],GameFightConstant.SCENE_MAP_HEIGHT/3*(arr[0]+1));
			return pt;
		}
		
		private function onAppearEnd():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		private function onFirePoint():void
		{
			var targets:Vector.<BasicMonsterElement> = GameAGlobalManager.getInstance()
				.groundSceneHelper.getAllAliveEnemys();
			
			for each(var enemy:BasicMonsterElement in targets)
			{
				if(myBuffer1Parameters)
				{
					enemy.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);
				}
			}
		}
	}
}