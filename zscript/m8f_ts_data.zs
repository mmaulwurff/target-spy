/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2020
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Target Spy is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

class m8f_ts_StringSet
{

  private Array<string> values;

  void print()
  {
    uint size = values.size();
    Console.Printf("Size: %d", size);
    for (int i = 0; i < size; ++i)
      {
        Console.Printf(values[i]);
      }
  }

  void push(string s)
  {
    // array is sorted
    uint size = values.size();
    uint i    = 0;
    for (; i < size && values[i] < s; ++i);
    values.insert(i, s);
  }

  bool contains(string s)
  {
    // binary search
    int size = values.size();
    int L    = 0;
    int R    = size - 1;

    while (L <= R)
      {
        int m = (L + R) / 2;
        string current = values[m];
        if      (current <  s) { L = m + 1; }
        else if (current >  s) { R = m - 1; }
        else if (current == s) { return true; }
      }
    return false;
  }

} // class m8f_ts_StringSet

class m8f_ts_StringMap
{

  private Array<string> keys;
  private Array<string> values;

  void print()
  {
    uint size = values.size();
    Console.Printf("Size: %d", size);
    for (int i = 0; i < size; ++i)
      {
        Console.Printf("%s: %s", keys[i], values[i]);
      }
  }

  void push(string key, string value)
  {
    // array is sorted
    uint size = values.size();
    uint i    = 0;
    for (; i < size && keys[i] < key; ++i);
    keys.insert(i, key);
    values.insert(i, value);
  }

  string get(string key)
  {
    // binary search
    int size = values.size();
    int L    = 0;
    int R    = size - 1;

    while (L <= R)
      {
        int m = (L + R) / 2;
        string current = keys[m];
        if      (current <  key) { L = m + 1; }
        else if (current >  key) { R = m - 1; }
        else if (current == key) { return values[m]; }
      }
    return "";
  }
}

class m8f_ts_StringSetTester : Actor
{
  States { Spawn: TNT1 A 0; TNT1 A 0
    {

      let set = new("m8f_ts_StringSet");
      set.push("3three");
      set.push("2two");
      set.push("1one");
      set.push("4");
      set.push("2two");
      set.print();

      Console.Printf("%d", set.contains("4"));
      Console.Printf("%d", set.contains("5"));
      Console.Printf("%d", set.contains("2two"));

    } stop; }

} // class m8f_ts_StringMap

class m8f_ts_StringMapTester : Actor
{

  States { Spawn: TNT1 A 0; TNT1 A 0
    {

      let set = new("m8f_ts_StringMap");
      set.push("3", "three");
      set.push("2", "two");
      set.push("1", "one");
      set.push("4", "four");
      set.push("2", "two");
      set.print();

      Console.Printf("%s", set.get("4"));
      Console.Printf("%s", set.get("5"));
      Console.Printf("%s", set.get("2two"));
      Console.Printf("%s", set.get("2"));

    } stop; }

} // class m8f_ts_StringMapTester

class m8f_ts_Data
{
  m8f_ts_StringMap championTokens;
  m8f_ts_StringMap specialNames;
  m8f_ts_StringSet slaveActors;
  m8f_ts_StringSet blackList;

  m8f_ts_Data init()
  {
    championTokens = new("m8f_ts_StringMap");
    specialNames   = new("m8f_ts_StringMap");
    slaveActors    = new("m8f_ts_StringSet");
    blackList      = new("m8f_ts_StringSet");

    fillChampionTokens();
    fillSpecialNames();
    fillSlaveActors();
    fillBlackList();

    return self;
  }

  private void fillChampionTokens()
  {
    championTokens.push( "champion_BlackToken"     , "Brutal"      );
    championTokens.push( "champion_BlueToken"      , "Retaliating" );
    championTokens.push( "champion_BronzeToken"    , "Tough"       );
    championTokens.push( "champion_CyanToken"      , "Vortex"      );
    championTokens.push( "champion_DarkGreenToken" , "Toxic"       );
    championTokens.push( "champion_DarkRedToken"   , "Reanimating" );
    championTokens.push( "champion_GoldToken"      , "Golden"      );
    championTokens.push( "champion_GreenToken"     , "Phasing"     );
    championTokens.push( "champion_GreyToken"      , "Nimble"      );
    championTokens.push( "champion_IndigoToken"    , "Fissile"     );
    championTokens.push( "champion_OrangeToken"    , "Exploding"   );
    championTokens.push( "champion_PinkToken"      , "Healer"      );
    championTokens.push( "champion_RedToken"       , "Sturdy"      );
    championTokens.push( "champion_SilverToken"    , "Reflective"  );
    championTokens.push( "champion_VioletToken"    , "Relentless"  );
    championTokens.push( "champion_WhiteToken"     , "Restraining" );
    championTokens.push( "champion_YellowToken"    , "Fast"        );
  }

  private void fillSpecialNames()
  {
    specialNames.push( "Arachnotron_free"        , "Technospider"       );
    specialNames.push( "Archvile"                , "Arch-vile"          );
    specialNames.push( "Archvile_free"           , "Flame Bringer"      );
    specialNames.push( "BD_Arachnotron"          , "Arachnotron"        );
    specialNames.push( "BD_ArchVile"             , "Arch-vile"          );
    specialNames.push( "BD_BaronOfHell"          , "Baron Of Hell"      );
    specialNames.push( "BD_Cacodemon"            , "Cacodemon"          );
    specialNames.push( "BD_ChaingunGuy"          , "Chaingunner"        );
    specialNames.push( "BD_CyberDemon"           , "Cyberdemon"         );
    specialNames.push( "BD_Demon"                , "Demon"              );
    specialNames.push( "BD_DoomImp"              , "Imp"                );
    specialNames.push( "BD_Fatso"                , "Mancubus"           );
    specialNames.push( "BD_HellKnight"           , "Hell Knight"        );
    specialNames.push( "BD_LostSoul"             , "Lost Soul"          );
    specialNames.push( "BD_PainElemental"        , "Pain Elemental"     );
    specialNames.push( "BD_Revenant"             , "Revenant"           );
    specialNames.push( "BD_ShotgunGuy"           , "Sergeant"           );
    specialNames.push( "BD_Spectre"              , "Spectre"            );
    specialNames.push( "BD_SpiderMastermind"     , "Spider Mastermind"  );
    specialNames.push( "BD_WolfensteinSS"        , "Wolfenstein SS"     );
    specialNames.push( "BaronOfHell_free"        , "Pain Lord"          );
    specialNames.push( "Cacodemon_free"          , "Trilobite"          );
    specialNames.push( "ChaingunGuy"             , "Chaingunner"        );
    specialNames.push( "ChaingunGuy_free"        , "Minigun Zombie"     );
    specialNames.push( "CommanderKeen_free"      , "Alien Spawn"        );
    specialNames.push( "Cyberdemon_free"         , "Assault Tripod"     );
    specialNames.push( "Demon_free"              , "Flesh Worm"         );
    specialNames.push( "DoomImp"                 , "Imp"                );
    specialNames.push( "DoomImp_free"            , "Serpentipede"       );
    specialNames.push( "EVPArachnotron"          , "Arachnotron"        );
    specialNames.push( "EVPArchVile"             , "Arch-vile"          );
    specialNames.push( "EVPBaron"                , "Baron Of Hell"      );
    specialNames.push( "EVPCacodemon"            , "Cacodemon"          );
    specialNames.push( "EVPChaingunner"          , "Chaingunner"        );
    specialNames.push( "EVPCyberdemon"           , "Cyberdemon"         );
    specialNames.push( "EVPDemon"                , "Demon"              );
    specialNames.push( "EVPHellKnight"           , "Hell Knight"        );
    specialNames.push( "EVPImp"                  , "Imp"                );
    specialNames.push( "EVPLostSoul"             , "Lost Soul"          );
    specialNames.push( "EVPMancubus"             , "Mancubus"           );
    specialNames.push( "EVPPainElemental"        , "Pain Elemental"     );
    specialNames.push( "EVPRevenant"             , "Revenant"           );
    specialNames.push( "EVPShotgunner"           , "Sergeant"           );
    specialNames.push( "EVPSpectre"              , "Spectre"            );
    specialNames.push( "EVPSpiderMastermind"     , "Spider Mastermind"  );
    specialNames.push( "Fatso"                   , "Mancubus"           );
    specialNames.push( "Fatso_free"              , "Combat Slug"        );
    specialNames.push( "LostSoul_free"           , "Deadflare"          );
    specialNames.push( "PainElemental_free"      , "Summoner"           );
    specialNames.push( "Revenant_free"           , "Dark Soldier"       );
    specialNames.push( "ShotgunGuy"              , "Sergeant"           );
    specialNames.push( "ShotgunGuy_free"         , "Shotgun Zombie"          );
    specialNames.push( "SpiderMastermind_free"   , "Large Technospider"      );
    specialNames.push( "WolfensteinSS_free"      , "Sailor"                  );
    specialNames.push( "ZombieMan_free"          , "Zombie"                  );
    specialNames.push( "Cacodemon_rekkr"         , "Sorrow"                  );
    specialNames.push( "Demon_rekkr"             , "Husk"                    );
    specialNames.push( "Spectre_rekkr"           , "Mean Husk"               );
    specialNames.push( "BaronOfHell_rekkr"       , "Treebeast"               );
    specialNames.push( "HellKnight_rekkr"        , "Skelly Belly"            );
    specialNames.push( "Zombieman_rekkr"         , "Former Human"            );
    specialNames.push( "ShotgunGuy_rekkr"        , "Jackalope"               );
    specialNames.push( "Archvile_rekkr"          , "Turret"                  );
    specialNames.push( "Revenant_rekkr"          , "Mean Imp"                );
    specialNames.push( "Fatso_rekkr"             , "Former Duke"             );
    specialNames.push( "ChaingunGuy_rekkr"       , "Former King"             );
    specialNames.push( "Chaingun_rekkr"          , "Former King"             );
    specialNames.push( "LostSoul_rekkr"          , "Eyeball"                 );
    specialNames.push( "SpiderMastermind_rekkr"  , "Dark Foe"                );
    specialNames.push( "Cyberdemon_rekkr"        , "Dark Foe"                );
    specialNames.push( "Arachnotron_rekkr"       , "Mean Jackalope"          );
    specialNames.push( "WolfensteinSS_rekkr"     , "Grotesque"               );
    specialNames.push( "DoomImp_rekkr"           , "Imp"                     );
    specialNames.push( "HangNoGuts_rekkr"        , "Spider"                  );
    specialNames.push( "DehackedPickup4_rekkr"   , "Soul Launcher"           );
    specialNames.push( "DeadShotgunGuy_rekkr"    , "Remains of Grotesque"    );
    specialNames.push( "DeadZombieMan_rekkr"     , "Remains of Former Human" );
    specialNames.push( "DeadDemon_rekkr"         , "Remains of Husk"         );
    specialNames.push( "DeadCacodemon_rekkr"     , "Remains of Sorrow"       );
    specialNames.push( "GibbedMarineExtra_rekkr" , "Remains of Viking"       );
    specialNames.push( "GibbedMarine_rekkr"      , "Remains of Viking"       );
    specialNames.push( "HeadsOnAStick_rekkr"     , "Tree"                    );
    specialNames.push( "CommanderKeen_rekkr"     , "Bottled Health"          );
    specialNames.push( "DehackedPickup14_rekkr"  , "Platemail Armor"         );
    specialNames.push( "DehackedPickup13_rekkr"  , "Ringmail Armor"          );
    specialNames.push( "DehackedPickup16_rekkr"  , "Health Essence"          );
    specialNames.push( "Medikit_rekkr"           , "Bottled Health"          );
    specialNames.push( "DehackedPickup15_rekkr"  , "Medicinal Herb"          );
    specialNames.push( "ArmorBonus_rekkr"        , "Armor Patch"             );
    specialNames.push( "Backpack_rekkr"          , "Sack of Carrying"        );
    specialNames.push( "DehackedPickup12_rekkr"  , "Mana Seal"               );
    specialNames.push( "DehackedPickup0_rekkr"   , "Mana Sprite"             );
    specialNames.push( "RocketBox_rekkr"         , "Stack of Runes"          );
    specialNames.push( "RocketAmmo_rekkr"        , "Rune"                    );
    specialNames.push( "ShellBox_rekkr"          , "Sack of Steelshot"       );
    specialNames.push( "Shell_rekkr"             , "Steelshot"               );
    specialNames.push( "ClipBox_rekkr"           , "Soul Prism"              );
    specialNames.push( "Berserk_rekkr"           , "WODE"                    );
    specialNames.push( "Allmap_rekkr"            , "Map of the Area"         );
    specialNames.push( "RadSuit_rekkr"           , "Boots of Protection"     );
    specialNames.push( "DehackedPickup17_rekkr"  , "Shamans Brew"            );
    specialNames.push( "DehackedPickup18_rekkr"  , "Ethereal Guard"          );
    specialNames.push( "DehackedPickup19_rekkr"  , "Cloak of deceit"         );
    specialNames.push( "DehackedPickup20_rekkr"  , "Torch"                   );
    specialNames.push( "DehackedPickup21_rekkr"  , "Soul"                    );
    specialNames.push( "DeadMarine_rekkr"        , "Dead Body"               );
    specialNames.push( "DeadLostSoul_rekkr"      , "Remains of Eyeball"      );
    specialNames.push( "LiveStick_rekkr"         , "Puppy"                   );
    specialNames.push( "HeadOnAStick_rekkr"      , "Grass"                   );
    specialNames.push( "Gibs_rekkr"              , "Blood"                   );
    specialNames.push( "DehackedPickup5_rekkr"   , "Soul"                    );
    specialNames.push( "DeadStick_rekkr"         , "Dead Body"               );
    specialNames.push( "RedCard_rekkr"           , "Red Key"                 );
    specialNames.push( "BlueCard_rekkr"          , "Blue Key"                );
    specialNames.push( "YellowCard_rekkr"        , "Yellow Key"              );
    specialNames.push( "ExplosiveBarrel_rekkr"   , "Barrel"                  );
    specialNames.push( "RedSkull_rekkr"          , "Red Skeleton Key"        );
    specialNames.push( "BlueSkull_rekkr"         , "Blue Skeleton Key"       );
    specialNames.push( "YellowSkull_rekkr"       , "Yellow Skeleton Key"     );
    specialNames.push( "DehackedPickup11_rekkr"  , "Blessing of the Gods"    );
    specialNames.push( "DehackedPickup10_rekkr"  , "Holy Relic"              );
    specialNames.push( "DehackedPickup8_rekkr"   , "Runic Staff"             );
    specialNames.push( "DehackedPickup9_rekkr"   , "Axe"                     );
    specialNames.push( "NonsolidTwitch_rekkr"    , "Bell"                    );
    specialNames.push( "HeartColumn_rekkr"       , "Viking"                  );
    specialNames.push( "HangTLookingUp_rekkr"    , "Hanging Body"            );
    specialNames.push( "SmallBloodPool_rekkr"    , "Hanging Body"            );
  }

  private void fillSlaveActors()
  {
    slaveActors.push( "HeadshotTargetZombie"        );
    slaveActors.push( "HeadshotTargetEliteZombie"   );
    slaveActors.push( "HeadshotTargetImp"           );
    slaveActors.push( "HeadshotTargetAngryImp"      );
    slaveActors.push( "HeadshotTargetNoble"         );
    slaveActors.push( "HeadshotTargetEliteNoble"    );
    slaveActors.push( "HeadshotTargetBossNoble"     );
    slaveActors.push( "HeadshotTargetArchvile"      );
    slaveActors.push( "HeadshotTargetEliteArchvile" );
    slaveActors.push( "HeadshotTargetRevenant"      );
    slaveActors.push( "HeadshotTargetEliteRevenant" );
    slaveActors.push( "HeadshotTargetMancubus"      );
    slaveActors.push( "HeadshotTargetSoulCommander" );
    slaveActors.push( "HeadshotTargetCacodemon"     );
    slaveActors.push( "HeadshotTargetPainElemental" );
    slaveActors.push( "HeadshotTargetDemon"         );
    slaveActors.push( "HeadshotTargetCyberdemon"    );
  }

  private void fillBlackList()
  {
    blackList.push( "m8f_aas_token"           );
    blackList.push( "AutoautosaveToken"       );
    blackList.push( "AutoautosaveAlertToken"  );
    blackList.push( "AutoautosaveAlerter"     );
    blackList.push( "AutoautosaveBossAlerter" );
    blackList.push( "UGGib_Corpse_Shootable"  );
    blackList.push( "VoidField"               );
    blackList.push( "Cow"                     );
    blackList.push( "WinterCow"               );
    blackList.push( "SpaceCow"                );
    blackList.push( "SpaceCowFloating"        );
    blackList.push( "CowboyCow"               );
    blackList.push( "MummyCow"                );
  }

} // class m8f_ts_Data
