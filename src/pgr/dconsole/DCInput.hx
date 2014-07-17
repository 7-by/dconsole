package pgr.dconsole;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import pgr.dconsole.DConsole;

/**
 * Handles input
 * @author TiagoLr
 */
class DCInput{

	var console:DConsole;
	
	public function new(console:DConsole) {
		this.console = console;
		
		enable();
	}
	
	
	public function enable() {
		// make sure events are removed first.
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
	}
	
	
	public function disable() {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void {
		#if !(cpp || neko) // BUGFIX
		if (console.enabled && console.visible) {
			e.stopImmediatePropagation();
		}
		#end
	}
	
	
	private function onKeyUp(e:KeyboardEvent):Void {
		// TOGGLE MONITOR
		if (matchesKey(console.monitorKey, e)) {
			console.toggleMonitor();
			return;
		}
		
		// TOGGLE PROFILER
		else 
		if (matchesKey(console.profilerKey, e)) {
			console.toggleProfiler();
			return;
		}
		
		// SHOW/HIDE CONSOLE
		else 
		if (matchesKey(console.consoleKey, e)) {
			if (console.visible) {
				console.hideConsole();
			} else {
				console.showConsole();
			}
			return;
		}
		
		// IGNORE INPUT IF CONSOLE HIDDEN
		else 
		if (!console.visible) {
			return;
		}

		// ENTER KEY
		else 
		if (e.keyCode == 13) {
			console.processInputLine();
		}
		
		// PAGE DOWN
		else if (e.keyCode == 33) {
			console.scrollDown();
		}
		
		// PAGE UP
		else 
		if (e.keyCode == 34) { 
			console.scrollUp();
		}
		
		// DOWN KEY
		else
		if (e.keyCode == 38) {
			console.nextHistory();
		}
		
		// UP KEY
		else 
		if (e.keyCode == 40) { 
			console.prevHistory();
		}
		
		else 
		{
			console.resetHistoryIndex();
		}

		#if !(cpp || neko) // BUGFIX
		e.stopImmediatePropagation(); // BUG - cpp issues.
		#end
	}
	
	function matchesKey(key:SCKey, e:KeyboardEvent) {
		return (key.keycode == cast(e.keyCode, Int) 
				&& key.altKey == e.altKey
				&& key.ctrlKey == e.ctrlKey
				&& key.shiftKey == e.shiftKey);
	}
	
}