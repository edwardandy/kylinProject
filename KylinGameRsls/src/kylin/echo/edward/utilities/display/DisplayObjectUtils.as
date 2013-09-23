package kylin.echo.edward.utilities.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedSuperclassName;

	public class DisplayObjectUtils
	{
		private static var _instance:DisplayObjectUtils;
		
		public function DisplayObjectUtils()
		{
			
		}
		
		public static function get instance():DisplayObjectUtils
		{
			return _instance ||= new DisplayObjectUtils;
		}
		
		public function removeAllChildren(dis:DisplayObjectContainer):void{
			while(dis.numChildren > 0){
				dis.removeChildAt(0);
			}
		}
		
		/**
		 *  map the container's child to the cls's child which have the same name
		 * @param container
		 * @param cls
		 * 
		 */		
		public function mapSymbol(skin:DisplayObjectContainer,cls:DisplayObject):void{
			var xml:XML = describeType(cls);
			var list:Dictionary = new Dictionary(true);
			getChildrenList(skin,list);
			var variables:XMLList = xml.variable;
			for each(var item:XML in variables)	{
				var name:String = item.@name.toString();
				var type:String = item.@type.toString();
				var propClass:Class = getDefinitionByName(type) as Class;
				if(((list[name] is propClass) || (getQualifiedSuperclassName(list[name]) is propClass))   && cls.hasOwnProperty(name)){
					cls[name] = list[name];
				}
			}
		}
		
		/**
		 * collect all the children of the container
		 * @param container
		 * @param list
		 * 
		 */		
		public function getChildrenList(container:DisplayObjectContainer,list:Dictionary):void{
			if(container == null) return;
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var o:DisplayObject = container.getChildAt(i);
				if (o is DisplayObjectContainer)
				{
					getChildrenList((o as DisplayObjectContainer), list);
					list[o.name] = o;
				}else{
					list[o.name] = o;
					if(o is TextField){
						(o as TextField).selectable = false;
					}
				}			
			}
		}
		
		/**
		 * collect child which type is searchType.  
		 * @param container
		 * @param searchType
		 * @return 
		 * 
		 */		
		public function searchChild(container:DisplayObjectContainer, searchType:Class):Array
		{
			
			var temp:Array = [];
			
			var i:int = 0;
			var c:int = container.numChildren;
			while (i < c) 
			{
				
				var child:DisplayObject = container.getChildAt(i);
//				trace(child.name);
				if (child is searchType)
				{
					temp.push(child);
				}
				if (child is DisplayObjectContainer)
				{
					temp = temp.concat(searchChild(child as DisplayObjectContainer, searchType));
				}
				
				i++;
			}
			
			return temp;		
		}
		
		
		//等比例缩放
		public function getScale(content_sp:DisplayObject,theWidth:Number,theHeight:Number,isAlways:Boolean=true):Number
		{
			if(content_sp.width < theWidth && content_sp.height < theHeight && isAlways)
			{
				return 1;
			}
			content_sp.width = theWidth;
			content_sp.height = theHeight;
			var minscale:Number = Math.min(content_sp.scaleX, content_sp.scaleY);
			if(isAlways){
				minscale = Math.min(minscale, 1); 
			}
			return minscale;
		}
		
		public function fillRectSprite(spt:Sprite,width:int,height:int,color:uint = 0x000000,alpha:Number = 1.0):void
		{
			if(!spt)
				return;
			spt.graphics.clear();
			spt.graphics.beginFill(color,alpha);
			spt.graphics.drawRect(0,0,width,height);
			spt.graphics.endFill();
		}
	}
}