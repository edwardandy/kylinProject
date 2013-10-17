package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import flash.events.MouseEvent;

	public interface IMouseCursorSponsor
	{
		function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void;
		function notifyTargetMouseCursorCanceled():void;
	}
}