package timmee.core
{
	import com.laiyonghao.Uuid;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	
	
	public class ApplicationSettings extends Object
	{
		public static var sessionLength:int = Constants.MILLISECONDS_IN_MINUTE * 25;
		public static var shortBreakLength:int = Constants.MILLISECONDS_IN_MINUTE * 5;
		public static var longBreakLength:int = Constants.MILLISECONDS_IN_MINUTE * 20;
		public static var longBreakDelay:int = 4;
		public static var notificationVolume:Number = 1;
		public static var startAtLogin:Boolean = false;
		public static var alwaysOnTop:Boolean = false;
		public static var UUID:String;
		
		public static var appRunningFirstTime:Boolean;
		
		
		public static function load():void
		{
			var file:File = new File(Constants.SETTINGS_CONFIGURATION_URL);
			if (file.exists)
			{
				var fileStream:FileStream = new FileStream();
				
				try
				{
					fileStream.open(file, FileMode.READ);
				} catch (error:Error) { }
				
				var data:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				if (data)
				{
					if (data.hasOwnProperty("settings"))
					{
						var settings:XML = data.settings[0];
						sessionLength = settings.hasOwnProperty("sessionLength") ? parseInt(settings.sessionLength.toString()) : sessionLength;
						shortBreakLength = settings.hasOwnProperty("shortBreakLength") ? parseInt(settings.shortBreakLength.toString()) : shortBreakLength;
						longBreakLength = settings.hasOwnProperty("longBreakLength") ? parseInt(settings.longBreakLength.toString()) : longBreakLength;
						longBreakDelay = settings.hasOwnProperty("longBreakDelay") ? parseInt(settings.longBreakDelay.toString()) : longBreakDelay;
						notificationVolume = settings.hasOwnProperty("notificationVolume") ? parseFloat(settings.notificationVolume.toString()) : notificationVolume;
						startAtLogin = settings.hasOwnProperty("startAtLogin") ? Boolean(settings.startAtLogin.text().toString() === "true") : startAtLogin;
						alwaysOnTop = settings.hasOwnProperty("alwaysOnTop") ? Boolean(settings.alwaysOnTop.text().toString() === "true") : alwaysOnTop;
					}
					
					UUID = data.hasOwnProperty("uuid") ? data.uuid : (new Uuid()).toString();
					System.disposeXML(data);
				}
			}
			else
			{
				UUID = (new Uuid()).toString();
				appRunningFirstTime = true;
			}
		}
		
		
		public static function save():void
		{
			var data:XML = new XML('<Timmee/>');
			data.uuid = UUID;
			
			var settings:XML = new XML('<settings/>')
			settings.sessionLength = sessionLength;
			settings.shortBreakLength = shortBreakLength;
			settings.longBreakLength = longBreakLength;
			settings.longBreakDelay = longBreakDelay;
			settings.notificationVolume = notificationVolume;
			settings.startAtLogin = startAtLogin;
			settings.alwaysOnTop = alwaysOnTop;
			data.appendChild(settings);
			
			var file:File = new File(Constants.SETTINGS_CONFIGURATION_URL);
			var fileStream:FileStream = new FileStream();
			
			try
			{
				fileStream.open(file, FileMode.WRITE);
			} catch (error:Error) { }
			
			var outputString:String = Constants.XML_DOCTYPE + '\n' + data.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
			
			System.disposeXML(data);
		}
	}
}