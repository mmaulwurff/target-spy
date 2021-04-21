/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2021
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Target Spy is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

class ts_Data
{

  Dictionary championTokens;
  Dictionary specialNames;

  static
  ts_Data from()
  {
    let result = new("ts_Data");

    result.championTokens = Dictionary.create();
    result.specialNames   = Dictionary.create();
    result._slaveActors   = Dictionary.create();
    result._blackList     = Dictionary.create();

    result.fillChampionTokens();
    result.fillSpecialNames();
    result.fillSlaveActors();
    result.fillBlackList();

    return result;
  }

  bool slaveActorsContain(string className) const
  {
    return _slaveActors.at(className).length() != 0;
  }

  bool blackListContains(string className) const
  {
    return _blackList.at(className).length() != 0;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void fillChampionTokens()
  {
    championTokens.insert( "champion_BlackToken"     , "Brutal"      );
    championTokens.insert( "champion_BlueToken"      , "Retaliating" );
    championTokens.insert( "champion_BronzeToken"    , "Tough"       );
    championTokens.insert( "champion_CyanToken"      , "Vortex"      );
    championTokens.insert( "champion_DarkGreenToken" , "Toxic"       );
    championTokens.insert( "champion_DarkRedToken"   , "Reanimating" );
    championTokens.insert( "champion_GoldToken"      , "Golden"      );
    championTokens.insert( "champion_GreenToken"     , "Phasing"     );
    championTokens.insert( "champion_GreyToken"      , "Nimble"      );
    championTokens.insert( "champion_IndigoToken"    , "Fissile"     );
    championTokens.insert( "champion_OrangeToken"    , "Exploding"   );
    championTokens.insert( "champion_PinkToken"      , "Healer"      );
    championTokens.insert( "champion_RedToken"       , "Sturdy"      );
    championTokens.insert( "champion_SilverToken"    , "Reflective"  );
    championTokens.insert( "champion_VioletToken"    , "Relentless"  );
    championTokens.insert( "champion_WhiteToken"     , "Restraining" );
    championTokens.insert( "champion_YellowToken"    , "Fast"        );
  }

  private
  void fillSpecialNames()
  {
    specialNames.insert( "Arachnotron_free"        , "Technospider"       );
    specialNames.insert( "Archvile"                , "Arch-vile"          );
    specialNames.insert( "Archvile_free"           , "Flame Bringer"      );
    specialNames.insert( "BD_Arachnotron"          , "Arachnotron"        );
    specialNames.insert( "BD_ArchVile"             , "Arch-vile"          );
    specialNames.insert( "BD_BaronOfHell"          , "Baron Of Hell"      );
    specialNames.insert( "BD_Cacodemon"            , "Cacodemon"          );
    specialNames.insert( "BD_ChaingunGuy"          , "Chaingunner"        );
    specialNames.insert( "BD_CyberDemon"           , "Cyberdemon"         );
    specialNames.insert( "BD_Demon"                , "Demon"              );
    specialNames.insert( "BD_DoomImp"              , "Imp"                );
    specialNames.insert( "BD_Fatso"                , "Mancubus"           );
    specialNames.insert( "BD_HellKnight"           , "Hell Knight"        );
    specialNames.insert( "BD_LostSoul"             , "Lost Soul"          );
    specialNames.insert( "BD_PainElemental"        , "Pain Elemental"     );
    specialNames.insert( "BD_Revenant"             , "Revenant"           );
    specialNames.insert( "BD_ShotgunGuy"           , "Sergeant"           );
    specialNames.insert( "BD_Spectre"              , "Spectre"            );
    specialNames.insert( "BD_SpiderMastermind"     , "Spider Mastermind"  );
    specialNames.insert( "BD_WolfensteinSS"        , "Wolfenstein SS"     );
    specialNames.insert( "BaronOfHell_free"        , "Pain Lord"          );
    specialNames.insert( "Cacodemon_free"          , "Trilobite"          );
    specialNames.insert( "ChaingunGuy"             , "Chaingunner"        );
    specialNames.insert( "ChaingunGuy_free"        , "Minigun Zombie"     );
    specialNames.insert( "CommanderKeen_free"      , "Alien Spawn"        );
    specialNames.insert( "Cyberdemon_free"         , "Assault Tripod"     );
    specialNames.insert( "Demon_free"              , "Flesh Worm"         );
    specialNames.insert( "DoomImp"                 , "Imp"                );
    specialNames.insert( "DoomImp_free"            , "Serpentipede"       );
    specialNames.insert( "EVPArachnotron"          , "Arachnotron"        );
    specialNames.insert( "EVPArchVile"             , "Arch-vile"          );
    specialNames.insert( "EVPBaron"                , "Baron Of Hell"      );
    specialNames.insert( "EVPCacodemon"            , "Cacodemon"          );
    specialNames.insert( "EVPChaingunner"          , "Chaingunner"        );
    specialNames.insert( "EVPCyberdemon"           , "Cyberdemon"         );
    specialNames.insert( "EVPDemon"                , "Demon"              );
    specialNames.insert( "EVPHellKnight"           , "Hell Knight"        );
    specialNames.insert( "EVPImp"                  , "Imp"                );
    specialNames.insert( "EVPLostSoul"             , "Lost Soul"          );
    specialNames.insert( "EVPMancubus"             , "Mancubus"           );
    specialNames.insert( "EVPPainElemental"        , "Pain Elemental"     );
    specialNames.insert( "EVPRevenant"             , "Revenant"           );
    specialNames.insert( "EVPShotgunner"           , "Sergeant"           );
    specialNames.insert( "EVPSpectre"              , "Spectre"            );
    specialNames.insert( "EVPSpiderMastermind"     , "Spider Mastermind"  );
    specialNames.insert( "Fatso"                   , "Mancubus"           );
    specialNames.insert( "Fatso_free"              , "Combat Slug"        );
    specialNames.insert( "LostSoul_free"           , "Deadflare"          );
    specialNames.insert( "PainElemental_free"      , "Summoner"           );
    specialNames.insert( "Revenant_free"           , "Dark Soldier"       );
    specialNames.insert( "ShotgunGuy"              , "Sergeant"           );
    specialNames.insert( "ShotgunGuy_free"         , "Shotgun Zombie"          );
    specialNames.insert( "SpiderMastermind_free"   , "Large Technospider"      );
    specialNames.insert( "WolfensteinSS_free"      , "Sailor"                  );
    specialNames.insert( "Zombieman_free"          , "Zombie"                  );
    specialNames.insert( "HellKnight_free"         , "Pain Bringer"            );
    specialNames.insert( "Cacodemon_rekkr"         , "Sorrow"                  );
    specialNames.insert( "Demon_rekkr"             , "Husk"                    );
    specialNames.insert( "Spectre_rekkr"           , "Mean Husk"               );
    specialNames.insert( "BaronOfHell_rekkr"       , "Treebeast"               );
    specialNames.insert( "HellKnight_rekkr"        , "Skelly Belly"            );
    specialNames.insert( "Zombieman_rekkr"         , "Former Human"            );
    specialNames.insert( "ShotgunGuy_rekkr"        , "Jackalope"               );
    specialNames.insert( "Archvile_rekkr"          , "Turret"                  );
    specialNames.insert( "Revenant_rekkr"          , "Mean Imp"                );
    specialNames.insert( "Fatso_rekkr"             , "Former Duke"             );
    specialNames.insert( "ChaingunGuy_rekkr"       , "Former King"             );
    specialNames.insert( "Chaingun_rekkr"          , "Former King"             );
    specialNames.insert( "LostSoul_rekkr"          , "Eyeball"                 );
    specialNames.insert( "SpiderMastermind_rekkr"  , "Dark Foe"                );
    specialNames.insert( "Cyberdemon_rekkr"        , "Dark Foe"                );
    specialNames.insert( "Arachnotron_rekkr"       , "Mean Jackalope"          );
    specialNames.insert( "WolfensteinSS_rekkr"     , "Grotesque"               );
    specialNames.insert( "DoomImp_rekkr"           , "Imp"                     );
    specialNames.insert( "HangNoGuts_rekkr"        , "Spider"                  );
    specialNames.insert( "DehackedPickup4_rekkr"   , "Soul Launcher"           );
    specialNames.insert( "DeadShotgunGuy_rekkr"    , "Remains of Grotesque"    );
    specialNames.insert( "DeadZombieMan_rekkr"     , "Remains of Former Human" );
    specialNames.insert( "DeadDemon_rekkr"         , "Remains of Husk"         );
    specialNames.insert( "DeadCacodemon_rekkr"     , "Remains of Sorrow"       );
    specialNames.insert( "GibbedMarineExtra_rekkr" , "Remains of Viking"       );
    specialNames.insert( "GibbedMarine_rekkr"      , "Remains of Viking"       );
    specialNames.insert( "HeadsOnAStick_rekkr"     , "Tree"                    );
    specialNames.insert( "CommanderKeen_rekkr"     , "Bottled Health"          );
    specialNames.insert( "DehackedPickup14_rekkr"  , "Platemail Armor"         );
    specialNames.insert( "DehackedPickup13_rekkr"  , "Ringmail Armor"          );
    specialNames.insert( "DehackedPickup16_rekkr"  , "Health Essence"          );
    specialNames.insert( "Medikit_rekkr"           , "Bottled Health"          );
    specialNames.insert( "DehackedPickup15_rekkr"  , "Medicinal Herb"          );
    specialNames.insert( "ArmorBonus_rekkr"        , "Armor Patch"             );
    specialNames.insert( "Backpack_rekkr"          , "Sack of Carrying"        );
    specialNames.insert( "DehackedPickup12_rekkr"  , "Mana Seal"               );
    specialNames.insert( "DehackedPickup0_rekkr"   , "Mana Sprite"             );
    specialNames.insert( "RocketBox_rekkr"         , "Stack of Runes"          );
    specialNames.insert( "RocketAmmo_rekkr"        , "Rune"                    );
    specialNames.insert( "ShellBox_rekkr"          , "Sack of Steelshot"       );
    specialNames.insert( "Shell_rekkr"             , "Steelshot"               );
    specialNames.insert( "ClipBox_rekkr"           , "Soul Prism"              );
    specialNames.insert( "Berserk_rekkr"           , "WODE"                    );
    specialNames.insert( "Allmap_rekkr"            , "Map of the Area"         );
    specialNames.insert( "RadSuit_rekkr"           , "Boots of Protection"     );
    specialNames.insert( "DehackedPickup17_rekkr"  , "Shamans Brew"            );
    specialNames.insert( "DehackedPickup18_rekkr"  , "Ethereal Guard"          );
    specialNames.insert( "DehackedPickup19_rekkr"  , "Cloak of deceit"         );
    specialNames.insert( "DehackedPickup20_rekkr"  , "Torch"                   );
    specialNames.insert( "DehackedPickup21_rekkr"  , "Soul"                    );
    specialNames.insert( "DeadMarine_rekkr"        , "Dead Body"               );
    specialNames.insert( "DeadLostSoul_rekkr"      , "Remains of Eyeball"      );
    specialNames.insert( "LiveStick_rekkr"         , "Puppy"                   );
    specialNames.insert( "HeadOnAStick_rekkr"      , "Grass"                   );
    specialNames.insert( "Gibs_rekkr"              , "Blood"                   );
    specialNames.insert( "DehackedPickup5_rekkr"   , "Soul"                    );
    specialNames.insert( "DeadStick_rekkr"         , "Dead Body"               );
    specialNames.insert( "RedCard_rekkr"           , "Red Key"                 );
    specialNames.insert( "BlueCard_rekkr"          , "Blue Key"                );
    specialNames.insert( "YellowCard_rekkr"        , "Yellow Key"              );
    specialNames.insert( "ExplosiveBarrel_rekkr"   , "Barrel"                  );
    specialNames.insert( "RedSkull_rekkr"          , "Red Skeleton Key"        );
    specialNames.insert( "BlueSkull_rekkr"         , "Blue Skeleton Key"       );
    specialNames.insert( "YellowSkull_rekkr"       , "Yellow Skeleton Key"     );
    specialNames.insert( "DehackedPickup11_rekkr"  , "Blessing of the Gods"    );
    specialNames.insert( "DehackedPickup10_rekkr"  , "Holy Relic"              );
    specialNames.insert( "DehackedPickup8_rekkr"   , "Runic Staff"             );
    specialNames.insert( "DehackedPickup9_rekkr"   , "Axe"                     );
    specialNames.insert( "NonsolidTwitch_rekkr"    , "Bell"                    );
    specialNames.insert( "HeartColumn_rekkr"       , "Viking"                  );
    specialNames.insert( "HangTLookingUp_rekkr"    , "Hanging Body"            );
    specialNames.insert( "SmallBloodPool_rekkr"    , "Hanging Body"            );
  }

  private
  void fillSlaveActors()
  {
    _slaveActors.insert( "HeadshotTargetZombie"        , "1" );
    _slaveActors.insert( "HeadshotTargetEliteZombie"   , "1" );
    _slaveActors.insert( "HeadshotTargetImp"           , "1" );
    _slaveActors.insert( "HeadshotTargetAngryImp"      , "1" );
    _slaveActors.insert( "HeadshotTargetNoble"         , "1" );
    _slaveActors.insert( "HeadshotTargetEliteNoble"    , "1" );
    _slaveActors.insert( "HeadshotTargetBossNoble"     , "1" );
    _slaveActors.insert( "HeadshotTargetArchvile"      , "1" );
    _slaveActors.insert( "HeadshotTargetEliteArchvile" , "1" );
    _slaveActors.insert( "HeadshotTargetRevenant"      , "1" );
    _slaveActors.insert( "HeadshotTargetEliteRevenant" , "1" );
    _slaveActors.insert( "HeadshotTargetMancubus"      , "1" );
    _slaveActors.insert( "HeadshotTargetSoulCommander" , "1" );
    _slaveActors.insert( "HeadshotTargetCacodemon"     , "1" );
    _slaveActors.insert( "HeadshotTargetPainElemental" , "1" );
    _slaveActors.insert( "HeadshotTargetDemon"         , "1" );
    _slaveActors.insert( "HeadshotTargetCyberdemon"    , "1" );
  }

  private
  void fillBlackList()
  {
    _blackList.insert( "m8f_aas_token"           , "1" );
    _blackList.insert( "AutoautosaveToken"       , "1" );
    _blackList.insert( "AutoautosaveAlertToken"  , "1" );
    _blackList.insert( "AutoautosaveAlerter"     , "1" );
    _blackList.insert( "AutoautosaveBossAlerter" , "1" );
    _blackList.insert( "UGGib_Corpse_Shootable"  , "1" );
    _blackList.insert( "VoidField"               , "1" );
    _blackList.insert( "Cow"                     , "1" );
    _blackList.insert( "WinterCow"               , "1" );
    _blackList.insert( "SpaceCow"                , "1" );
    _blackList.insert( "SpaceCowFloating"        , "1" );
    _blackList.insert( "CowboyCow"               , "1" );
    _blackList.insert( "MummyCow"                , "1" );
    _blackList.insert( "ShieldDefense"           , "1" );
    _blackList.insert( "ShieldDefense2"          , "1" );
  }

  private Dictionary _slaveActors;
  private Dictionary _blackList;

} // class ts_Data
