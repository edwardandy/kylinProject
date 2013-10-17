package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import kylin.echo.edward.utilities.font.FontMgr;
	import kylin.echo.edward.utilities.objectPool.PoolManager;
	
	import utili.font.FontClsName;

	public class CommonAnimationEffects
	{
		public function CommonAnimationEffects()
		{
		}
		
		/**
		 * 伤害数字特效 
		 * @param container	特效要添加到的容器
		 * @param num		伤害数值
		 * @param startX	起始位置
		 * @param startY
		 * @param type		特效类型	0向上	1左		2右
		 * 
		 */		
		public static function hurtEffect( container:DisplayObjectContainer, text:String, startX:Number, startY:Number, type:int ):void
		{
			if ( !PoolManager.getInstance().hasPool(HurtNumEffectMC) )
			{
				PoolManager.getInstance().createPool( HurtNumEffectMC, 0, hurtEffInit, hurtEffReuse );
			}
			if ( !PoolManager.getInstance().hasPool( CritHurtEffectMC ) )
			{
				PoolManager.getInstance().createPool( CritHurtEffectMC, 0, hurtEffInit, hurtEffReuse );
			}
			
			if ( container.stage == null )
			{
				return;
			}
			
			var pos:Point = container.localToGlobal( new Point( startX, startY ) );
			startX = pos.x;
			startY = pos.y;
			
			var eff:MovieClip = PoolManager.getInstance().getObject( type == 0 ? CritHurtEffectMC : HurtNumEffectMC ) as MovieClip;
			eff.numLabel.text = text;
			eff.x = startX;
			eff.y = startY;
			container.stage.addChild( eff );
			var endPos:Point = new Point(
				type == 0 ? startX : type == 1 ? startX-56.7 : startX+56.7,
				type == 0 ? startY - 83 : startY+1.45
			);
			var midPos:Point = new Point(
				type == 0 ? startX : type == 1 ? startX-37.2 : startX+37.2,
				type == 0 ? startY - 42 : startY-14.75 );
			TweenMax.to( eff, 1.1, {bezierThrough:[{x:midPos.x, y:midPos.y}, {x:endPos.x, y:endPos.y}],
				onComplete:function():void
				{
					PoolManager.getInstance().putObject( eff, type == 0 ? CritHurtEffectMC : HurtNumEffectMC );
				}
			} );
			TweenLite.to( eff, 0.1, {scaleX:(type==0 ? 2.65 : 1.3), scaleY:(type==0 ? 2.65 : 1.3), overwrite:0 } );
			if ( type == 0 )
			{
				TweenLite.to( eff, 0.3, {scaleX:1, scaleY:1, delay:0.1, overwrite:0 } );
			}
			TweenLite.to( eff, 0.7, {alpha:0, delay:0.4, overwrite:0} );
		}
		
		//-----------------------------------------------------
		//私有函数
		//-----------------------------------------------------
		
		private static function hurtEffInit( effMC:MovieClip ):void
		{
			effMC.mouseChildren = effMC.mouseEnabled = false;
			FontMgr.instance.setTextStyle(effMC.numLabel,FontClsName.ButtonFont);
			effMC.numLabel.text = effMC.numLabel.text;
			TextField(effMC.numLabel).autoSize = TextFieldAutoSize.CENTER;
			effMC.cacheAsBitmap = true;
		}
		
		private static function hurtEffReuse( effMC:MovieClip ):void
		{
			effMC.scaleX = effMC.scaleY = 0.37;
			effMC.alpha = 1;
			
			if ( effMC.parent )
			{
				effMC.parent.removeChild( effMC );
			}
		}
	}
}