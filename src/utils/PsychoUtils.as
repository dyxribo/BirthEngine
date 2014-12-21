package utils 
{
	import avmplus.getQualifiedClassName;
	import com.hurlant.util.Base64;
	import debug.printf;
	import events.UMIBEvent;
	import events.UMIBEventManager;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PsychoUtils
	{
		static public const XORKEY:String = "devtaku";
		
		protected static var eDispatcher:EventDispatcher;
		
		static public var fileRef:FileReference;
		static public var fileOperationCancelled:Boolean = false;
		static public var fileSaveSuccess:Boolean = false;
		static public var fileLoadSuccess:Boolean = false;
		static public var fileSessionComplete:Boolean = false;
		
		static private var resourceLoader:URLLoader;
		static private var resourceURLReq:URLRequest;
		static private var resourceList:Array;
		static public var resourceData:Array;
		static private var resourcesLoaded:int = 0;
		static public var allResourcesLoaded:Boolean;
		
		public function PsychoUtils()
		{
		
		}
		/*=================================================================================================
		
		▄████  █    ██      ▄▄▄▄▄    ▄  █     █ ▄▄  █    ██  ▀▄    ▄ ▄███▄   █▄▄▄▄ 
		█▀   ▀ █    █ █    █     ▀▄ █   █     █   █ █    █ █   █  █  █▀   ▀  █  ▄▀ 
		█▀▀    █    █▄▄█ ▄  ▀▀▀▀▄   ██▀▀█     █▀▀▀  █    █▄▄█   ▀█   ██▄▄    █▀▀▌  
		█      ███▄ █  █  ▀▄▄▄▄▀    █   █     █     ███▄ █  █   █    █▄   ▄▀ █  █   (FLASH PLAYER COMPATIBLE)
		█         ▀   █               █       █        ▀   █ ▄▀     ▀███▀     █   
		▀           █               ▀         ▀          █                  ▀    
		▀                                    ▀                        

		*/
		
		
		/**
		 * <b>Checks if a rectangle contains a point.</b>
		 * @param	A Rectangle to use for checking.
		 * @param	B Point to use for checking.
		 * @return
		 */
		static public function rectContainsPoint(A:Rectangle, B:Point):Boolean
		{
			return B.x > A.x && B.x < A.x + A.width && B.y > (A.y + (A.height / 3) * 2) && B.y < A.y + A.height;
		}
		
		static public function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var distX:Number = x1 - x2;
			var distY:Number = y1 - y2;
			return Math.sqrt(distX * distX + distY * distY);
		}
		
		static public function getCenter(...rest):Point
		{
			var totalX:Number = 0;
			var totalY:Number = 0;
			var totalItems:uint = 0;
			var finalPoint:Point = new Point(0,0);
			
			for (var i:uint = 0; i < rest.length; i++ )
			{
				totalX += rest[i].x;
				totalY += rest[i].y;
				++totalItems;
			}
			finalPoint.x = totalX / totalItems;
			finalPoint.x = totalY / totalItems;
			return finalPoint;
		}
		
		/**
		 * <b>Creates then returns a sprite.</b>
		 * @param	fill fill = {color: whatevs, alpha: whatevs};
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @return
		 */
		static public function createSprite(fill:Object = null, x:uint = 0, y:uint = 0, width:uint = 0, height:uint = 0):Sprite
		{
			var s:Sprite = new Sprite();
			
			if (fill != null)
				s.graphics.beginFill(fill.color, fill.alpha);
			else
				s.graphics.beginFill(0xFFFFFF, 0);
			
			s.graphics.drawRect(x, y, width, height);
			s.graphics.endFill();
			
			return s;
		}
		
		/**
		 * <b>Creates then returns a new textfield.</b>
		 * <b>TextFormatOptions</b>: color, isBold, isItalic, isUnderlined, url, urlTarget (i.e. _blank, etc.), alignment
		 */
		
		static public function createTextField(x:int, y:int, height:int = 30, width:int = 250, type:String = "DYNAMIC", multiline:Boolean = false, textFormatOptions:Object = null):TextField
		{
			var tf:TextField = new TextField();
			
			if (textFormatOptions != null)
				tf.defaultTextFormat = new TextFormat("Segoe UI", 14, textFormatOptions.color, textFormatOptions.isBold, textFormatOptions.isItalic, textFormatOptions.isUnderlined, textFormatOptions.url, textFormatOptions.urlTarget, textFormatOptions.alignment);
			else
				tf.defaultTextFormat = new TextFormat("Segoe UI", 14);
			
			tf.selectable = false;
			tf.multiline = multiline;
			tf.type = TextFieldType[type];
			tf.x = x;
			tf.y = y;
			tf.width = width;
			tf.height = height;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.wordWrap = true;
			
			return tf;
		}
		
		/**
		 * <b>Loads data from the specified URL.</b> The data can be received as text, raw binary data, or URL-encoded variables, depending on the value you set for the dataFormat property. Note that the default value of the dataFormat property is text.
		 * @param	url URL to load.
		 * @param	type Type of data to load. it can be binary, text, or variable data. use URLLoaderDataFormat.
		 * @param	onComplete Function to call when loading is complete.
		 * @param	onError Function to call if the loader encounters an error.
		 */
		static public function loadResource(urls:Array, type:String = URLLoaderDataFormat.TEXT):void
		{
			resourceLoader = new URLLoader();
			resourceURLReq = new URLRequest();
			resourceLoader.dataFormat = type;
			resourceList = urls;
			resourceData = [];
			
			loadFile(resourceList[0]);
		}
		
		static private function loadFile(path:String):void 
		{
			setupListeners(resourceLoader);
			
			resourceURLReq.url = path;
			resourceLoader.load(resourceURLReq);
		}
		
		static public function resetResourceLoader():void
		{
			allResourcesLoaded = false;
			resourceData = null;
			resourceList = null;
			resourcesLoaded = 0;
			resourceLoader = null;
			resourceURLReq = null;
		}
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 * @param	event_type The type of event.
		 * @param	listener The listener function that processes the event.
		 * @param	useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param	priority The priority level of the event listener.
		 * @param	useWeakReference Determines whether the reference to the listener is strong or weak.
		 */
		static public function addStaticEventListener(event_type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (eDispatcher == null) eDispatcher = new EventDispatcher();
			eDispatcher.addEventListener(event_type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a listener from the EventDispatcher object.
		 * @param	event_type The type of event.
		 * @param	listener The listener object to remove.
		 * @param	useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
		 */
		static public function removeStaticEventListener(event_type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (eDispatcher == null) return;
			eDispatcher.removeEventListener(event_type, listener, useCapture);
		}
		
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type 
		 * of event.
		 * @param	type The type of event.
		 * @return A value of true if a listener of the specified type is registered; false otherwise.
		 */
		static public function hasStaticEventListener(type:String):Boolean
		{
			return eDispatcher.hasEventListener(type);
		}
		
		/**
		 * Dispatches an event into the event flow.
		 * @param	event The Event object that is dispatched into the event flow.
		 */
		static public function dispatchStaticEvent(event:Event):void
		{
			if (eDispatcher == null) eDispatcher = new EventDispatcher();
			eDispatcher.dispatchEvent(event);
		}
		
		/**
		 * <b>Loads an external DisplayObject (such as SWF, JPEG, GIF, or PNG files) using the Loader class.</b>
		 * @param	url URL of the D.O. to load.
		 * @param	onComplete Function to call when loading is complete.
		 * @param	onProgress Function to call every time the loader progresses.
		 * @param	onError Function to call if the loader encounters an error.
		 */
		static public function loadExternalDisplayObject(url:String, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void
		{
			var loader:Loader = new Loader();
			if (onComplete != null)
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			if (onProgress != null)
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onProgress);
			if (onError != null)
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Manipulates the alpha property of a DisplayObject.
		 * @param	target DisplayObject to edit.
		 * @param	alpha The new alpha value of [target]. Valid values are 1-100.
		 */
		static public function setAlpha(target:DisplayObject, alpha:Number):void
		{
			if (alpha > 100)
				alpha = (alpha > 100) ? (100) : (0);
			else if (alpha < 0)
				alpha = alpha < 0 ? (0) : alpha;
			
			target.alpha = alpha / 100;
		}
		
		static public function setTint(target:DisplayObject, tint:Number):void
		{
		
		}
		
		/**
		 * Manipulates the brightness of a DisplayObject.
		 * @param	target DisplayObject to edit.
		 * @param	brightness The brightness value of [target];
		 */
		static public function setBrightness(target:DisplayObject, brightness:Number):void
		{
			if (Math.abs(brightness) > 100)
				brightness = brightness > 100 ? (100) : (-100);
			
			var brightnessControl:ColorTransform = new ColorTransform();
			brightnessControl.redOffset = brightness * 2.55;
			brightnessControl.greenOffset = brightness * 2.55;
			brightnessControl.blueOffset = brightness * 2.55;
			
			target.transform.colorTransform = brightnessControl;
		}
		
		/**
		 * Splits a string into an array or vector by the specified delimiter.
		 * @param	string the string you want to split.
		 * @param	splitTo the array or vector you want to split to.
		 * @param	splitAt specifies the delimiter used to split the string.
		 */
		static public function splitStringTo(string:String, splitAt:String, splitTo:* = null):*
		{
			var isReturn:Boolean = false;
			if (!splitTo)
			{
				var splitTo:Array = new Array();
				isReturn = true;
			}
			
			for (var i:int = 0; i < string.split(splitAt).length; ++i)
			{
				splitTo.push(string.split(splitAt)[i]);
			}
			
			if (isReturn)
				return splitTo;
		}
		
		/**
		 * Takes a screenshot of the target DisplayObject.
		 * @param	target The DO to take a snapshot of.
		 */
		/*static public function takeScreenshot(target:DisplayObject):void
		{
			var imgMetadata:BitmapData = new BitmapData(Main.width, Main.height);
			imgMetadata.draw(target);
			var imgBA:ByteArray = PNGEncoder.encode(imgMetadata);
			saveFile(imgBA, "New " + Main.APPNAME + " Screenshot");
		}*/
		
		/**
		 * Saves a ByteArray into a file. (opens a dialogue box)
		 * @param	filedata Data to save.
		 * @param	filename Name of the file.
		 */
		static public function saveFile(filedata:ByteArray, filename:String):void
		{
			fileSessionComplete = false;
			fileSaveSuccess = false;
			fileOperationCancelled = false;
			
			fileRef = new FileReference();
			addSaveEvents();
			fileRef.save(filedata, filename);
			fileRef.removeEventListener(Event.SELECT, onSaveSelected);
		}
		
		/**
		 * Encrypt an unencrypted string.
		 * @param	uncryptedString The string to encrypt.
		 * @return
		 */
		static public function encrypt(uncryptedString:String):String
		{
			return xor(Base64.encode(uncryptedString));
		}
		
		/**
		 * Decrypts a string that was encrypted by Psychoencrypt().
		 * @param	encryptedString The string to decrypt.
		 * @return
		 */
		static public function decrypt(encryptedString:String):String
		{
			return Base64.decode(xor(encryptedString));
		}
		
		/**
		 * XOR encrypts a string.
		 * @param	s The string to encrypt.
		 * @return
		 */
		static public function xor(s:String):String
		{
			var key:String = XORKEY;
			var encryptedString:String = new String();
			var iterator:int = 0;
			
			while (iterator < s.length)
			{
				if (iterator > (s.length - 1))
					key = key + key;
				
				encryptedString = encryptedString + String.fromCharCode(s.charCodeAt(iterator) ^ key.charCodeAt(iterator));
				++iterator;
			}
			
			return encryptedString;
		}
		
		/**
		 * Centers a DisplayObject on stage.
		 * @param	target The MC to center.
		 * @param	stage The stage that will be used for centering calculations.
		 * @param	justification Where the transformation point is, relative to [target]. 
		 * topleft, topcenter, topright, centerleft, center, centerright, bottomleft, bottomcenter, bottomright
		 */
		static public function centerDisplayObject(target:DisplayObject, stage:Stage, justification:String = "topleft"):void
		{
			if (justification == "topleft")
			{
				target.x = (stage.stageWidth / 2) - (target.width / 2);
				target.y = (stage.stageHeight / 2) - (target.height / 2);
			}
			else if (justification == "center")
			{
				target.x = (stage.stageWidth / 2);
				target.y = (stage.stageHeight / 2);
			}
			else if (justification == "bottomcenter")
			{
				target.x = (stage.stageWidth / 2);
				target.y - (stage.stageHeight / 2) + (target.height / 2);
			}
		}
		
		/**
		 * Removes whitespace and extras from a string.
		 * @param	inputString The string to condense.
		 * @return
		 */
		public static function condenseString(inputString:String):String
		{
			var c:RegExp = /"/g;
			inputString = inputString.replace(c, "");
			inputString = inputString.split(" ").join("");
			inputString = inputString.split("\r").join("");
			inputString = inputString.split("\t").join("");
			inputString = inputString.split("%20").join(" ");
			return inputString;
		}
		
		public static function mergeObjects(...rest):Object 
		{
			var finalObject:Object = { };
			
			for (var i:int = 0; i < rest.length; i++)
			{
				if (getQualifiedClassName(rest[i]) != "Object") continue;
				if (rest[i] == { } ) continue;
				
				for (var o:Object in rest[i])
				{
					finalObject[o] = rest[i][o];
				}
			}
			return finalObject;
		}
		/**
		 * returns the percentage of a number such as 12% of 800.
		 * @param	percent Percentage of the number in [of]. can be a decimal or a whole number, whatever.
		 * @param	of
		 * @return
		 */
		public static function percentOf(percent:Number, of:Number):Number
		{
			percent = (percent > 1) ? (percent / 100) : percent;
			return (percent * of);
		}
		
		/*===========================================================================================================
		 * 
		 * 
		 *		█    ▄█    ▄▄▄▄▄      ▄▄▄▄▀ ▄███▄      ▄   ▄███▄   █▄▄▄▄   ▄▄▄▄▄   
		 *		█    ██   █     ▀▄ ▀▀▀ █    █▀   ▀      █  █▀   ▀  █  ▄▀  █     ▀▄  (EVENT LISTENERS)
		 *		█    ██ ▄  ▀▀▀▀▄       █    ██▄▄    ██   █ ██▄▄    █▀▀▌ ▄  ▀▀▀▀▄   
		 *		███▄ ▐█  ▀▄▄▄▄▀       █     █▄   ▄▀ █ █  █ █▄   ▄▀ █  █  ▀▄▄▄▄▀    
		 *			▀ ▐              ▀      ▀███▀   █  █ █ ▀███▀     █             
		 *							█   ██          ▀              
		 * */
		
		static private function addSaveEvents():void
		{
			fileRef.addEventListener(Event.SELECT, onSaveSelected);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveIOError);
			fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSaveSecurityError);
			fileRef.addEventListener(ProgressEvent.PROGRESS, onSaveProgress);
			fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
		}
		
		static private function killSaveEvents():void
		{
			fileRef.removeEventListener(Event.CANCEL, onSaveCancel);
			fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onSaveIOError);
			fileRef.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSaveSecurityError);
			fileRef.removeEventListener(ProgressEvent.PROGRESS, onSaveProgress);
			fileRef.removeEventListener(Event.COMPLETE, onSaveComplete);
		}
		
		static private function onSaveSelected(e:Event):void
		{
			fileRef.addEventListener(ProgressEvent.PROGRESS, onSaveProgress);
			fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
			fileRef.addEventListener(Event.CANCEL, onSaveCancel);
		}
		
		static private function onSaveIOError(e:IOErrorEvent):void
		{
			printf("There was an IO error.");
			fileOperationCancelled = true;
			fileSessionComplete = true;
			
			killSaveEvents();
		}
		
		static private function onSaveSecurityError(e:SecurityErrorEvent):void
		{
			printf("There was a security error.");
			fileOperationCancelled = true;
			fileSessionComplete = true;
			
			killSaveEvents();
		}
		
		static private function onSaveProgress(e:ProgressEvent):void
		{
			printf("Saved " + e.bytesLoaded + " bytes of " + e.bytesTotal + " total.");
		}
		
		static private function onSaveComplete(e:Event):void
		{
			printf("File saved!");
			fileSaveSuccess = true;
			fileSessionComplete = true;
			
			killSaveEvents();
		}
		
		static private function onSaveCancel(e:Event):void
		{
			printf("The save request was terminated by the user.");
			fileOperationCancelled = true;
			fileSessionComplete = true;
			fileSaveSuccess = false;
			
			killSaveEvents();
		}
		
		static private function onFileLoadComplete(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			
			resourceData.push(e.target.data);
			
			if (resourcesLoaded < resourceList.length - 1)
			{
				++resourcesLoaded;
				loadFile(resourceList[resourcesLoaded]);
			}
			else
			{
				completeLoading();
			}
		}
		
		static private function completeLoading():void 
		{
			allResourcesLoaded = true;
			UMIBEventManager.dispatchEvent(new UMIBEvent(UMIBEvent.TEXT_LOAD_COMPLETE, resourceData));
		}
		
		static private function setupListeners(resLoader:URLLoader):void 
		{
			resLoader.addEventListener(Event.COMPLETE, onFileLoadComplete);
			resLoader.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
		}
		
		static private function onFileLoadError(e:IOErrorEvent):void 
		{
			printf("File could not be loaded. Are you sure it has R/W permissions?");
		}
	}
}