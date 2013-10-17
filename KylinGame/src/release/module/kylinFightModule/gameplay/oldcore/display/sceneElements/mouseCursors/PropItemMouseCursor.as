package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices.PropItemMouseCursorReleaseLogic;
	
	import framecore.structure.model.user.item.ItemTemplateInfo;

	public class PropItemMouseCursor extends BasicMouseCursor
	{
		protected var myItemTemplateInfo:ItemTemplateInfo;
		
		public function PropItemMouseCursor()
		{
			super();
		}
		
		//API
		public function setItemTemplateInfo(value:ItemTemplateInfo):void
		{
			myItemTemplateInfo = value;
		}
		
		override protected function onInitialize():void
		{
			myValideMouseCursorView = new FFF();
			myErrorMouseCursorView = new BB();

			super.onInitialize();
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			PropItemMouseCursorReleaseLogic.getInstance()
				.excute(mouseCursorReleaseValidateResult, myCurrentValidMouseClickEvent, myItemTemplateInfo);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myItemTemplateInfo = null;
		}
	}
}