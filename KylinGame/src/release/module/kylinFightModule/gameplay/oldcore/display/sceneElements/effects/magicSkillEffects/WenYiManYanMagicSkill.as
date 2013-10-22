package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;

	public class WenYiManYanMagicSkill extends BasicMagicSkillEffect
	{
		public function WenYiManYanMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		override public function setMonomerMagicTarget(target:BasicOrganismElement):void
		{
			super.setMonomerMagicTarget(target);
			
			synchronousMonomerMagicPosition();
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myBodySkin.y = -myMonomerMagicTarget.bodyHeight;
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				myBodySkinAnimationEndHandler, 
				GameMovieClipFrameNameType.FIRE_POINT, myBodySkinAnimationFireTimeHandler);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);

			synchronousMonomerMagicPosition();
		}
		
		private function synchronousMonomerMagicPosition():void
		{
			if(myMonomerMagicTarget != null)
			{
				this.x = myMonomerMagicTarget.x;
				this.y = myMonomerMagicTarget.y;
			}
		}
		
		private function myBodySkinAnimationFireTimeHandler():void
		{
			if(myMonomerMagicTarget != null && myMonomerMagicTarget.isAlive)
			{
				//这里添加瘟疫buffer
				//myMonomerMagicTarget.attachSkillBuffer(myBuffer1Parameters.buff, myBuffer1Parameters);
				myMonomerMagicTarget.notifyAttachBuffer(myBuffer1Parameters.buff,myBuffer1Parameters,null);
				
				if(myMagicLevel == 6)
				{
					//这里还有15%，定身buffer
					//if(GameMathUtil.randomTrueByProbability(0.15))
					
					myMonomerMagicTarget.notifyAttachBuffer(myBuffer2Parameters.buff, myBuffer2Parameters,null);
					
				}
			}
		}
		
		private function myBodySkinAnimationEndHandler():void
		{
			destorySelf();
		}
	}
}