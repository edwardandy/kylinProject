package mainModule.controller.gameInitSteps
{
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.DESKey;
	import com.hurlant.crypto.symmetric.OFBMode;
	import com.hurlant.util.Base64;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class TestZipAndCryptoCmd extends KylinCommand
	{
		public function TestZipAndCryptoCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			testZip();
		}
		
		private function testZip():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onZipCmp);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest("configFile.zip"));
		}
		
		private function onZipCmp(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			
			var data:ByteArray = loader.data;
			
			var zip:ZipFile = new ZipFile(data);
			
			for each(var entry:ZipEntry in zip.entries)
			{
				var cfg:ByteArray = zip.getInput(entry);
				var str:String = cfg.readUTFBytes(cfg.length);
				//var out:String = ECB(str);
				//trace(entry.name+":" + str.length +";"+ out.length);
				var src:String = ECB_de(str/*cfg*/);
				trace(entry.name+":" + cfg.length +";"+ src.length + src)
			}
		}
		/**
		 * DESKey 
		 * @param src
		 * 
		 */		
		public function ECB(src:String):String 
		{//"3b3898371520f75e"
			var key:ByteArray = new ByteArray;
			key.writeUTFBytes("KEY=TD");
			
			var iv:ByteArray = new ByteArray;
			iv.writeUTFBytes("KEY=TD");
			
			var des:DESKey = new DESKey(key);
			
			var ecb:OFBMode/*ECBMode*/ = new OFBMode(des);/*ECBMode*/
			ecb.IV = iv;
			
			var pt:ByteArray = new ByteArray;
			pt.writeUTFBytes(src);
			pt.position = 0;
			ecb.encrypt(pt);
			
			var out:String = Base64.encodeByteArray(pt);
			return out;
		}
		
		public function ECB_de(/*pt:ByteArray*/src:String):String 
		{
			var key:ByteArray = new ByteArray;
			key.writeUTFBytes("KEY=TD");
			
			var iv:ByteArray = new ByteArray;
			iv.writeUTFBytes("KEY=TD");
			
			var des:DESKey = new DESKey(key);
			
			var ecb:CBCMode/*ECBMode*/ = new CBCMode(des);/*ECBMode*/
			ecb.IV = iv;
			
			var pt:ByteArray = Base64.decodeToByteArray(src);
			ecb.decrypt(pt);
			pt.position = 0;
			var out:String = pt.readUTFBytes(pt.bytesAvailable);
			
			return out;
		}
	}
}