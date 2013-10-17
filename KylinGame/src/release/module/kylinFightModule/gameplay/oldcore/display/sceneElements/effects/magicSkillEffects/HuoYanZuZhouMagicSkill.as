package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;

	public class HuoYanZuZhouMagicSkill extends BasicMagicSkillEffect
	{
		private var _hasBuffer2:Boolean = false;
		private var _hasBuffer3:Boolean = false;
		
		public function HuoYanZuZhouMagicSkill(typeId:int)
		{
			super(typeId);
			
			_hasBuffer2 = myMagicLevel >= 4;
			_hasBuffer3 = myMagicLevel >= 5;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				myBodySkinAnimationEndHandler, 
				GameMovieClipFrameNameType.FIRE_POINT, myBodySkinAnimationFireTimeHandler)
		}
		
		private function myBodySkinAnimationFireTimeHandler():void
		{
			//这里释放火焰诅咒
			var targets:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);

			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				
				target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);
				
				if(_hasBuffer2)
				{
					target.notifyAttachBuffer(myBuffer2Parameters.buff, myBuffer2Parameters,null);
				}
				
				if(_hasBuffer3)
				{
					target.notifyAttachBuffer(myBuffer3Parameters.buff, myBuffer3Parameters,null);
				}
			}
		}
		
		private function myBodySkinAnimationEndHandler():void
		{
			destorySelf();
		}
	}
}