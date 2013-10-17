package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.core.datastructures.HashMap;
	import com.shinezone.towerDefense.fight.constants.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.utils.Dictionary;

	/**
	 * 致命手里剑
	 */
	public class DeadlyShurikenBullet extends ArrowBulletEffect
	{
		private var _transferTimes:int = 0;
		private var _totleTimes:int = 0;
		private var _range:int = 0;
		private var _arrTargets:HashMap = new HashMap;
		public function DeadlyShurikenBullet(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();	
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_transferTimes = 0;
			_totleTimes = 0;
			_range = 0;
			_arrTargets.clear();
		}
		
		public function initShurikenParam(times:int,range:int):void
		{
			_totleTimes = times;
			_range = range;
		}
		
		override public function fire(targetEnemy:ISkillTarget, bulletFirer:ISkillOwner, firePoint:PointVO, hurtValue:uint, trajectoryParameters:Object=null, emphasizeBulletFallPointPoint:PointVO=null, skillState:SkillState=null):void
		{
			if(_arrTargets.get(targetEnemy) != null)
				_arrTargets.put(targetEnemy,_arrTargets.get(targetEnemy)+1);
			else
				_arrTargets.put(targetEnemy,1);
			_transferTimes++;
			super.fire(targetEnemy,bulletFirer,firePoint,hurtValue,trajectoryParameters,emphasizeBulletFallPointPoint,skillState);
		}
		
		override protected function processTransfer():Boolean
		{
			if(_transferTimes >= _totleTimes)
				return false;
			var vecTarget:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance().groundSceneHelper
				.searchOrganismElementsBySearchArea(this.x, this.y, _range, myHurtEffectFirer.oppositeCampType, SearchConditionFilter);
			if(!vecTarget || vecTarget.length<=0)
				return false;
			var minTimes:int = 10000;
			var fireTarget:BasicOrganismElement;
			for each(var target:BasicOrganismElement in vecTarget)
			{
				if(!_arrTargets.containsKey(target))
				{
					fireTarget = target;
					break;
				}
				if(_arrTargets.get(target) < minTimes)
				{
					fireTarget = target;
					minTimes = _arrTargets.get(target);
				}
			}
			if(!fireTarget)
				return false;
			
			this.fire(fireTarget,myHurtEffectFirer,new PointVO(this.x,this.y),myHurtValue);
			return true;
		}
		
		private function SearchConditionFilter(target:BasicOrganismElement):Boolean
		{
			return target != myTargetEnemy;
		}
		
		override protected function onHurtedTargetEnemy():void
		{
			var dmg:int = myHurtValue* (100 - (_transferTimes-1)/_totleTimes*100)/100;
			myTargetEnemy.hurtSelf(dmg,myAttackType,myHurtEffectFirer,OrganismDieType.NORMAL_DIE,1,null == mySkillState);
		}
	}
}