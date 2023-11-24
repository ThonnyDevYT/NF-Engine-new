package states;

import states.stages.IntroState;
import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
//
import options.OptionsState;

class PreloadingState extends MusicBeatState
{
    public static var WarnText2:FlxText;
    public var bg:FlxSprite;
    var updateV:String;
    public static var WarnTextBack:FlxText;
    var Press:Bool = false;

    override function create() {
        super.create();
        
        ClientPrefs.loadPrefs();

        bg = new FlxSprite().loadGraphic(Paths.image('BGMenu/TitleMenu'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.alpha = 0;
        add(bg);
        FlxTween.tween(bg, {alpha: 1}, 1);

        WarnText2 = new FlxText(0, 0, FlxG.width,
            "Welcome to Ending Corruption Android\n\nBefore we start we need you to configure some things.\n\nPress 'A' to set or 'B' to Skip",32);
        WarnText2.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        WarnText2.screenCenter();
       // WarnText2.visible = true;
       WarnText2.alpha = 0;
        add(WarnText2);
        FlxTween.tween(WarnText2, {alpha: 1}, 1);

        WarnTextBack = new FlxText(0, 0, FlxG.width,"Press [B] to Start Game!\n\nPreferences are loaded at startup",32);
        WarnTextBack.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        WarnTextBack.screenCenter();
        WarnTextBack.alpha = 0;

       FlxG.cameras.fade(FlxColor.BLACK, 1, true);

	    #if android
		    addVirtualPad(NONE, A_B);
	    #end
    }

    override function closeSubState() {
		super.closeSubState();
		#if android
        addVirtualPad(NONE, B);
        #end
		ClientPrefs.saveSettings();
	}

    override function update(elapsed:Float)
    {
            if (controls.ACCEPT) {
                ClientPrefs.data.Welcome = true;
                  ClientPrefs.saveSettings();
                  ClientPrefs.loadPrefs();
                  Press = true;
                  FlxG.sound.play(Paths.sound('confirmMenu'));
                  #if android removeVirtualPad(); #end
                        FlxTween.tween(WarnText2, {alpha: 0}, 4, {
                            onComplete: function (twn:FlxTween) {
                                openSubState(new options.InitialSettings());
                                add(WarnTextBack);
                                FlxTween.tween(WarnTextBack, {alpha: 1}, 4.2);
                        }});
                    }
        
            if (controls.BACK) {
            ClientPrefs.data.Welcome = true;
            ClientPrefs.saveSettings();
            ClientPrefs.loadPrefs();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.camera.fade(FlxColor.BLACK, 1, false);

            FlxTween.tween(bg, {alpha: 0}, 1.2, {
                onComplete: function (twn:FlxTween) {
                    ClientPrefs.loadPrefs();
                   MusicBeatState.switchState(new TitleState());
                }
            });
        }
        super.update(elapsed);
    }
}
