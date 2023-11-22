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

    var selected:Bool = false;

    public var SubMenu:Bool = false;
    
    override function create() {
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x000000);
        bg.alpha = 1;
        bg.visible = true;
        add(bg);

        if (ClientPrefs.data.language == 'Inglish') {
        errorText = new FlxText(0, 0, FlxG.width, "Ohh.. \n\nIt seems that automatic updating is not enabled in your version.\n\nPress 'ENTER' again to be redirected to the web page\n\nor\n\nPress 'ESCAPE' to continue", 32);
        }
        if (ClientPrefs.data.language == 'Spanish' || ClientPrefs.data.language == 'Portuguese') {
            errorText = new FlxText(0, 0, FlxG.width, "Oh.. \n\nParece que la actualización automática no está habilitada en tu versión.\n\nVuelva a Presionar 'ENTER' Para ser Redirigido a la Pagina Web\n\no\n\nPresione 'ESCAPE' para continuar", 32);
        }
        errorText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        errorText.screenCenter(Y);
        errorText.visible = false;

        if (ClientPrefs.data.language == 'Inglish') {
        warnText = new FlxText(0, 0, FlxG.width,
            "Hey! Apparently there is already a new version available!\n\nYou are in the version: (" + MainMenuState.endingcorruptionVersion + "),\n\nPlease Update to " + TitleState.updateVersionEC + "!\n\nPress 'ENTER' TO Start Update.\n\nThank you for playing Ending Corruption!",32);
        }
        if (ClientPrefs.data.language == 'Spanish' || ClientPrefs.data.language == 'Portuguese') {
            warnText = new FlxText(0, 0, FlxG.width,
                "¡Ey! ¡Al parecer ya hay una nueva versión disponible!\n\nTu estas en la version: (" + MainMenuState.endingcorruptionVersion + "),\n\nPor favor actualice a " + TitleState.updateVersionEC + "!\n\nPresione 'ENTER' Para iniciar la actualización.\n\n¡Gracias por jugar Ending Corruption!",32); 
        }
        //if ClientPrefs.data.language = "Inglish" //Po alguna razon no carga el ClientPrefs

        //}
            warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
            warnText.screenCenter(Y);
            warnText.visible = true;
            warnText.alpha = 1;
            add(warnText);
            add(errorText);

            #if android
            addVirtualPad(NONE, A_B);
            #end
    }

    override function update(elapsed:Float) {

        if (controls.ACCEPT) {
            if (warnText.alpha == 1) {
            if (ClientPrefs.data.demo == true) {
                if (ClientPrefs.data.flashing == true) {
                FlxG.camera.flash(0x38FF0000, 1);
                }
                FlxTween.tween(warnText, {alpha: 0}, 0.6);
                warnText.visible = false;
                errorText.visible = true;
            }
            if (ClientPrefs.data.demo == false) { 
            //MusicBeatState.switchState(new states.editors.UpdatingState());
            FlxG.sound.play(Paths.sound('confirmMenu'));
            }
        }

            if (controls.ACCEPT) {
                if (warnText.alpha == 0) {
                    CoolUtil.browserLoad('https://gamebanana.com/wips/79622');
                }
            }
        }
        
        if (controls.BACK && selected == false) {
            FlxG.sound.play(Paths.sound('cancelMenu'));

            FlxTween.tween(warnText, {alpha: 0}, 2, {
                onComplete: function (twn:FlxTween) {
                    SubMenu = true;
                    MainMenuState.selectedSomethin = false;
                    MainMenuState.bg.visible = false;
                    MainMenuState.curSelected = 0;
                    MainMenuState.changeItem(-1);
                    close();
                }
            });
        }
        super.update(elapsed);
    }
}