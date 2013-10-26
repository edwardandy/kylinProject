package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	
	/**
	 * 地精避雷针
	 */
	public class GoblinThunderMagicSkill extends BasicMagicSkillEffect
	{
		private var _minAtk:int;
		private var _maxAtk:int;
		private var _bFire:Boolean;
		
		public function GoblinThunderMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			
			if(!myEffectParameters)
				return;
			var strDmg:String = myEffectParameters[SkillResultTyps.DMG];
			var arr:Array = strDmg.split("-");
			_minAtk = arr[0];
			_maxAtk = arr[1];
		}
		
		override public function setMonomerMagicTarget(target:BasicOrganismElement):void
		{
			super.setMonomerMagicTarget(target);
			
			synchronousMonomerMagicPosition();
		}
		
		private function synchronousMonomerMagicPosition():void
		{
			if(myMonomerMagicTarget != null)
			{
				this.x = myMonomerMagicTarget.x;
				this.y = myMonomerMagicTarget.y+myMonomerMagicTarget.height;
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myBodySkin.y = -myMonomerMagicTarget.bodyHeight;
			_bFire = myBodySkin.hasFrameName(GameMovieClipFrameNameType.FIRE_POINT);
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				myBodySkinAnimationEndHandler,_bFire?GameMovieClipFrameNameType.FIRE_POINT:null,_bFire?onFire:null);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			synchronousMonomerMagicPosition();
		}
		
		private function onFire():void
		{
			hurtTarget();
		}
		
		private function myBodySkinAnimationEndHandler():void
		{
			if(!_bFire && myMonomerMagicTarget != null && myMonomerMagicTarget.isAlive)
				hurtTarget();
			
			destorySelf();
		}
		
		private function hurtTarget():void
		{
			var hurtValue:uint = GameMathUtil.randomUintBetween(_minAtk, _maxAtk);
			myMonomerMagicTarget.hurtBlood(hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, true,null,false,OrganismDieType.LIGHTTING_DIE);
			
			if(myBuffer1Parameters)//眩晕buff
				myMonomerMagicTarget.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters, null);
			if(myBuffer2Parameters)
				myMonomerMagicTarget.notifyAttachBuffer(myBuffer2Parameters.buff, myBuffer2Parameters, null);
			
			if(myEffectParameters && myEffectParameters.hasOwnProperty(SkillResultTyps.ADD_GROUND_EFF))
			{
				var result:BasicSkillResult = skillResultMgr.getSkillResultById(SkillResultTyps.ADD_GROUND_EFF);
				result.effect(myEffectParameters,myMonomerMagicTarget,myMonomerMagicTarget);
			}
			
			if(myMagicSkillTemplateInfo.range>0)
			{
				effectRangeEnemys();
			}
		}
		
		private function effectRangeEnemys():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			const arrDmg:Array = (myMagicSkillTemplateInfo.objEffect[SkillResultTyps.DMG] as String).split("-");
			var hurtValue:uint = GameMathUtil.randomUintBetween(arrDmg[0], arrDmg[1]);
			var result:BasicSkillResult;
			if(myEffectParameters && myEffectParameters.hasOwnProperty(SkillResultTyps.DMG))
			{
				result = skillResultMgr.getSkillResultById(SkillResultTyps.DMG);
			}
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				
				if(result)
				{
					result.effect(myEffectParameters,target,null);
				}
				
				//target.hurtBlood(hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, true,null,false,OrganismDieType.LIGHTTING_DIE);
				
				if(target.isAlive && myBuffer3Parameters)
					target.notifyAttachBuffer(myBuffer3Parameters.buff, myBuffer3Parameters, null);
			}
		}
		
		override protected function necessarySearchConditionFilter(element:BasicOrganismElement):Boolean
		{
			return (element!=myMonomerMagicTarget) && super.necessarySearchConditionFilter(element);
		}
		
		override protected function get myMagicLevel():int
		{
			return _myMagicLevel;
		}
	}
}