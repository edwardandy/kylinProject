package utili.behavior.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public interface IBehavior extends IDispose
	{
		function init(panel:Sprite, cb:Function = null):void;
	}
}