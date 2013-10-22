package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;

	//陨石是没有目标的，是范围检测伤害，而且只伤害1个人
	public class AeroliteBulletEffect extends BasicBulletEffect
	{
		private var _aeroliteBufferParameters:Object;
		private var _range:int = 0;
		private var _vecTargets:Vector.<BasicOrganismElement>;
		
		public function AeroliteBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_aeroliteBufferParameters = {};
			_range = 0;
			_vecTargets = null;
		}
		
		public function setBufferParam(param:Object,range:int):void
		{
			_aeroliteBufferParameters = {};
			for(var i:* in param)
			{
				_aeroliteBufferParameters[i] = param[i];
			}	
			_range = range;
		}
		
		//到这里才算范围
		override protected function onBulletEffectEnd():void
		{
			_vecTargets = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, _range>0?_range:40, 
					FightElementCampType.ENEMY_CAMP,
					necessarySearchConditionFilter); 

			if(_vecTargets != null && _vecTargets.length > 0)		
				myTargetEnemy = _vecTargets[0];	
			else	
				myTargetEnemy = null;
			
			super.onBulletEffectEnd();
		}
		
		//这里只要找到 敌人了就算 打中      
		override protected function checkIsHurtedTargetEnemy():Boolean
		{
			return myTargetEnemy != null;
		}
		
		private function necessarySearchConditionFilter(taget:BasicOrganismElement):Boolean
		{
			return !taget.fightState.isFlyUnit;
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
		
			if(currentBehaviorState == BulletEffectBehaviorState.DISAPPEAR)
			{
				//消失放到地面
				sceneElementsModel.swapSceneElementLayerType(this, 
					GroundSceneElementLayerType.LAYER_BOTTOM);
			}
		}
		
		override protected function onHurtedTargetEnemy():void
		{
			//super.onHurtedTargetEnemy();
			if(_vecTargets && _vecTargets.length>0)
			{
				if(_range>0 && _vecTargets.length>1)
				{
					var bAddBuff:Boolean = true;
					for each(var target:BasicOrganismElement in _vecTargets)
					{
						effectEachTarget(target,bAddBuff);
						if(bAddBuff)
							bAddBuff = false;
					}
				}
				else
				{
					effectEachTarget(myTargetEnemy);
				}
			}
			
		}
		
		private function effectEachTarget(target:ISkillTarget,bAddBuff:Boolean = true):void
		{
			if(target.isAlive)
			{
				target.hurtSelf(myHurtValue, myAttackType, null,OrganismDieType.NORMAL_DIE,1,false);
				if(bAddBuff && _aeroliteBufferParameters && _aeroliteBufferParameters.hasOwnProperty(BufferFields.BUFF))
					target.notifyAttachBuffer(_aeroliteBufferParameters[BufferFields.BUFF],_aeroliteBufferParameters,null);
			}
		}
			
	}
}