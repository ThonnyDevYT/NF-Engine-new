package options;

import states.MainMenuState;
import backend.StageData;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import objects.Notification;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [
		//'Note Colors',
		//'Controls',
		'Adjust',
		'Graphics',
		'Visuals UI',
		'Gameplay',
		'NewOptions',
		#if DEMO_MODE
		'Debug Config'
		#end
	];

	#if !DEMO_MODE
	public function onEffectvineta(Timer:FlxTimer):Void {
		FlxTween.tween(vineta, {alpha: 0}, 3, {
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(vineta, {alpha: 1}, 3, {
					onComplete: function (twn:FlxTween) {
					}
				});
			}
		});
	}
	#end
	
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var TipText:FlxText;
	public static var TipText2:FlxText;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public var vineta:FlxSprite;

	public var reloadIcon:FlxSprite;
	public var reloadButton:FlxButton;

	public var controlsIcon:FlxSprite;
	public var controlsButton:FlxButton;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Debug Config':
				openSubState(new options.InitialSettings());
			case 'Adjust':
				MusicBeatState.switchState(new options.NoteOffsetState());
			case 'NewOptions':
				if (ClientPrefs.data.language == 'Spanish') {
					//add(new Notification(null, "Error!!", "Al parecer esta opcion esta Bloqueada por una condicion!!", 1));
					add(new Notification('Error', "Al parecer no puedes acceder a esta opcion por estar bloqueada y solo disponible en idioma ingles", 1, null, 1.3));
					//FlxG.sound.play(Paths.soundRandom('MenuSounds/notificacion-', 1, 2), FlxG.random.float(0.1, 0.2));
				}
			if (ClientPrefs.data.language == 'Inglish') {
				openSubState(new options.NewOptions());
			}
			}
}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var TimerEffect:FlxTimer;
	var TimerEffectvineta:FlxTimer;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(0, 0, FlxColor.WHITE);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0x7b7d0000;
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		//Viñeta
		vineta = new FlxSprite(0, 0).loadGraphic(Paths.image('Vineta'));
		vineta.antialiasing = ClientPrefs.data.antialiasing;
		vineta.width = FlxG.width;
		vineta.height = FlxG.height;
		vineta.updateHitbox();
		vineta.screenCenter();
		vineta.color = 0x000000;
		vineta.alpha = 0;
		
		controlsIcon = new FlxSprite(0).loadGraphic(Paths.image('icons/Menu/controlsIcon'));
		controlsIcon.antialiasing = ClientPrefs.data.antialiasing;
		controlsIcon.updateHitbox();
		controlsIcon.alpha = 0;

		reloadIcon = new FlxSprite(0).loadGraphic(Paths.image('icons/Menu/reloadIcon'));
		reloadIcon.antialiasing = ClientPrefs.data.antialiasing;
		reloadIcon.updateHitbox();
		reloadIcon.alpha = 0;

		FlxTween.tween(reloadIcon, {alpha: 1}, 2);
		FlxTween.tween(controlsIcon, {alpha: 1}, 2);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:FlxText = new FlxText(50, 300, 0, options[i], 60);
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.screenCenter(X);
			optionText.ID = i;

			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<]', true);
		add(selectorRight);

		controlsButton = new FlxButton(FlxG.width - 100, FlxG.height - 400, "", onClickControls);
		controlsButton.loadGraphicFromSprite(controlsIcon);
		controlsButton.scrollFactor.set();

		reloadButton = new FlxButton(FlxG.width - 100, FlxG.height - 500, "", onClickReload);
		reloadButton.loadGraphicFromSprite(reloadIcon);
		reloadButton.scrollFactor.set();

		//add(bgCG);
		if (ClientPrefs.data.graphics_internal != 'Low') {
		add(vineta);
		FlxTween.tween(vineta, {alpha: 1}, 2);
		}

		changeSelection();
		//ClientPrefs.saveSettings();

			add(controlsButton);
			add(reloadButton);


			#if android
			addVirtualPad(UP_DOWN, A_B);
			#end
		TimerEffectvineta = new FlxTimer();
		TimerEffectvineta.start(6, onEffectvineta, 0);

		super.create();
	}

	public function onClickControls() {
		MusicBeatState.switchState(new android.AndroidControlsMenu());
	}

	public function onClickReload() {
		ClientPrefs.loadPrefs();
		ClientPrefs.saveSettings();
		MusicBeatState.switchState(new options.OptionsState());

		#if desktop
		FlxG.resizeWindow(ClientPrefs.data.width, ClientPrefs.data.height);
		#end

		trace('Se Forzo la Carga de los ajustes!!');
	}

	override function closeSubState() {
		super.closeSubState();
		changeSelection();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {

		if (MusicBeatState._virtualpad.buttonUp.pressed = true) {
			changeSelection(-1);
		}
		if (MusicBeatState._virtualpad.buttonDown.pressed = true) {
			changeSelection(1);
		}

		if (controlsButton.released) {
			controlsButton.alpha = 0.3;
		}
		if (controlsButton.justPressed) {
			controlsButton.alpha = 1;
		}

		if (reloadButton.released) {
			reloadButton.alpha = 0.3;
		}
		if (reloadButton.justPressed) {
			reloadButton.alpha = 1;
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.sound.music.fadeOut(2, 0);
			//FlxTween.tween(grpOptions, {alpha: 0}, 5);
			//FlxTween.tween(option, {alpha: 0.5}, 5);
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new MainMenuState());
		}
		
		if (controls.ACCEPT){
			openSelectedSubstate(options[curSelected]);
		}

		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.ID = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.ID == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.saveSettings();
		super.destroy();
	}
}