package options;

class PluginSubState extends BaseOptionsMenu
{
    public function new()
        {
            title = 'Plugins Settings';
            rpcTitle = 'Plugins Settings Menu';

            MusicBeatState.updatestate("PluginsMenu");

            var option:Option = new Option("Color Plus",
            "A color effect that increases its intensity and saturation automatically",
            "colorplus",
            "bool");
            addOption(option);

            var option:Option = new Option("More Debug",
            "Increase the information in the titles in the corner for more information",
            "moredebug",
            "bool");
            addOption(option);

            var option:Option = new Option("Setings Max",
            "Increase priorities with your Preferences",
            "settingsmax",
            "bool");
            addOption(option);

            super();
        }
}