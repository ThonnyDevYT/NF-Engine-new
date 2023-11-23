package states;

import states.editors.UpdatingState;
import flixel.FlxState;
import flixel.math.FlxPoint;
import openfl.events.MouseEvent;
import flixel.input.mouse.FlxMouseButton;
import openfl.ui.MouseCursor;
import flixel.ui.FlxSpriteButton;
import options.Option;
import flixel.ui.FlxButton;
import backend.WeekData;
import backend.Achievements;
import openfl.utils.Timer;
import flixel.util.FlxTimer;

import openfl.filters.GlowFilter;

import substates.Prompt;
import flixel.FlxState;
import objects.Notification;

import flixel.input.FlxPointer;
//import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.input.mouse.FlxMouseEvent;

import flixel.FlxObject;
////
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import flash.text.TextField;

import objects.AchievementPopup;
import objects.Notification;
import states.editors.MasterEditorMenu;
import options.OptionsState;
//import openfl.display.Internet;

class MainMenuState extends MusicBeatState
{
	//public static var psychEngineVersion:String = '0.7.1h'; //This is also used for Discord RPC
	public static var endingcorruptionVersion:String = '2.0'; //Update!! to Release
	public static var engineVersion:String = '2.3'; //update to Release
	var tipkey:FlxText;
	var tipvideo:FlxText;
	public static var curSelected:Int = 0;

	//public var camHUD:FlxCamera;
	//var controllerPointer:FlxSprite;

	public static var bg:FlxSprite;
	public var bgCG:FlxSprite;
	public var TimerEffect:FlxTimer;
	public var alphaeffect:FlxTimer;
	public var versionEngine:FlxText;
	public var versionShit:FlxText;

	public static var outdate:Bool;

	public var settingIcon:FlxSprite;

	var Nit:Bool;

	//var ajustes_Button:FlxButton;

	//var optionpos:FlxPoint;

	//var mousepos:FlxPoint = new FlxPoint();
	//var _lastControllerMode:Bool = false;

	var settingsSprite:FlxSprite;
	var videoIcon:FlxSprite;

	var internet:String = '';
	var settingButton:FlxButton;
	var videoButton:FlxButton;

	public var username:TextField;

	var settingIcon_off:FlxSprite;

	public var ignoreWarnings = false;

	public static var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public static var selectedSomethin:Bool;

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'statistics',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'links'
		//#if !switch 'donate', #end
		//'options'
	];

	var magenta:FlxSprite;
	var mouseOption:FlxButton;
	var bg_vineta:FlxSprite;

	public function onEffect(Timer:FlxTimer):Void {
		FlxTween.tween(bgCG, {alpha: 0}, ClientPrefs.data.timetrans + 1, {
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(bgCG, {alpha: 1}, ClientPrefs.data.timetrans + 1, {
					onComplete: function (twn:FlxTween) {
					}
				});
			}
		});
	}

	public static function changeItem(huh:Int = 0)
		{
			curSelected += huh;
	
			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
	
			menuItems.forEach(function(spr:FlxSprite)
			{
				//spr.animation.play('idle');
				//spr.alpha = 0.3;
				if (spr.ID != curSelected) {
				FlxTween.tween(spr, {alpha: 0.3}, 0.3);
				}
				//spr.visible = false;
				spr.updateHitbox();
				//FlxTween.tween(spr.ID != curSelected, {x: -30}, 1);
	
				if (spr.ID == curSelected)
				{
					if (selectedSomethin == false) {
					FlxTween.tween(spr, {alpha: 1}, 0.4);
					var add:Float = 0;
					if(menuItems.length > 4) {
						add = menuItems.length * 8;
					}
					spr.centerOffsets();
				}
				if (selectedSomethin == true) {
					FlxTween.tween(spr, {alpha: 0.3}, 0.3);
				}
				}
			});
		}

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.sound.music.fadeIn(3, 0.1, 0.8);

		ClientPrefs.saveSettings();

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

//		transIn = FlxTransitionableState.defaultTransIn;
	//	transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xA5000000);

		bgCG = new FlxSprite(-80).loadGraphic(Paths.image('OMMenu'));
		bgCG.antialiasing = ClientPrefs.data.antialiasing;
		bgCG.scrollFactor.set(0, yScroll);
		bgCG.setGraphicSize(Std.int(bgCG.width * 1.175));
		bgCG.updateHitbox();
		bgCG.screenCenter();
		bgCG.alpha = 0;
		add(bgCG);
		FlxTween.tween(bgCG, {alpha: 1}, ClientPrefs.data.timetrans);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		videoIcon = new FlxSprite(0).loadGraphic(Paths.image('icons/Menu/videoIcon'));
		videoIcon.antialiasing = ClientPrefs.data.antialiasing;
		videoIcon.scrollFactor.set(0, yScroll);
		videoIcon.updateHitbox();
		videoIcon.updateHitbox();
		videoIcon.alpha = 1;

		settingIcon = new FlxSprite(0).loadGraphic(Paths.image('icons/Menu/settingIcon'));
		settingIcon.antialiasing = ClientPrefs.data.antialiasing;
		settingIcon.scrollFactor.set(0, yScroll);
		settingIcon.updateHitbox();
		settingIcon.updateHitbox();
		settingIcon.alpha = 1;
		//add(settingIcon);

		settingButton = new FlxButton(FlxG.width - 100, FlxG.height - 450, "", onClickSetting);
		settingButton.loadGraphicFromSprite(settingIcon);
		settingButton.scrollFactor.set();

		videoButton = new FlxButton(FlxG.width - 105, FlxG.height - 650, "", onClickVideo);
		videoButton.loadGraphicFromSprite(videoIcon);
		videoButton.scrollFactor.set();

		if (outdate != true) {
		if (TitleState.UpdateEC == false) selectedSomethin = false;
		if (TitleState.UpdateEC == true) selectedSomethin = true;
		}

		if (outdate == true) {
			selectedSomethin = false;
		}

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			//var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			//menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			//menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", ClientPrefs.data.SpritesFPS);
			//menuItem.animation.addByPrefix('selected', optionShit[i] + " white", ClientPrefs.data.SpritesFPS);
			//menuItem.animation.play('idle');
			var menuItem:FlxSprite = new FlxSprite(-500, (i * 115) + offset).loadGraphic(Paths.image('mainmenu/menu_' + optionShit[i]));
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.alpha = 0;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			FlxTween.tween(menuItem, {x: 0}, ClientPrefs.data.timetrans);
			FlxTween.tween(menuItem, {alpha: 0.5}, 0.2);
		}

		if (outdate != true) {
		if (TitleState.UpdateEC) {
			outdate = true;
			openSubState(new states.ActAvailableState());
		}
	}

		versionEngine = new FlxText(-100, FlxG.height - 24, 0, "Engine V" + engineVersion, 12);
		versionEngine.scrollFactor.set();
		versionEngine.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionEngine.alpha = 0;
		add(versionEngine);

		add(settingButton);
		add(videoButton);

		FlxTween.tween(versionEngine, {alpha: 1}, 0.5);
		FlxTween.tween(versionEngine, {x: 12}, 0.6, {
			onComplete: function (twn:FlxTween) {
				Nit = true;
			}
		});

		changeItem();

	TimerEffect = new FlxTimer();
	TimerEffect.start(ClientPrefs.data.timetrans + 3, onEffect, 0);

	#if android
	addVirtualPad(UP_DOWN, A_B);
	#end

		super.create();
	}

	public function onClickSetting() {
		if (Nit == true) {
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.sound.music.fadeOut(3, 0);
			FlxTween.tween(bgCG, {alpha: 0}, ClientPrefs.data.timetrans);
			FlxTween.tween(versionEngine, {x: -500}, 1);
			FlxTween.tween(settingButton, {x: FlxG.width + 40}, 1);
			FlxTween.tween(videoButton, {x: FlxG.width + 40}, 1);
			menuItems.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {x: -500}, 0.5, {
						onComplete: function(twn:FlxTween) {
							MusicBeatState.switchState(new options.OptionsState());
						}
					});
					Nit = false;

				});
		}
	}

	public function onClickVideo() {
		FlxG.sound.play(Paths.sound('confirmMenu'));
		CoolUtil.browserLoad(TitleState.releasevideolink);
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (settingButton.released) {
			settingButton.alpha = 0.5;
		}

		if (settingButton.justPressed) {
			settingButton.alpha = 1;
		}

		if (videoButton.released) {
			videoButton.alpha = 0.5;
		}

		if (videoButton.justPressed) {
			videoButton.alpha = 1;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.RED : 0x4CFF0000, 1);
				if (ClientPrefs.data.language == 'Spanish') {
					//add(new Notification(camAchievement, "Accion No Permitida..", "No te podemos dejar Regresar por el Bien de la optimizacion del Juego. Gracias", 1));
					add(new Notification('Accion no Permitida', "No te podemos dejar Regresar por el Bien de la optimizacion del Juego. Gracias", 1, camAchievement, 1));
					//FlxG.sound.play(Paths.sound('MenuSounds/notification-1'));
				}
				if (ClientPrefs.data.language == 'Inglish') {
					//add(new Notification(camAchievement, "Action Not Allowed..", "We cannot let you return for the sake of game optimization. Thank you", 1));
					add(new Notification('Action Not Allowed..', "We cannot let you return for the sake of game optimization. Thank you", 1, camAchievement, 1));
					FlxG.sound.play(Paths.sound('notificacion-1'));
				}
				if (ClientPrefs.data.language == 'Portuguese') {
					//add(new Notification(camAchievement, "Atualmente não disponível!", "Não podemos permitir que você retorne para otimizar o jogo. Obrigado", 1));
					add(new Notification('Atualmente não disponível!', "Não podemos permitir que você retorne para otimizar o jogo. Obrigado", 1, camAchievement, 1));
					FlxG.sound.play(Paths.sound('notificacion-1'));
				}
			}

		if (Nit == true) {
			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://gamebanana.com/wips/79622');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.sound.music.fadeOut(3, 0.3);
					//FlxTween.tween(menuItems, {alpha: 0}, 1);
					FlxTween.tween(bgCG, {alpha: 0}, 0.5);
					FlxTween.tween(versionEngine, {alpha: 0}, 0.5);
					FlxTween.tween(settingButton, {x: FlxG.width + 40}, 0.5);
					FlxTween.tween(videoButton, {x: FlxG.width + 40}, 0.5);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: -500}, 0.5);
							FlxTween.tween(spr, {x: -500}, 0.5, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(spr, {x: -500}, 0.5);
									Nit = false;
								}
							});
						}
						else
						{
							new FlxTimer().start(2, function(tmr:FlxTimer) {
								FlxTween.tween(spr, {x: -500}, 0.7,{
									onComplete: function(twn:FlxTween)
									{
										var daChoice:String = optionShit[curSelected];
		
										switch (daChoice)
										{
											case 'story_mode':
												MusicBeatState.switchState(new StoryMenuState());
											case 'freeplay':
												MusicBeatState.switchState(new FreeplayState());
											case 'statistics':
												MusicBeatState.switchState(new EstadisticsMenuState());
											/*#if MODS_ALLOWED
											case 'mods':
												MusicBeatState.switchState(new ModsMenuState());
											#end
											case 'awards':
												MusicBeatState.switchState(new AchievementsMenuState());*/
											case 'links':
												MusicBeatState.switchState(new LinksState());
										}
									}});
							});
						}
					});
				}
			}
		}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				if (TitleState.editorresult == true) {
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new MasterEditorMenu());
				}
				if (TitleState.editorresult == false) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.RED : 0x4CFF0000, 1);
				if (ClientPrefs.data.language == 'Spanish') {
					openSubState(new Prompt('Esta acción no esta permitida actualmente por el Admin.\n\nPide Permisos', 0, function() {
					},
					null, ignoreWarnings));
				//add(new Notification(camAchievement, "No Disponible Actualmente!", "Lastimosamente no se encuentra esta opcion habilitada en la V" + endingcorruptionVersion, 1));
			}
			if (ClientPrefs.data.language == 'Inglish') {
				openSubState(new Prompt('This action is not currently allowed by the Admin.\n\nRequest Permissions', 0, function() {
				},
				null, ignoreWarnings));
				//add(new Notification(camAchievement, "Not Currently Available!", "Unfortunately this option is not enabled in the V" + endingcorruptionVersion, 1));
			}
			if (ClientPrefs.data.language == 'Portuguese') {
				openSubState(new Prompt('Esta ação não é permitida atualmente pelo administrador.\n\nSolicitar permissões', 0, function() {
				},
				null, ignoreWarnings));
				//add(new Notification(camAchievement, "Atualmente não disponível!", "Infelizmente esta opção não está habilitada no V" + endingcorruptionVersion, 1));
			}
			//add(new Notification(camAchievement, "No Disponible Actualmente!", "Lastimosamente no se encuentra esta opcion habilitada en la V" + endingcorruptionVersion, false));
			}
		}
			#end
		}
		super.update(elapsed);
	}
}