package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.OrganismBodySizeType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	//自然之怒 表现为逆向移动的风，这里要单独处理下
	public class ZiRanZhiRuMagicSkill extends BasicMagicSkillEffect
	{
		private static const MOVE_SPEED:Number = 150;
		
		private var _currentCarryedEnemy:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>();
		
		private var _currentPathStepIndex:int = 0;
		private var _currentPathPoints:Vector.<PointVO> = null;
		private var _mySpeed:Number = GameMathUtil.secondSpeedToFrameMoveSpeed(MOVE_SPEED);
		private var _myAngle:Number = 0;//弧度
		private var _myRoadIndex:int = -1;
		
		private var _scale:Number = 1.0;
		
		private var _isBenifitFridendlyUintsLife:Boolean = false;
		private var _benifitLifePercent:Number = 0;
		private var  _hasBuffer1:Boolean = false;
		
		public function ZiRanZhiRuMagicSkill(typeId:int)
		{
			super(typeId);	
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
			_hasBuffer1 = myMagicLevel > 1;
			
			//if(myMagicSkillTemplateInfo.level>2)
			//{
			setScaleRatioType(OrganismBodySizeType.SIZE_MIDDLE);
			//}
			
			if(!myEffectParameters)
				return;
			_isBenifitFridendlyUintsLife = myEffectParameters.maxLifeRecover!=null;
			if(_isBenifitFridendlyUintsLife)
			{
				_benifitLifePercent = myEffectParameters.maxLifeRecover / 100;
			}
		}
		
		//这里的运动是反向运动
		public function startEscapeByPath(roadIndex:int, roadPathPoints:Vector.<PointVO>, roadPathStepIndex:int):void
		{
			if(roadPathPoints == null || roadPathPoints.length == 0 ||
				roadPathStepIndex < 0 || roadPathStepIndex > roadPathPoints.length - 1) return;
			
			_myRoadIndex = roadIndex;
			_currentPathPoints = roadPathPoints;
			_currentPathStepIndex = roadPathStepIndex;
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					else
					{
						onRenderPosition();

						onRenderAndEffectEnemy();
					}
					break;
			}
			
			super.render(iElapse);
		}

		private function onRenderAndEffectEnemy():void
		{
			var enemys:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					GameFightConstant.ROAD_HALF_WIDTH, 
					FightElementCampType.ENEMY_CAMP,
					necessarySearchConditionFilter);
			
			var n:uint = enemys.length;
			for(var i:uint = 0; i < n; i++)
			{
				var enemy:BasicOrganismElement = enemys[i];
				enemy.enforceDisappear();
				_currentCarryedEnemy.push(enemy);
			}
		}
		
		//释放时对敌人造成伤害
		private function releaseCarryedEnemys():void
		{
			const arrDmg:Array = (myMagicSkillTemplateInfo.objEffect[SkillResultTyps.DMG] as String).split("-");
			var isNeedHurt:Boolean = arrDmg[0] > 0 && arrDmg[1] > 0;
			var hurtValue:uint = isNeedHurt ? 
					GameMathUtil.randomUintBetween(arrDmg[0], arrDmg[1]) : 0;
			
			while(_currentCarryedEnemy.length)
			{
				var enemy:BasicOrganismElement = _currentCarryedEnemy.pop();
				if(enemy is BasicMonsterElement)
				{
					BasicMonsterElement(enemy).setAppearRoadPathStepIndex(_currentPathStepIndex + 1);
				}
				
				enemy.enforceAppear(new PointVO(this.x+int(Math.random()*40-20), this.y+int(Math.random()*40-20)), isNeedHurt, hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, false);
				if(myBuffer2Parameters)
					enemy.notifyAttachBuffer(myBuffer2Parameters.buff, myBuffer2Parameters,null);
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			if(myMagicLevel>4)
			{
				myBodySkin.scaleX = myBodySkin.scaleY = 0.7;
			}
			else if(myMagicLevel>2)
			{
				myBodySkin.scaleX = myBodySkin.scaleY = 0.6;
			}
			else
			{
				myBodySkin.scaleX = myBodySkin.scaleY = 0.5;
			}
			
			_myAngle = 0;
			_currentCarryedEnemy.length = 0;
			myMagicSkillCDTimer.resetCDTime();
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
			
			//所有友方单位攻速buffer, 和恢复生命
			if(_isBenifitFridendlyUintsLife || _hasBuffer1)
			{
				effectAllFriendlyUintTargetsWhenActivate();	
			}
		}
		
		private function effectAllFriendlyUintTargetsWhenActivate():void
		{
			var friendlyTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					-1, 
					FightElementCampType.FRIENDLY_CAMP);
			
			for each(var target:BasicOrganismElement in friendlyTargets)
			{
				if(_isBenifitFridendlyUintsLife)
				{
					target.benefitBlood2(_benifitLifePercent);
				}
				
				if(_hasBuffer1)
				{
					target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);
				}
			}
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged()
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
							myBodySkinAppearAnimationEndHandler);
					break;
				
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					break;
				
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
							myBodySkinDisAppearAnimationEndHandler);
					break;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_currentCarryedEnemy = null;
			_currentPathPoints = null;
		}
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		private function onRenderPosition():void
		{
			if(_mySpeed <= 0 ||
				_currentPathPoints == null || 
				_currentPathPoints.length == 0) return;
			
			var targetPathPoint:PointVO = _currentPathPoints[_currentPathStepIndex];
			var distance:Number = GameMathUtil.distance(targetPathPoint.x, targetPathPoint.y, this.x, this.y);
			
			if(/*GameMathUtil.containsPointInEllipseSearchArea(targetPathPoint.x, targetPathPoint.y,_mySpeed,this.x, this.y)*/distance < _mySpeed)
			{
				_currentPathStepIndex--;
				
				if(_currentPathStepIndex <= 0)
				{
					this.x = targetPathPoint.x;
					this.y = targetPathPoint.y;
					onArrivedEndPoint();
				}
			}
			else
			{
				_myAngle = GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, targetPathPoint.x, targetPathPoint.y);
				this.x += _mySpeed * Math.cos(_myAngle);
				this.y += _mySpeed * Math.sin(_myAngle);
			}
		}
		
		private function onArrivedEndPoint():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
		}
		
		private function myBodySkinDisAppearAnimationEndHandler():void
		{
			releaseCarryedEnemys();
			
			destorySelf();
		}
		
		//search 
		override protected function necessarySearchConditionFilter(element:BasicOrganismElement):Boolean
		{
			return !element.isBoss && BasicMonsterElement(element).escapeRoadIndex == _myRoadIndex 
				&&  _currentCarryedEnemy.indexOf(element) == -1 && super.necessarySearchConditionFilter(element);
		}
	}
}