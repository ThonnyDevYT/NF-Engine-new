package states;

import sys.Http;
import haxe.io.Bytes;
import haxe.io.Path;
import options.OptionsState;
import flixel.FlxBasic;
import backend.ClientPrefs;
import flixel.tweens.FlxTween;

//Actualizacion automatica
#if AUTO
import sys.net.Address;
import sys.Http;
import sys.FileSystem;
import haxe.Http;
import sys.io.File;
#end

class ActAvailableState extends MusicBeatSubstate{
    
    var warnText:FlxText;
    var errorText:FlxText;

    public var bg:FlxSprite;
    var selected:Bool = false;

    public var SubMenu:Bool = false;
    
    override function create() {
        super.create();

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('BGMenu/BlackM'));
        bg.setGraphicSize(FlxG.width + 200, FlxG.height + 200);
        bg.alpha = 0.9;
        add(bg);

        if (ClientPrefs.data.language == 'Inglish') {
        errorText = new FlxText(0, 0, FlxG.width, "Ohh.. \n\nIt seems that automatic updating is not enabled in your version.\n\nPress 'ENTER' again to be redirected to the web page\n\nor\n\nPress 'ESCAPE' to continue", 32);
        }
        if (ClientPrefs.data.language == 'Spanish' || ClientPrefs.data.language == 'Portuguese') {
            errorText = new FlxText(0, 0, FlxG.width, "Oh.. \n\nParece que la actualización automatica no tienen permitido actualizaciones Grandes.\n\nVuelva a Presionar 'ENTER' Para ir al canal de Youtube\n\no\n\nPresione 'ESCAPE' para continuar", 32);
        }
        errorText.setFormat("miss.ttf", 32, FlxColor.WHITE, CENTER);
        errorText.screenCenter(Y);
        errorText.visible = false;

        if (ClientPrefs.data.language == 'Inglish') {
        warnText = new FlxText(0, 0, FlxG.width,
            "Hey! Apparently there is already a new version available!\n\nYou are in the version: (" + MainMenuState.endingcorruptionVersion + "),\n\nPlease Update to " + TitleState.updateVersionEC + "!\n\nPress 'ENTER' TO Start Update.\n\nThank you for playing Ending Corruption!",32);
        }
        if (ClientPrefs.data.language == 'Spanish' || ClientPrefs.data.language == 'Portuguese') {
            warnText = new FlxText(0, 0, FlxG.width,
                "¡Ey! ¡Al parecer ya hay una nueva version disponible!\n\nTu estas en la version: (" + MainMenuState.endingcorruptionVersion + "),\n\nPor favor actualice a " + TitleState.updateVersionEC + "!\n\nPresione 'ENTER' Para iniciar la actualizacion.\n\n¡Gracias por jugar Ending Corruption!",32); 
        }
        //if ClientPrefs.data.language = "Inglish" //Po alguna razon no carga el ClientPrefs

        //}
            warnText.setFormat("miss.ttf", 32, FlxColor.WHITE, CENTER);
            warnText.screenCenter(Y);
            warnText.visible = true;
            warnText.alpha = 1;
            add(warnText);
            add(errorText);
    }

    override function update(elapsed:Float) {

        if (FlxG.keys.justPressed.ENTER) {
            MusicBeatState.switchState(new states.editors.UpdatingState());
            FlxG.sound.play(Paths.sound('confirmMenu'));
        }

        if (FlxG.mouse.justPressed || FlxG.mouse.justPressedMiddle) {
            MusicBeatState.switchState(new states.editors.UpdatingState());
            FlxG.sound.play(Paths.sound('confirmMenu'));
		}

        if (FlxG.mouse.justPressedRight) {
            selected = true;
        }
        
        if (controls.BACK || selected == true) {
            FlxG.sound.play(Paths.sound('cancelMenu'));

            FlxTween.tween(bg, {alpha: 0}, 2);
            FlxTween.tween(warnText, {alpha: 0}, 1);
            FlxTween.tween(warnText, {alpha: 0}, 1, {
                onComplete: function (twn:FlxTween) {
                    SubMenu = true;
                    MainMenuState.selectedSomethin = false;
                    bg.alpha = 0;
                    MainMenuState.curSelected = 0;
                    MainMenuState.changeItem();
                    close();
                }
            });
        }
        super.update(elapsed);
    }
}