package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import flash.filters.ColorMatrixFilter;
	
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.NuclareWeaponEff;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public class FullScreenKillMonster extends BasicMagicSkillEffect
	{
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		
		private var _arrCoord:Array;
		private var _tickStart:int;
		private var _redFilter:ColorMatrixFilter = new ColorMatrixFilter;
		private var _redMatrix:Array;
		private var _redParam:Number = 0;
		private var _redDelta:Number = 0;
		
		public function FullScreenKillMonster(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_tickStart = 0;
			_arrCoord = [[0,0],[0,1],[0,2],[1,0],[1,2],[2,0],[2,1],[2,2]];
			_redMatrix = [
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0
			];
			_redFilter.matrix = _redMatrix;
			_redParam = 0;
			_redDelta = 0;
			
			this.x = GameFightConstant.SCENE_MAP_WIDTH>>1;
			this.y = GameFightConstant.SCENE_MAP_HEIGHT>>1;
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				onAppearEnd,GameMovieClipFrameNameType.FIRE_POINT,onFirePoint);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			fightViewModel.groundLayer.filters = null;
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			var curTick:uint = timeMgr.virtualTime;
			if(MagicSkillEffectBehaviorState.APPEAR == currentBehaviorState)
			{
				updateRedMatrix(_redParam + 5);
			}
			else if(MagicSkillEffectBehaviorState.RUNNING == currentBehaviorState)
			{
				if(0 == _redDelta)
				{
					var iTotal:int = myBodySkin.totalFrames();
					var iFire:int = myBodySkin.getFrameByName(GameMovieClipFrameNameType.FIRE_POINT);
					var iFrames:int = iTotal - iFire;
					_redDelta = _redParam/iFrames;
					
				}
				if(_redParam>0)
					updateRedMatrix(_redParam - _redDelta);
			}
			
			if(_arrCoord.length>0)
			{
				_tickStart ||= curTick;
				if(curTick - _tickStart >= 100)
				{
					_tickStart = curTick;
					var idx:int = GameMathUtil.randomUintBetween(0,_arrCoord.length-1);
					var pt:PointVO = getPointToShowEff(_arrCoord[idx]);
					_arrCoord.splice(idx,1);
					var eff:NuclareWeaponEff = objPoolMgr.createSceneElementObject(GameObjectCategoryType.SKILLRES
						,myEffectParameters["special"],false) as NuclareWeaponEff;
					eff.x = pt.x;
					eff.y = pt.y;
					eff.notifyLifecycleActive();
				}
				return;
			}
			
			if(MagicSkillEffectBehaviorState.DISAPPEAR == currentBehaviorState)
				destorySelf();
		}
		
		private function onFirePoint():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
			
			var targets:Vector.<BasicMonsterElement> = sceneElementsService.getAllAliveEnemys();
			var arrHurtBoss:Array = (myEffectParameters["bossHurt"] as String).split("-");
			var hurtBossPct:int = GameMathUtil.randomUintBetween(arrHurtBoss[0],arrHurtBoss[1]);
			
			for each(var enemy:BasicMonsterElement in targets)
			{
				if(enemy.isBoss)
				{
					enemy.hurtSelf(enemy.maxLife*hurtBossPct/100,FightAttackType.MAGIC_ATTACK_TYPE,null,OrganismDieType.FIRE_EXPLODE_DIE,1,false);
				}
				else
				{
					enemy.hurtBlood(0,FightAttackType.MAGIC_ATTACK_TYPE,true,null,true,OrganismDieType.FIRE_EXPLODE_DIE,1,true);
				}
			}
			
			sceneElementsService.disappearAllSummonDoor();
		}
		
		private function onAppearEnd():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
		}
		
		private function getPointToShowEff(arr:Array):PointVO
		{
			var pt:PointVO = new PointVO;
			pt.x = GameMathUtil.randomUintBetween(GameFightConstant.SCENE_MAP_WIDTH/3*arr[1],GameFightConstant.SCENE_MAP_WIDTH/3*(arr[1]+1));
			pt.y = GameMathUtil.randomUintBetween(GameFightConstant.SCENE_MAP_HEIGHT/3*arr[0],GameFightConstant.SCENE_MAP_HEIGHT/3*(arr[0]+1));
			return pt;
		}
		
		private function updateRedMatrix(red:Number):void
		{
			_redParam = red;
			_redMatrix[4] = _redParam;
			_redFilter.matrix = _redMatrix;
			fightViewModel.groundLayer.filters = [_redFilter];
		}
	}
}