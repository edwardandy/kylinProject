package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	

	public class RangeMagicMouseCursor extends MonomerMagicMouseCursor
	{
		public function RangeMagicMouseCursor()
		{
			super();
		}
		
		override public function notifyIsActive(isActive:Boolean):void
		{
			super.notifyIsActive(isActive);
			
			if(!isActive)
			{
				myValideMouseCursorView.scaleX = 1;
				myValideMouseCursorView.scaleY = 1;
			}
		}
		
		override public function setMagicSkillTemplateInfo(value:IMagicSkillSheetItem):void
		{
			super.setMagicSkillTemplateInfo(value);
			
			if(magicSkillTemplateInfo != null && magicSkillTemplateInfo.range > myValideMouseCursorView.width)
			{
				scaleValideMouseCursorViewToSize(magicSkillTemplateInfo.range);
			}
		}
		
		protected final function scaleValideMouseCursorViewToSize(size:Number):void
		{
			myValideMouseCursorView.scaleX = myValideMouseCursorView.scaleY = size / myValideMouseCursorView.width;
		}
	}
}