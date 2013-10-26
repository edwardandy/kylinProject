package kylin.echo.edward.utilities
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author lijie
	 */
	public class Reflection 
	{
		
		/**
		 * 
		 */
		public static function createMovieClipSkin(name:String , x:int , y:int , parent:Sprite = null):MovieClip
		{
			var skin:MovieClip = Reflection.createMovieClip(name) as MovieClip; 
			if(skin == null )  return null;
			skin.x = x; 
			skin.y = y; 
			if(parent != null)	parent.addChild(skin);
			return skin;
		}

		
		/**
		 * 创建一个可显示对像
		 * @param fullClassName 元件的可连接名
		 * @param applicationDomain 元件所在的应用域
		 * @return DisplayObject 可视对像
		 */
		public static function createDisplayObjectInstance(fullClassName : String, applicationDomain : ApplicationDomain = null) : DisplayObject {
			return createInstance(fullClassName, applicationDomain) as DisplayObject;
		}

		/**
		 * 创建一个类
		 * @param fullClassName 对像的连接名
		 * @param applicationDomain 元件所在的应用域
		 * @return * 
		 */
		public static function createInstance(fullClassName : String, applicationDomain : ApplicationDomain = null) : * {
			var assetClass : Class = getClass(fullClassName, applicationDomain);
			if(assetClass != null) {
				return new assetClass();
			}
			return null;		
		}

		/**
		 * 创建一个圆形
		 * @param radius 半径
		 * @param color 颜色
		 * @param alpha 透明度
		 */
		public static function createCircleShape(radius : Number,color : uint = 0x0,alpha : Number = 1) : Shape {
			var shape : Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			return shape;
		}

		/**
		 * 创建一个矩形
		 * @param width 宽
		 * @param height 高
		 * @param color 颜色
		 * @param alpha 透明度
		 */
		public static function createRectShape(width : uint,height : uint,color : uint = 0x0,alpha : Number = 1) : Shape {
			var shape : Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			return shape;
		}
		
		/**
		 * 创建一个矩形的sprite 
		 * 参数同上
		 */
		public static function createRectSprite(width : uint,height : uint,color : uint = 0x0,alpha : Number = 1) : Sprite {
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(0, 0, width, height);
			sprite.graphics.endFill();
			return sprite;
		}

		/**
		 * 创建一个BitmapData
		 * @param name 类名
		 * @param appDomain 类所在的域
		 * @return BitmapData 
		 */
		public static function createBitmapData(name : String,appDomain : ApplicationDomain = null) : BitmapData {
			if(appDomain == null)appDomain = ApplicationDomain.currentDomain;
			if(!hasDefinition(name,appDomain)){
				trace("[REFLECTION] getClass() ERROR: BitmapData is null " + name);
				return null;
			}
			var classDef : Class = getClass(name, appDomain);
			return BitmapData(new classDef(1, 1));
		}
		
		/**
		 * 
		 * @param font "gothic" 或 "Arial"
		 * @param color textColor
		 * @return textfield
		 * 
		 */
		public static function createTextField(font:String = "Arial", size:uint = 12, color:uint = 0xffffff):TextField{
			var tfl:TextField;
			if(font.toLowerCase() == "Arial"){
				tfl = createSprite("ArialTextField").getChildByName("textfield") as TextField;			
			}
			else{
				tfl = createSprite("GothicTextField").getChildByName("textfield") as TextField;			
			}
			var format:TextFormat = tfl.getTextFormat();
			format.color = color;
			format.size = size;
			tfl.defaultTextFormat = format;
			tfl.autoSize = TextFieldAutoSize.CENTER;
			return tfl;
		}
		
		/**
		 * 创建一个Sound
		 * @param name 类名
		 * @param appDomain 类所在的域
		 * @return Sound
		 */
		public static function createSound(name : String,appDomain : ApplicationDomain = null) : Sound {
			if(appDomain == null)appDomain = ApplicationDomain.currentDomain;
			var classDef : Class = getClass(name, appDomain);
			return Sound(new classDef());
		}
		
		public static function createSprite(name:String, app:ApplicationDomain=null):Sprite {
			var classDef : Class = getClass(name, app);
			return Sprite(new classDef());
		}
		public static function createMovieClip(name:String, app:ApplicationDomain=null):MovieClip {
			var classDef : Class = getClass(name, app);
			if(classDef == null) return null;
			return MovieClip(new classDef());
		}
		/*
		 * 获取库中,对象的定义;
		 * name:String		库中类名;
		 * appDomain		类所在的域;如未false,则自动从swf当前域中查找;
		 */
		public static function getClass(fullClassName : String, applicationDomain : ApplicationDomain = null) : Class {
			if(applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}
			if(!hasDefinition(fullClassName,applicationDomain)){
				trace("[REFLECTION] getClass() ERROR: mc is null" + fullClassName);
				return null;
			}
			var assetClass : Class = applicationDomain.getDefinition(fullClassName) as Class;
			return assetClass;		
		}

		/**
		 * 取对象的全名
		 */
		public static function getFullClassName(o : *) : String {
			return getQualifiedClassName(o);
		}

		/**
		 * 取对象的名,删除掉扩展名
		 */
		public static function getClassName(o : *) : String {
			var name : String = getFullClassName(o);
			var lastI : int = name.lastIndexOf(".");
			if(lastI >= 0) {
				name = name.substr(lastI + 1);
			}
			return name;
		}

		/**
		 * 取当前所在包的名
		 */
		public static function getPackageName(o : *) : String {
			var name : String = getFullClassName(o);
			var lastI : int = name.lastIndexOf(".");
			if(lastI >= 0) {
				return name.substring(0, lastI);
			} else {
				return "";
			}
		}

		
		/**
		 * 判断fla库中是否有这个元件;
		 * @param	name
		 * @return
		 */
		public static function hasDefinition(name : String, app : ApplicationDomain = null) : Boolean {
			
			return (app == null ? ApplicationDomain.currentDomain : app).hasDefinition(name);
		}
	}
}
