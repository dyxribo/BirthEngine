package debug 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import input.Key;
	import utils.VirtualCamera;
	/**
	 * ...
	 * @author Psycho
	 */
	public class IConsole extends Console
	{
		private var _note:ConsoleNote;
		private var _noteVisible:Boolean;
		private var _outputPane:TextField;
		private var _mouseXY:TextField;
		private var _cameraXY:TextField;
		private var _selection:*;
		private var _selectionName:TextField;
		private var _selectionX:TextField;
		private var _selectionY:TextField;
		private var _vCam:VirtualCamera;
		private var _totalChildren:uint;
		private var _FPS:uint;
		private var _FPSTimer:uint;
		private var _FPSVec:Vector.<uint>;
		private var _tDelay:uint;
		
		public function IConsole() 
		{
			_outputPane = outputPane;
			_mouseXY = mouseTXT;
			_cameraXY = camTXT;
			_selectionName = currentSelectionName;
			_selectionX = selectionX;
			_selectionY = selectionY;
			_totalChildren = 0;
			_FPS = 0;
			_FPSTimer = 60;
			_FPSVec = new Vector.<uint>();
			_tDelay = 100;
		}
		
		public function showNote():void
		{
			if (!_noteVisible)
			{
				if (!_note) _note = new ConsoleNote();
				_note.x = this.width - _note.width;
				_note.y = this.height - _note.height;
				_note.alpha = 0;
				addChild(_note);
				_noteVisible = true;
				TweenLite.from(_note, 1, { alpha: 0, y: this.height } );
				if (this.visible) this.visible = false;
			}
		}
		
		public function hideNote():void
		{
			if (_note && _noteVisible)
			{
				TweenLite.to(_note, .5, { alpha: 0, y: this.height, onComplete: removeChild, onCompleteParams: [_note] } );
				this.visible = true;
			}
		}
		
		public function appendOutput(...rest):void
		{
			for each(var item:* in rest) 
			{
				_outputPane.appendText(item);
				_outputPane.scrollV = _outputPane.numLines - 3;
			}
		}
		
		public function setSelection(e:MouseEvent):void
		{
			_selection = e.currentTarget;
		}
		
		public function update():void
		{
			_mouseXY.text = "X: " + mouseX + ", Y: " + mouseY;
			if (_vCam) _cameraXY.text = _vCam.x + ", " + _vCam.y;
			if (_selection) 
			{
				_selectionName.text = String(_selection).substring(8, String(_selection).length - 1);
				_selectionX.text = _selection.x.toString();
				_selectionY.text = _selection.y.toString();
			}
			if (!_tDelay)
			{
				if (Key.isDown(Key.T))
				{
					if (_noteVisible) hideNote();
					else showNote();
					_tDelay = 100;
				}
			}
			else --_tDelay;
			currentFPS();
			testMemory();
		}
		
		public function init(location:DisplayObjectContainer):void 
		{
			println("[AE] :: DEBUG_MODE : TRUE CONSOLE\n[AE] :: Console mode changed.");
			_selectionName.text = "Current Selection: Stage";
			_selectionX.text = "" + stage.x;
			_selectionY.text = "" + stage.y;
			resData.text = "dix";
			displayObjNum.text = addDebugMouseListeners(location).toString();
		}
		
		private function currentFPS():void 
		{
			_FPS++;
		}
		
		private function testMemory():void 
		{
			if (!_FPSTimer)
			{
				_FPSVec.push(_FPS);
				
				if(_FPSVec.length == 4)
				{
					for (var i:int = 1; i < _FPSVec.length; i++)
					{	
						_FPSVec[0] += _FPSVec[i];
					}
					_FPSVec.splice(1, _FPSVec.length - 1);
					_FPSVec[0] /= 4;
				}
				
				resData.text = "FPS: " + _FPS + " || AVG_FPS: " + Math.round(_FPSVec[0]) + " || MEM: " + Math.round(System.privateMemory / 1024 / 1024).toString() + " MB";
				_FPS = 0;
				_FPSTimer = 60;
			}
		}
		
		public function addDebugMouseListeners(dOC:DisplayObjectContainer):uint
		{
			var numCh:int = dOC.numChildren;
			
			for (var i:int = 0; i < numCh; i++)
			{
				var child:* = dOC.getChildAt(i);
				child.addEventListener(MouseEvent.CLICK, setSelection);
				++_totalChildren;
				
				if (child is DisplayObjectContainer && child.numChildren > 0)
				{
					addDebugMouseListeners(child);
				}
			}
			return _totalChildren;
		}
		
		public function setCamera(vCam:VirtualCamera):void 
		{
			_vCam = vCam;
		}
	}
}