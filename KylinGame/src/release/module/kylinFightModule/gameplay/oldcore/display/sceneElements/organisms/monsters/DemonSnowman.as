package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.OrganismBodySizeType;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	public class DemonSnowman extends BasicMonsterElement
	{
		private var _bStoped:Boolean = false;
		
		private var _xScale:Number = 0.25;
		
		public function DemonSnowman(typeId:int)
		{
			super(typeId);
			setScaleRatioType(OrganismBodySizeType.SIZE_BIG);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_bStoped = false;
			_xScale = 0.25;
			myBodySkin.scaleX = 0.25;
			myBodySkin.scaleY = 0.25;
			bloodBarY = -bodyHeight-10;
		}
		
		override public function render(iElapse:int):void
		{
			if(!_bStoped && !myFightState.bMaxSnowball)
			{
				if(myBodySkin.scaleY<0.5)
				{
					_xScale += 0.00083;
					//xScale可能会反转正负	
					myBodySkin.scaleX = myBodySkin.scaleX>0?_xScale:(-1*_xScale);
					myBodySkin.scaleY += 0.00083;
				}
			}
			bloodBarY = -bodyHeight;
			super.render(iElapse);
		}
		
		override public function notifyBeBlockedByEnemy(target:BasicOrganismElement):void
		{
			if(!myFightState.bMaxSnowball)
			{
				_bStoped = true;
				notifyDettachBuffer(BufferID.SnowMax);
			}
			else
				return;
			if(_bStoped)
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,GameMovieClipFrameNameType.APPEAR
					+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1);
			}
			super.notifyBeBlockedByEnemy(target);
		}
		
		override protected function getUpWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.WALK;
		}
		
		override protected function getDownWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.WALK;
		}
		
		override protected function getDyingAnimationFrameKeyByDieType(dieType:int):String
		{
			if(_bStoped)
				return GameMovieClipFrameNameType.NORMAL_DIE;
			else
				return GameMovieClipFrameNameType.NORMAL_DIE_1;
		}
		
		override protected function fireToTargetEnemy():void
		{
			if(_bStoped)
				super.fireToTargetEnemy();
			else
				onFireAnimationTimeHandler();
		}
		
		override public function notifyMoving(oldX:Number,oldY:Number):void
		{
			if(!myFightState.bMaxSnowball || myFightState.bStun || myFightState.bSheep)
				return;
			var vecTargets:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance().groundSceneHelper
				.searchOrganismElementsBySearchArea(this.x, this.y, 40,oppositeCampType, searchCanSuddenDeathEnemy);
			if(vecTargets && vecTargets.length>0)
			{
				for each(var target:BasicOrganismElement in vecTargets)
				{
					target.hurtBlood(0,FightAttackType.PHYSICAL_ATTACK_TYPE,false,this,true);
				}
			}
		}
		
		private function searchCanSuddenDeathEnemy(e:BasicOrganismElement):Boolean
		{
			return !e.isHero;
		}
		
		override public function canBeProvoked(owner:ISkillOwner):Boolean
		{
			if(myFightState.bMaxSnowball)
				return false;
			return super.canBeProvoked(owner);
		}
		
		override public function canBetray():Boolean
		{
			if(myFightState.bMaxSnowball)
				return false;
			return super.canBetray();
		}
		
		override public function SnowballMax(atk:int,owner:ISkillOwner):Boolean
		{
			if(_bStoped)
				return false;
			myFightState.minAtk += atk;
			myFightState.maxAtk += atk;
			myFightState.bMaxSnowball = true;
			this.filters = [GameFilterManager.getInstance().blueGlowFilter];
			return true;
		}
	}
}