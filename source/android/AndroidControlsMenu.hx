package android;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import android.flixel.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import android.FlxNewHitbox;
import android.AndroidControls.Config;
import android.FlxVirtualPad;

using StringTools;

class AndroidControlsMenu extends MusicBeatState
{
	var vpad:FlxVirtualPad;
	var newhbox:FlxNewHitbox;
	var upPozition:FlxText;
	var downPozition:FlxText;
	var leftPozition:FlxText;
	var rightPozition:FlxText;
	var shiftPozition:FlxText;
	var spacePozition:FlxText;
	var inputvari:PsychAlphabet;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var controlitems:Array<String> = ['Pad-Right','Pad-Left','Pad-Custom','Duo','Hitbox','Keyboard'];
	var curSelected:Int = 0;
	var buttonistouched:Bool = false;
	var bindbutton:FlxButton;
	var config:Config;
    var extendConfig:Config;
    
	override public function create():Void
	{
		super.create();
		
		config = new Config('saved-controls');
		curSelected = config.getcontrolmode();
		
		extendConfig = new Config('saved-extendControls');  //use for update control for shift and space --write by NF|beihu(b站-北狐丶逐梦)

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var titleText:Alphabet = new Alphabet(75, 60, "Android Controls", true);
		titleText.scaleX = 0.6;
		titleText.scaleY = 0.6;
		titleText.alpha = 0.4;
		add(titleText);

		vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.data.antialiasing);
		vpad.alpha = 0;
		add(vpad);

		newhbox = new FlxNewHitbox();
		newhbox.visible = false;
		add(newhbox);

		inputvari = new PsychAlphabet(0, 50, controlitems[curSelected], false, false, 0.05, 0.8);
		inputvari.screenCenter(X);
		add(inputvari);

		var ui_tex = Paths.getSparrowAtlas('androidcontrols-source/menu/arrows');

		leftArrow = new FlxSprite(inputvari.x - 60, inputvari.y + 50);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(inputvari.x + inputvari.width + 10, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		add(rightArrow);

		upPozition = new FlxText(10, FlxG.height - 164, 0,"Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y, 16);
		upPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		upPozition.borderSize = 2;
		add(upPozition);

		downPozition = new FlxText(10, FlxG.height - 144, 0,"Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y, 16);
		downPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		downPozition.borderSize = 2;
		add(downPozition);

		leftPozition = new FlxText(10, FlxG.height - 124, 0,"Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y, 16);
		leftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leftPozition.borderSize = 2;
		add(leftPozition);

		rightPozition = new FlxText(10, FlxG.height - 104, 0,"Button RIght x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y, 16);
		rightPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		rightPozition.borderSize = 2;
		add(rightPozition);
		
		spacePozition = new FlxText(10, FlxG.height - 84, 0,"Button Space X:" + vpad.buttonG.x +" Y:" + vpad.buttonG.y, 16);
		spacePozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		spacePozition.borderSize = 2;
		add(spacePozition);
		
		shiftPozition = new FlxText(10, FlxG.height - 64, 0,"Button Shift X:" + vpad.buttonF.x +" Y:" + vpad.buttonF.y, 16);
		shiftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		shiftPozition.borderSize = 2;
		add(shiftPozition);

		var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press [B] to Go Back to Options Menu', 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);

		#if android
		addVirtualPad(NONE, B);
		#end

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		leftArrow.x = inputvari.x - 60;
		rightArrow.x = inputvari.x + inputvari.width + 10;
		inputvari.screenCenter(X);
		
		for (touch in FlxG.touches.list){		
			if(touch.overlaps(leftArrow) && touch.justPressed)
			{
				changeSelection(-1);
			}
			else if (touch.overlaps(rightArrow) && touch.justPressed)
			{
				changeSelection(1);
			}
			trackbutton(touch);
		}

		#if android
		if (MusicBeatState._virtualpad.buttonB.pressed == true) {
			save();
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new options.OptionsState());
		}
		#end
		
		#if android
		if (FlxG.android.justReleased.BACK)
		{
			save();
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new options.OptionsState());
		}
		#end
	}

	function changeSelection(change:Int = 0)
	{
	    if (change != 0) save(); //fix start load
		curSelected += change;
	
		if (curSelected < 0)
			curSelected = controlitems.length - 1;
		if (curSelected >= controlitems.length)
			curSelected = 0;
	
		inputvari.changeText(controlitems[curSelected]);
		
		buttonistouched = false;

		var daChoice:String = controlitems[Math.floor(curSelected)];

		switch (daChoice)
		{
				case 'Pad-Right':
					remove(vpad);
					vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.data.antialiasing);
					add(vpad);
					loadcustom(false);
				case 'Pad-Left':
					remove(vpad);
					vpad = new FlxVirtualPad(FULL, controlExtend, 0.75, ClientPrefs.data.antialiasing);
					add(vpad);
					loadcustom(false);
				case 'Pad-Custom':
					remove(vpad);
					vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.data.antialiasing);
					add(vpad);
					loadcustom(true);
				case 'Duo':
					remove(vpad);
					vpad = new FlxVirtualPad(DUO, controlExtend, 0.75, ClientPrefs.data.antialiasing);
					add(vpad);
					loadcustom(false);
				case 'Hitbox':
					vpad.alpha = 0;
				case 'Keyboard':
					remove(vpad);
					vpad.alpha = 0;
					
		}

		if (daChoice != "Hitbox")
		{
			newhbox.visible = false;
		}
		else
		{
		    newhbox.visible = true;
		}
		
		if (daChoice != "Hitbox" && daChoice != "Keyboard")
		{
			spacePozition.visible = true;
			shiftPozition.visible = true;
		}
		else
		{
		    spacePozition.visible = false;
			shiftPozition.visible = false;
		}

		if (daChoice != "Pad-Custom")
		{
			upPozition.visible = false;
			downPozition.visible = false;
			leftPozition.visible = false;
			rightPozition.visible = false;
		}
		else
		{
			upPozition.visible = true;
			downPozition.visible = true;
			leftPozition.visible = true;
			rightPozition.visible = true;
		}
	}

	function trackbutton(touch:flixel.input.touch.FlxTouch){
		var daChoice:String = controlitems[Math.floor(curSelected)];

		if (daChoice == 'Pad-Custom'){
			if (buttonistouched){
				if (bindbutton.justReleased && touch.justReleased)
				{
					bindbutton = null;
					buttonistouched = false;
				}else 
				{
					movebutton(touch, bindbutton);
					setbuttontexts();
				}
			}
			else 
			{
				if (vpad.buttonUp.justPressed) {
					movebutton(touch, vpad.buttonUp);
				}
				
				if (vpad.buttonDown.justPressed) {
					movebutton(touch, vpad.buttonDown);
				}

				if (vpad.buttonRight.justPressed) {
					movebutton(touch, vpad.buttonRight);
				}

				if (vpad.buttonLeft.justPressed) {
					movebutton(touch, vpad.buttonLeft);
				}
			}
		}
		if (daChoice != 'Hitbox'){
		    if (buttonistouched){
				if (bindbutton.justReleased && touch.justReleased)
				{
					bindbutton = null;
					buttonistouched = false;
				}else 
				{
					movebutton(touch, bindbutton);
					setbuttontexts();
				}
			}
			else 
			{
				if (vpad.buttonG.justPressed) {
					movebutton(touch, vpad.buttonG);
				}
				
				if (vpad.buttonF.justPressed) {
					movebutton(touch, vpad.buttonF);
				}
			}
		}
	}

	function movebutton(touch:flixel.input.touch.FlxTouch, button:android.flixel.FlxButton) {
		button.x = touch.x - vpad.buttonUp.width / 2;
		button.y = touch.y - vpad.buttonUp.height / 2;
		bindbutton = button;
		buttonistouched = true;
	}

	function setbuttontexts() {
		upPozition.text = "Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y;
		downPozition.text = "Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y;
		leftPozition.text = "Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y;
		rightPozition.text = "Button RIght x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y;
		spacePozition.text = "Button Space X:" + vpad.buttonG.x +" Y:" + vpad.buttonG.y;
		shiftPozition.text = "Button Shift X:" + vpad.buttonF.x +" Y:" + vpad.buttonF.y;
		
	}

	function save() {
		config.setcontrolmode(curSelected);
		var daChoice:String = controlitems[Math.floor(curSelected)];

		if (daChoice == 'Pad-Custom'){
			config.savecustom(vpad);
		}
		if (daChoice != 'Hitbox'){
		    extendConfig.savecustom(vpad);
		}
	}

	function loadcustom(needFix:Bool):Void{
	    if (needFix){
		vpad = config.loadcustom(vpad);	
		vpad = extendConfig.loadcustom(vpad);
		}
		else{
		vpad = extendConfig.loadcustom(vpad);
		}
	}
}
